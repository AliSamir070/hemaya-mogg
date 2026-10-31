import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dart_meteor/dart_meteor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../resources/api_result.dart';
import '../../resources/constants_manager.dart';

export 'package:dart_meteor/dart_meteor.dart';

/// Core service responsible for handling all Meteor DDP operations
/// using `dart_meteor` (v4.1.0), including connection management,
/// RPC method calls, real-time publications/subscriptions, reactive
/// collections, and user account authentication.
@singleton
class MeteorService {
  MeteorClient _client;
  final Logger _logger = Logger();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  MeteorService(this._client) {
    _startConnectivityListener();
  }

  /// Listens to OS network changes so that when internet is restored,
  /// Meteor immediately resets retry backoff and reconnects via [checkLiveness].
  void _startConnectivityListener() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      final hasConnection = results.any(
        (result) =>
            result == ConnectivityResult.wifi ||
            result == ConnectivityResult.mobile ||
            result == ConnectivityResult.ethernet ||
            result == ConnectivityResult.vpn,
      );

      if (hasConnection) {
        _logger.i(
          'Network connectivity restored ($results) -> checking Meteor liveness',
        );
        _client.checkLiveness();
      }
    });
  }

  /// Disposes internal listeners if the service is ever torn down.
  @disposeMethod
  void dispose() {
    _connectivitySubscription?.cancel();
  }

  /// Underlying [MeteorClient] instance.
  MeteorClient get client => _client;

  /// Underlying [DdpClient] connection instance.
  DdpClient get connection => _client.connection;

  // ===========================================================================
  // 1. Initialization, Connection & App Lifecycle Management
  // ===========================================================================

  /// Establishes a new connection to the specified Meteor server [url].
  /// Closes any existing connection before reconnecting.
  MeteorClient connect({
    String url = AppConstants.meteorUrl,
    bool debug = kDebugMode,
    String userAgent = 'DartMeteor/4.1.0',
    Duration? pingInterval = AppConstants.meteorPingInterval,
    Duration? pongTimeout = AppConstants.meteorPongTimeout,
    Duration? maxRetryInterval = AppConstants.meteorMaxRetryInterval,
    Duration? stalenessThreshold = AppConstants.meteorStalenessThreshold,
  }) {
    try {
      _client.disconnect();
    } catch (_) {}

    _client = MeteorClient.connect(
      url: url,
      debug: debug,
      userAgent: userAgent,
      pingInterval: pingInterval,
      pongTimeout: pongTimeout,
      maxRetryInterval: maxRetryInterval,
      stalenessThreshold: stalenessThreshold,
    );

    return _client;
  }

  /// Reactive stream of the DDP connection status
  /// (`connected`, `connecting`, `failed`, `waiting`, `offline`).
  Stream<DdpConnectionStatus> status() => _client.status();

  /// Forces an immediate reconnection attempt if the client is not connected.
  void reconnect() => _client.reconnect();

  /// Disconnects the client from the Meteor server and stops auto-reconnecting
  /// until [reconnect] is called.
  void disconnect() => _client.disconnect();

  /// Registers a callback to be invoked as the first step of reconnecting.
  void onReconnect(
    FutureOr<void> Function(OnReconnectionCallback reconnection) callback,
  ) {
    _client.connection.onReconnect(callback);
  }

  /// Verifies the connection is still alive right now, reconnecting if stale.
  void checkLiveness() => _client.checkLiveness();

  /// Notifies the client that the host application went to the background.
  void notifyAppPaused() => _client.notifyAppPaused();

  /// Notifies the client that the host application returned to the foreground.
  void notifyAppResumed() => _client.notifyAppResumed();

  /// Convenience helper to forward Flutter [AppLifecycleState] changes from
  /// a [WidgetsBindingObserver].
  void handleAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      notifyAppResumed();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden) {
      notifyAppPaused();
    }
  }

  /// Registers a callback to run once the client successfully connects to the server.
  void startup(Function func) => _client.startup(func);

  /// Defers execution of [func] to the next event-loop tick.
  void defer(Function Function() func) => _client.defer(func);

  /// Environment checks provided by `MeteorClient`.
  bool isClient() => _client.isClient();
  bool isServer() => _client.isServer();
  bool isCordova() => _client.isCordova();
  bool isDevelopment() => _client.isDevelopment();
  bool isProduction() => _client.isProduction();

  // ===========================================================================
  // 2. Remote Procedure Calls (Meteor Methods)
  // ===========================================================================

  /// Invokes a Meteor server method by [name] with optional [args].
  ///
  /// Throws [MeteorError] if the server rejects the call, or
  /// [MeteorConnectionError] if the connection drops while in flight.
  Future<dynamic> call(
    String name, {
    List<dynamic> args = const [],
  }) async {
    try {
      _logger.d('Meteor call -> $name | args: $args');
      final result = await _client.call(name, args: args);
      _logger.d('Meteor call <- $name | result: $result');
      return result;
    } catch (error, stackTrace) {
      _logger.e(
        'Meteor call error [$name]: ${formatError(error)}',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Invokes a Meteor server method passing an array of [args].
  Future<dynamic> apply(
    String name,
    List<dynamic> args,
  ) async {
    try {
      _logger.d('Meteor apply -> $name | args: $args');
      final result = await _client.apply(name, args);
      _logger.d('Meteor apply <- $name | result: $result');
      return result;
    } catch (error, stackTrace) {
      _logger.e(
        'Meteor apply error [$name]: ${formatError(error)}',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Executes a Meteor method call and wraps the response in the app's
  /// [ApiResult] (`Success<T>` or `Error<T>`).
  Future<ApiResult<T>> safeCall<T>(
    String name, {
    List<dynamic> args = const [],
    T Function(dynamic rawData)? mapper,
  }) async {
    try {
      final rawResult = await call(name, args: args);
      final T mappedResult =
          mapper != null ? mapper(rawResult) : rawResult as T;
      return Success<T>(mappedResult);
    } catch (error) {
      return Error<T>(formatError(error));
    }
  }

  // ===========================================================================
  // 3. Subscriptions & Reactive Collections
  // ===========================================================================

  /// Subscribes to a publication [name] on the Meteor server.
  /// Returns a [SubscriptionHandler] with `ready()` stream and `stop()` method.
  SubscriptionHandler subscribe(
    String name, {
    List<dynamic> args = const [],
    Function Function(dynamic error)? onStop,
    Function? onReady,
  }) {
    _logger.d('Meteor subscribe -> $name | args: $args');
    return _client.subscribe(
      name,
      args: args,
      onStop: onStop,
      onReady: onReady,
    );
  }

  /// Subscribes to a publication [name] and awaits until its initial batch of
  /// documents is ready.
  Future<SubscriptionHandler> subscribeAndWaitReady(
    String name, {
    List<dynamic> args = const [],
    Function Function(dynamic error)? onStop,
    Function? onReady,
    Duration? timeout,
  }) async {
    final completer = Completer<SubscriptionHandler>();
    late final SubscriptionHandler handler;

    handler = subscribe(
      name,
      args: args,
      onReady: () {
        onReady?.call();
        if (!completer.isCompleted) {
          completer.complete(handler);
        }
      },
      onStop: (dynamic error) {
        final result = onStop?.call(error);
        if (!completer.isCompleted) {
          completer.completeError(
            error ?? MeteorError.parse({'reason': 'Subscription stopped'}),
          );
        }
        return result ?? () {};
      },
    );

    if (timeout != null) {
      return completer.future.timeout(
        timeout,
        onTimeout: () {
          handler.stop();
          throw TimeoutException(
            'Subscription "$name" timed out after ${timeout.inSeconds}s',
            timeout,
          );
        },
      );
    }

    return completer.future;
  }

  /// Safely stops an active [SubscriptionHandler].
  void unsubscribe(SubscriptionHandler? handler) {
    handler?.stop();
  }

  /// Returns a reactive [Stream] of documents for [collectionName],
  /// keyed by document `_id`.
  Stream<Map<String, dynamic>> collection(String collectionName) {
    return _client.collection(collectionName);
  }

  /// Returns a reactive [Stream] of documents for [collectionName] as a [List].
  Stream<List<Map<String, dynamic>>> collectionList(String collectionName) {
    return _client.collection(collectionName).map((collectionMap) {
      return collectionMap.values
          .whereType<Map>()
          .map((doc) => Map<String, dynamic>.from(doc))
          .toList();
    });
  }

  /// Returns the current synchronous snapshot of [collectionName] without
  /// listening to a stream.
  Map<String, dynamic>? collectionCurrentValue(String collectionName) {
    return _client.collectionCurrentValue(collectionName);
  }

  /// Looks up a single document by its [id] synchronously from [collectionName].
  Map<String, dynamic>? documentById(String collectionName, String id) {
    final rawDoc = _client.collectionCurrentValue(collectionName)?[id];
    if (rawDoc is Map) {
      return Map<String, dynamic>.from(rawDoc);
    }
    return null;
  }

  /// Returns a reactive [Stream] of a single document by its [id] from [collectionName].
  Stream<Map<String, dynamic>?> documentStreamById(
    String collectionName,
    String id,
  ) {
    return _client.collection(collectionName).map((collectionMap) {
      final rawDoc = collectionMap[id];
      if (rawDoc is Map) {
        return Map<String, dynamic>.from(rawDoc);
      }
      return null;
    });
  }

  // ===========================================================================
  // 4. Accounts & Authentication
  // ===========================================================================

  /// Reactive stream of the current logged-in user document, or `null` if logged out.
  Stream<Map<String, dynamic>?> user() => _client.user();

  /// Current synchronous value of the logged-in user document.
  Map<String, dynamic>? userCurrentValue() => _client.userCurrentValue();

  /// Reactive stream of the current logged-in user's ID, or `null` if logged out.
  Stream<String?> userId() => _client.userId();

  /// Current synchronous value of the logged-in user's ID.
  String? userIdCurrentValue() => _client.userIdCurrentValue();

  /// Returns `true` if a user is currently authenticated.
  bool get isLoggedIn => _client.userIdCurrentValue() != null;

  /// Reactive stream of the `users` collection.
  Stream<Map<String, dynamic>> get users => _client.users;

  /// Reactive stream of the current [UserLogInStatus]
  /// (`loggedOut`, `loggedIn`, `loggingIn`, `loggingOut`).
  Stream<UserLogInStatus> logInStatus() => _client.logInStatus();

  /// Reactive stream emitting `true` while a login operation is in progress.
  Stream<bool> loggingIn() => _client.loggingIn();

  /// Authenticates a user using [user] (username or email) and [password].
  /// The password is automatically hashed with SHA-256 by `dart_meteor`.
  Future<MeteorClientLoginResult> loginWithPassword(
    String user,
    String password, {
    int delayOnLoginErrorSecond = 0,
  }) async {
    try {
      return await _client.loginWithPassword(
        user,
        password,
        delayOnLoginErrorSecond: delayOnLoginErrorSecond,
      );
    } catch (error, stackTrace) {
      _logger.e(
        'Meteor loginWithPassword error: ${formatError(error)}',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Resumes a session using a stored login [token] and optional [tokenExpires].
  Future<MeteorClientLoginResult?> loginWithToken({
    required String token,
    DateTime? tokenExpires,
  }) async {
    try {
      return await _client.loginWithToken(
        token: token,
        tokenExpires: tokenExpires,
      );
    } catch (error, stackTrace) {
      _logger.e(
        'Meteor loginWithToken error: ${formatError(error)}',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Authenticates a user with custom [loginData] payload.
  Future<MeteorClientLoginResult> login(
    Map<String, dynamic> loginData, {
    int delayOnLoginErrorSecond = 0,
  }) async {
    try {
      return await _client.login(
        loginData,
        delayOnLoginErrorSecond: delayOnLoginErrorSecond,
      );
    } catch (error, stackTrace) {
      _logger.e(
        'Meteor login error: ${formatError(error)}',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Logs out the current user session from the Meteor server.
  Future<dynamic> logout() async {
    try {
      return await _client.logout();
    } catch (error, stackTrace) {
      _logger.e(
        'Meteor logout error: ${formatError(error)}',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Logs out other clients logged in as the current user without logging out
  /// this client instance.
  Future<MeteorClientLoginResult> logoutOtherClients() async {
    try {
      return await _client.logoutOtherClients();
    } catch (error, stackTrace) {
      _logger.e(
        'Meteor logoutOtherClients error: ${formatError(error)}',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Changes the current logged-in user's password.
  Future<dynamic> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      return await _client.changePassword(oldPassword, newPassword);
    } catch (error, stackTrace) {
      _logger.e(
        'Meteor changePassword error: ${formatError(error)}',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Requests a forgot-password email for the given [email] address.
  Future<dynamic> forgotPassword(String email) async {
    try {
      return await _client.forgotPassword(email);
    } catch (error, stackTrace) {
      _logger.e(
        'Meteor forgotPassword error: ${formatError(error)}',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Resets the user's password using a reset [token] received via email and
  /// logs the user in afterwards.
  Future<dynamic> resetPassword(
    String token,
    String newPassword,
  ) async {
    try {
      return await _client.resetPassword(token, newPassword);
    } catch (error, stackTrace) {
      _logger.e(
        'Meteor resetPassword error: ${formatError(error)}',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  // ===========================================================================
  // 5. Error Formatting Helpers
  // ===========================================================================

  /// Extracts a human-readable message from [MeteorError],
  /// [MeteorConnectionError], or generic exceptions.
  String formatError(Object error) {
    if (error is MeteorError) {
      if (error.reason != null && error.reason!.trim().isNotEmpty) {
        return error.reason!.trim();
      }
      if (error.message != null && error.message!.trim().isNotEmpty) {
        return error.message!.trim();
      }
      if (error.details != null && error.details!.trim().isNotEmpty) {
        return error.details!.trim();
      }
      if (error.error != null) {
        return error.error.toString();
      }
      return 'Meteor server error occurred';
    }
    if (error is MeteorConnectionError) {
      return error.reason.isNotEmpty
          ? error.reason
          : 'Connection lost before the server replied';
    }
    return error.toString();
  }
}

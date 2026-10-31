abstract final class AppConstants {
  static const String meteorUrl = 'http://local.moud.info:3000';
  static const Duration meteorPingInterval = Duration(seconds: 20);
  static const Duration meteorPongTimeout = Duration(seconds: 5);
  static const Duration meteorMaxRetryInterval = Duration(seconds: 30);
  static const Duration meteorStalenessThreshold = Duration(seconds: 25);
}

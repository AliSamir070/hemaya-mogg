import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/auth_entity.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  final String? id;
  final String? name;
  final String? fullName;
  final String? phone;
  final String? email;
  final String? token;
  final String? statusMsg;
  final String? message;

  const AuthResponse({
    this.id,
    this.name,
    this.fullName,
    this.phone,
    this.email,
    this.token,
    this.statusMsg,
    this.message,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);

  /// Parses the dynamic result returned by Meteor (`users.create`) along with
  /// the submitted request payload into an [AuthResponse].
  factory AuthResponse.fromMeteorResult(
    dynamic result, {
    Map<String, dynamic>? requestBody,
  }) {
    if (result is Map) {
      final map = Map<String, dynamic>.from(result);
      return AuthResponse(
        id: (map['id'] ?? map['_id'] ?? map['userId'])?.toString(),
        name: (map['name'] ?? requestBody?['name'])?.toString(),
        fullName: (map['fullName'] ?? requestBody?['fullName'])?.toString(),
        phone: (map['phone'] ?? requestBody?['phone'])?.toString(),
        email: (map['email'] ?? requestBody?['email'])?.toString(),
        token: map['token']?.toString(),
        statusMsg: map['statusMsg']?.toString(),
        message: map['message']?.toString(),
      );
    }

    return AuthResponse(
      id: result?.toString(),
      name: requestBody?['name']?.toString(),
      fullName: requestBody?['fullName']?.toString(),
      phone: requestBody?['phone']?.toString(),
      email: requestBody?['email']?.toString(),
    );
  }

  AuthEntity toEntity() {
    return AuthEntity(
      id: id,
      name: name,
      fullName: fullName,
      phone: phone,
      email: email,
      token: token,
      message: message,
    );
  }
}

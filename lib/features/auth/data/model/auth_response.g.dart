// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
  id: json['id'] as String?,
  name: json['name'] as String?,
  fullName: json['fullName'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  token: json['token'] as String?,
  statusMsg: json['statusMsg'] as String?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'fullName': instance.fullName,
      'phone': instance.phone,
      'email': instance.email,
      'token': instance.token,
      'statusMsg': instance.statusMsg,
      'message': instance.message,
    };

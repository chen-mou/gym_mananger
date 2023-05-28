// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User()
  ..id = json['id'] as num
  ..name = json['name'] as String
  ..password = json['password'] as String
  ..nickname = json['nickname'] as String
  ..role = json['role'] as String
  ..avatar = json['avatar'] as String;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'password': instance.password,
      'nickname': instance.nickname,
      'role': instance.role,
      'avatar': instance.avatar,
    };

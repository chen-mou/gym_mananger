// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Login _$LoginFromJson(Map<String, dynamic> json) => Login()
  ..code = json['code'] as num
  ..data = User.fromJson(json['data'] as Map<String, dynamic>);

Map<String, dynamic> _$LoginToJson(Login instance) => <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
    };

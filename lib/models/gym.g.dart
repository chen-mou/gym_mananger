// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gym.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Gym _$GymFromJson(Map<String, dynamic> json) => Gym()
  ..id = json['id'] as num
  ..name = json['name'] as String
  ..latitude = json['latitude'] as num
  ..longitude = json['longitude'] as num
  ..distance = json['distance'] as num
  ..open = json['open'] as String
  ..end = json['end'] as String
  ..avatar = json['avatar'] as String
  ..description = json['description'] as String
  ..tel = json['tel'] as String
  ..address = json['address'] as String;

Map<String, dynamic> _$GymToJson(Gym instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'distance': instance.distance,
      'open': instance.open,
      'end': instance.end,
      'avatar': instance.avatar,
      'description': instance.description,
      'tel': instance.tel,
      'address': instance.address,
    };

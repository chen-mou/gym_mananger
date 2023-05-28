// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Venue _$VenueFromJson(Map<String, dynamic> json) => Venue()
  ..id = json['id'] as num
  ..name = json['name'] as String
  ..gym_id = json['gym_id'] as num
  ..avatar = json['avatar'] as String
  ..type = json['type'] as String
  ..price = json['price'] as num
  ..unit = json['unit'] as String;

Map<String, dynamic> _$VenueToJson(Venue instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'gym_id': instance.gym_id,
      'avatar': instance.avatar,
      'type': instance.type,
      'price': instance.price,
      'unit': instance.unit,
    };

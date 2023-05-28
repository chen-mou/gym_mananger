// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Equipment _$EquipmentFromJson(Map<String, dynamic> json) => Equipment()
  ..id = json['id'] as num
  ..name = json['name'] as String
  ..avatar = json['avatar'] as String
  ..gym_id = json['gym_id'] as num
  ..number = json['number'] as num
  ..price = json['price'] as num
  ..unit = json['unit'] as String;

Map<String, dynamic> _$EquipmentToJson(Equipment instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar': instance.avatar,
      'gym_id': instance.gym_id,
      'number': instance.number,
      'price': instance.price,
      'unit': instance.unit,
    };

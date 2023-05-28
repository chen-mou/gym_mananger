// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goods.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Goods _$GoodsFromJson(Map<String, dynamic> json) => Goods()
  ..id = json['id'] as num
  ..name = json['name'] as String
  ..avatar = json['avatar'] as String
  ..gym_id = json['gym_id'] as num
  ..price = json['price'] as num
  ..unit = json['unit'] as String
  ..type = json['type'] as String
  ..number = json['number'] as num?;

Map<String, dynamic> _$GoodsToJson(Goods instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar': instance.avatar,
      'gym_id': instance.gym_id,
      'price': instance.price,
      'unit': instance.unit,
      'type': instance.type,
      'number': instance.number,
    };

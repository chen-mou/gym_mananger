// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reserve.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reserve _$ReserveFromJson(Map<String, dynamic> json) => Reserve()
  ..id = json['id'] as num
  ..start = json['start'] as num
  ..end = json['end'] as num
  ..date = json['date'] as String
  ..gym_id = json['gym_id'] as num
  ..number = json['number'] as num
  ..goods = Goods.fromJson(json['goods'] as Map<String, dynamic>);

Map<String, dynamic> _$ReserveToJson(Reserve instance) => <String, dynamic>{
      'id': instance.id,
      'start': instance.start,
      'end': instance.end,
      'date': instance.date,
      'gym_id': instance.gym_id,
      'number': instance.number,
      'goods': instance.goods,
    };

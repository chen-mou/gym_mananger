// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allReserve.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllReserve _$AllReserveFromJson(Map<String, dynamic> json) => AllReserve()
  ..name = json['name'] as String
  ..reserve = (json['reserve'] as List<dynamic>)
      .map((e) => Reserve.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$AllReserveToJson(AllReserve instance) =>
    <String, dynamic>{
      'name': instance.name,
      'reserve': instance.reserve,
    };

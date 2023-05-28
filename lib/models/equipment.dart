import 'package:json_annotation/json_annotation.dart';

part 'equipment.g.dart';

@JsonSerializable()
class Equipment {
  Equipment();

  late num id;
  late String name;
  late String avatar;
  late num gym_id;
  late num number;
  late num price;
  late String unit;
  
  factory Equipment.fromJson(Map<String,dynamic> json) => _$EquipmentFromJson(json);
  Map<String, dynamic> toJson() => _$EquipmentToJson(this);
}

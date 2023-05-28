import 'package:json_annotation/json_annotation.dart';

part 'gym.g.dart';

@JsonSerializable()
class Gym {
  Gym();

  late num id;
  late String name;
  late num latitude;
  late num longitude;
  late num distance;
  late String open;
  late String end;
  late String avatar;
  late String description;
  late String tel;
  late String address;
  
  factory Gym.fromJson(Map<String,dynamic> json) => _$GymFromJson(json);
  Map<String, dynamic> toJson() => _$GymToJson(this);
}

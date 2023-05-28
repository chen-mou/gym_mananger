import 'package:json_annotation/json_annotation.dart';
import "reserve.dart";
part 'allReserve.g.dart';

@JsonSerializable()
class AllReserve {
  AllReserve();

  late String name;
  late List<Reserve> reserve;
  
  factory AllReserve.fromJson(Map<String,dynamic> json) => _$AllReserveFromJson(json);
  Map<String, dynamic> toJson() => _$AllReserveToJson(this);
}

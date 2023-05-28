import 'package:json_annotation/json_annotation.dart';
import "goods.dart";
part 'reserve.g.dart';

@JsonSerializable()
class Reserve {
  Reserve();

  late num id;
  late num start;
  late num end;
  late String date;
  late num gym_id;
  late num number;
  late Goods goods;
  
  factory Reserve.fromJson(Map<String,dynamic> json) => _$ReserveFromJson(json);
  Map<String, dynamic> toJson() => _$ReserveToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'goods.g.dart';

@JsonSerializable()
class Goods {
  Goods();

  late num id;
  late String name;
  late String avatar;
  late num gym_id;
  late num price;
  late String unit;
  late String type;
  num? number;
  
  factory Goods.fromJson(Map<String,dynamic> json) => _$GoodsFromJson(json);
  Map<String, dynamic> toJson() => _$GoodsToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'venue.g.dart';

@JsonSerializable()
class Venue {
  Venue();

  late num id;
  late String name;
  late num gym_id;
  late String avatar;
  late String type;
  late num price;
  late String unit;
  
  factory Venue.fromJson(Map<String,dynamic> json) => _$VenueFromJson(json);
  Map<String, dynamic> toJson() => _$VenueToJson(this);
}

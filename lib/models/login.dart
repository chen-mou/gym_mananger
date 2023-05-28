import 'package:json_annotation/json_annotation.dart';
import "user.dart";
part 'login.g.dart';

@JsonSerializable()
class Login {
  Login();

  late num code;
  late User data;
  
  factory Login.fromJson(Map<String,dynamic> json) => _$LoginFromJson(json);
  Map<String, dynamic> toJson() => _$LoginToJson(this);
}

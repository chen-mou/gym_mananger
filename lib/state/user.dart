import 'package:flutter/cupertino.dart';
import 'package:gym_mananger/models/user.dart';

class UserState extends ChangeNotifier {
  bool isLogin = false;

  String token = "";

  late User user;

  void login(User user) {
    isLogin = true;
    this.user = user;
    notifyListeners();
  }
}

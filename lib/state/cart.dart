import 'package:flutter/cupertino.dart';
import 'package:gym_mananger/models/index.dart';

class CartState extends ChangeNotifier {
  final Map<num, Reserve> _reserve = {};

  void save(Reserve val) {
    _reserve[val.id] = val;
    notifyListeners();
  }

  void del(Reserve val) {
    _reserve.remove(val.id);
    notifyListeners();
  }

  String getPrice(num gymId) {
    num price = 0;
    _reserve.values
        .where((element) => element.gym_id == gymId)
        .forEach((element) {
      price +=
          element.goods.price * (element.end - element.start) * element.number;
    });
    return price.toStringAsFixed(2);
  }

  List<Reserve> getAll(num gymId) {
    return _reserve.values.where((element) => element.gym_id == gymId).toList();
  }
}

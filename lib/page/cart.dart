import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/allReserve.dart';

class CartPage extends StatelessWidget {
  final Future<List<AllReserve>> Function() getData;
  final String title;
  const CartPage({super.key, required this.getData, required this.title});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: const Color(0xffeaebf1),
        width: size.width,
        height: size.height,
        child: FutureBuilder(
          future: getData(),
          builder: (ctx, AsyncSnapshot<List<AllReserve>> snap) {
            if (snap.connectionState != ConnectionState.done) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        boxShadow: [
                          BoxShadow(color: CupertinoColors.systemGrey5)
                        ]),
                    child: const CircularProgressIndicator(),
                  )
                ],
              );
            }
            return ListView(
              children: [
                Container(
                  width: size.width,
                  height: 50,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    title,
                    style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 30,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                for (AllReserve reserve in snap.data ?? [])
                  Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Column(
                      children: [
                        Container(
                          width: size.width,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1,
                                      color: CupertinoColors.systemGrey4))),
                          child: Text(reserve.name),
                        ),
                        for (var r in reserve.reserve)
                          GoodsColumn(
                            avatar: r.goods.avatar,
                            name: r.goods.name,
                            price: r.goods.price,
                            unit: r.goods.unit,
                            number: r.goods.type == "Equipment" ? r.number : -1,
                          )
                      ],
                    ),
                  )
              ],
            );
          },
        ),
      ),
    );
  }
}

class GoodsColumn extends StatelessWidget {
  const GoodsColumn(
      {super.key,
      required this.avatar,
      required this.name,
      required this.price,
      required this.unit,
      required this.number});

  final String avatar;
  final String name;
  final num price;
  final String unit;
  final num number;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Image.network(avatar),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    Text(
                      "$price $unit",
                      style: const TextStyle(color: Colors.deepOrange),
                    ),
                  ],
                ),
              ],
            ),
            // SizedBox(width: double.infinity,),
            Column(children: [
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.redAccent),
                    shape: MaterialStateProperty.all(const CircleBorder())),
                child: const Icon(Icons.remove),
              ),
              if (number != -1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [Text("个数:$number")],
                )
            ])
          ],
        ));
  }
}

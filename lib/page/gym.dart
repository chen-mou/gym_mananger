import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym_mananger/component/tarbar.dart' as tarbar;
import 'package:gym_mananger/models/equipment.dart';
import 'package:gym_mananger/models/gym.dart';
import 'package:gym_mananger/state/cart.dart';
import 'package:gym_mananger/util/http.dart';
import 'package:provider/provider.dart';

import '../models/reserve.dart' as reserve;
import '../models/venue.dart';

class GymPage extends StatefulWidget {
  final Gym gym;

  const GymPage({super.key, required this.gym});

  @override
  State<GymPage> createState() => _GymPageState();
}

class _GymPageState extends State<GymPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Header(gym: widget.gym),
          tarbar.CardTarBar(children: [
            tarbar.CardElement(
                title: "简介",
                child: Description(
                  description: widget.gym.description,
                  tel: widget.gym.tel,
                  address: widget.gym.address,
                )),
            tarbar.CardElement(
                title: "预约",
                child: Reserve(
                  gymId: widget.gym.id,
                ))
          ]),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  final Gym gym;

  const Header({super.key, required this.gym});

  @override
  Widget build(BuildContext context) {
    MediaQueryData data = MediaQuery.of(context);
    Size size = data.size;
    return Container(
      width: size.width,
      height: size.height * 0.3,
      color: const Color.fromRGBO(57, 47, 89, 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.circular(10)),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  gym.avatar,
                  width: size.width * 0.3,
                  height: size.height * 0.25,
                )),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                gym.name,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox.fromSize(size: const Size(0, 10)),
              Text(
                "开放时间:${gym.open.substring(0, 5)} ~ ${gym.end.substring(0, 5)}",
                style: const TextStyle(fontSize: 20, color: Colors.white),
              )
            ],
          )
        ],
      ),
    );
  }
}

class Description extends StatelessWidget {
  final String description;
  final String address;
  final String tel;

  const Description(
      {super.key,
      required this.description,
      required this.tel,
      required this.address});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
      children: [
        Main(
          title: "地址",
          main: address,
        ),
        Main(title: "联系电话", main: tel),
        Main(
          title: "简介",
          main: description,
        )
      ],
    ));
  }
}

class Main extends StatelessWidget {
  final String title;
  final String main;

  const Main({super.key, required this.title, required this.main});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      margin: const EdgeInsets.all(5),
      width: size.width,
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [Text(main)],
          )
        ],
      ),
    );
  }
}

class Reserve extends StatefulWidget {
  final num gymId;

  const Reserve({super.key, required this.gymId});

  @override
  State<Reserve> createState() => _ReserveState();
}

class _ReserveState extends State<Reserve> {
  late Future<List<reserve.Reserve>> data;

  @override
  void initState() {
    super.initState();
    data = myReserve();
  }

  Future<List<reserve.Reserve>> myReserve() async {
    var resp = await HttpUtil.get("/reserve/myReserve",
        params: {"gym_id": widget.gymId});
    if (resp.data["code"] != 0) {
      return [];
    }
    var data = resp.data["data"];
    var res = <reserve.Reserve>[];
    for (var item in data) {
      res.add(reserve.Reserve.fromJson(item));
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height * 0.7 - 100,
      child: Column(
        children: [
          tarbar.VerticalTarbar(children: [
            tarbar.CardElement(
                title: "器材",
                child: GoodsPage(
                  getData: (num id) async {
                    var res = <Equipment>[];
                    var resp = await HttpUtil.get("/goods/getByGymAndType",
                        params: {"gym_id": widget.gymId, "type": "Equipment"});
                    // print(resp.data.data);
                    for (var eq in resp.data["data"]) {
                      res.add(Equipment.fromJson(eq));
                    }
                    return res;
                  },
                  type: 'Equipment',
                )),
            tarbar.CardElement(
                title: "场馆",
                child: GoodsPage(
                  getData: (num id) async {
                    var res = <Venue>[];
                    var resp = await HttpUtil.get("/goods/getByGymAndType",
                        params: {"gym_id": widget.gymId, "type": "Venue"});
                    for (var eq in resp.data["data"]) {
                      res.add(Venue.fromJson(eq));
                    }
                    return res;
                  },
                  type: 'Venue',
                ))
          ]),
          Builder(builder: (context) {
            CartState cart = context.watch<CartState>();
            data.then((value) {
              for (var element in value) {
                cart.save(element);
              }
            });
            return Container(
              height: 80,
              padding: const EdgeInsets.all(10),
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(1, 1, 2, 1),
                    borderRadius: BorderRadius.all(Radius.circular(40))),
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${cart.getPrice(widget.gymId)}元",
                      style: const TextStyle(color: Colors.white),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: const Text("确认订单"),
                                  content: AffirmOrder(
                                    reserves: cart.getAll(widget.gymId),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          List<num> reserveId = [];
                                          cart
                                              .getAll(widget.gymId)
                                              .forEach((element) {
                                            reserveId.add(element.id);
                                          });
                                          HttpUtil.post("/order/create",
                                              params: {
                                                "reserve_ids": reserveId
                                              }).then((value) {
                                            if (value.data["code"] == 0) {
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) {
                                                    return ElevatedButton(
                                                        onPressed: () {
                                                          HttpUtil.post(
                                                              "/order/pay",
                                                              params: {
                                                                "id": value.data[
                                                                        "data"]
                                                                    ["id"]
                                                              }).then((value) =>
                                                              {
                                                                Navigator.pop(
                                                                    context)
                                                              });
                                                        },
                                                        child:
                                                            const Text("支付"));
                                                  }).then((value) {
                                                Navigator.pop(context);
                                              });
                                            }
                                          });
                                        },
                                        child: const Text("确 定")),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("取 消"))
                                  ],
                                );
                              });
                        },
                        style: ButtonStyle(
                            minimumSize:
                                MaterialStateProperty.all(const Size(40, 80)),
                            shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(40),
                                        bottomRight: Radius.circular(40))))),
                        child: const Text("下订单"))
                  ],
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}

class EquipmentGoods extends StatelessWidget {
  const EquipmentGoods({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 50,
          child: NumField(onChange: (value) {}, label: "时长"),
        ),
        SizedBox(
          width: 50,
          child: NumField(
            onChange: (value) {},
            label: "个数",
          ),
        ),
        SizedBox(
          height: 50,
          width: 200,
          child: Row(
            children: [
              Text("起止时间"),
              TimeSelect(onchange: (int start, int end) {})
            ],
          ),
        )
      ],
    );
  }
}

class VenueGoods extends StatelessWidget {
  const VenueGoods({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 50,
          child: NumField(onChange: (value) {}, label: "时长"),
        )
      ],
    );
  }
}

class GoodsPage<T> extends StatefulWidget {
  final Future<List<T>> Function(num) getData;
  final String type;

  const GoodsPage({super.key, required this.getData, required this.type});

  @override
  State<GoodsPage> createState() => _GoodsPageState();
}

class _GoodsPageState extends State<GoodsPage> {
  late Future<List<dynamic>> data;

  @override
  void initState() {
    super.initState();
    data = widget.getData(1);
  }

  // Future<List<T>> getData(num id){
  //   return Future(() => [
  //     Venue.fromJson({
  //       "id": 1,
  //       "name": "501",
  //       "gym_id": 1234,
  //       "avatar": "https://www.bing.com/images/search?view=detailV2&ccid=AMXdutT4&id=3801FD5A9AAD28825828D7FF36F92DB74ED4912D&thid=OIP.AMXdutT4rOZde1jeaLqRigHaFB&mediaurl=https%3a%2f%2fth.bing.com%2fth%2fid%2fR.00c5ddbad4f8ace65d7b58de68ba918a%3frik%3dLZHUTrct%252bTb%252f1w%26riu%3dhttp%253a%252f%252fnews.gznu.edu.cn%252fimages%252f11%252f10%252f04%252f76cykpqku1%252fligongtiyu.jpg%26ehk%3d2dsk2hLYSyP0W%252bIV%252fSGnKhPWVdn3XRFikPvBynRANUs%253d%26risl%3d%26pid%3dImgRaw%26r%3d0&exph=869&expw=1280&q=%e4%bd%93%e8%82%b2%e9%a6%86&simid=608041071782156387&FORM=IRPRST&ck=21229FE8B6E7F1AC1F62A2F0B2FDDFCA&selectedIndex=8",
  //       "type": "羽毛球场",
  //       "price": 123,
  //       "unit": "小时"
  //     })
  //   ]);
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return FutureBuilder<List<dynamic>>(
        future: data,
        builder: (ctx, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const CircularProgressIndicator();
          }
          var res = snapshot.data ?? [];
          return ListView.builder(
            padding: const EdgeInsets.only(top: 0),
            itemBuilder: (ctx, index) {
              return ReserveData(
                type: widget.type,
                data: res[index],
              );
            },
            itemCount: res.length,
          );
        });
  }
}

class ReserveData extends StatefulWidget {
  final String type;
  final dynamic data;

  const ReserveData({super.key, required this.type, required this.data});

  @override
  State<ReserveData> createState() => _ReserveDataState();
}

class _ReserveDataState extends State<ReserveData> {
  late int num = 1;
  late String date;
  late int start;
  late int end;

  late int number = widget.type == "Equipment" ? widget.data.number : 0;

  @override
  void initState() {
    super.initState();
    date = formatDate(DateTime.now(), ['yyyy', '-', 'mm', '-', 'dd']);
    start = DateTime.now().hour;
    end = 23;
  }

  Future<Response> addReserve() {
    return HttpUtil.post("/reserve/save", params: {
      "type": widget.type,
      "number": num,
      "today": date,
      "start": start,
      "end": end,
      "goods_id": widget.data.id,
      "gym_id": widget.data.gym_id,
    });
  }

  Future<Response> getNowRemainder() {
    return HttpUtil.get("/goods/nowRemainder",
        params: {"goods_id": widget.data.id, "date": date});
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData data = MediaQuery.of(context);
    var cart = context.watch<CartState>();
    return ReserveSelector(
      name: widget.data.name,
      avatar: widget.data.avatar,
      unit: widget.data.unit,
      price: widget.data.price,
      number: number,
      show: AlertDialog(
        title: Text(widget.data.name),
        content: StatefulBuilder(builder: (context, builder) {
          return SizedBox(
            width: data.size.width * 0.7,
            height: data.size.height * 0.7,
            child: Column(
              children: [
                SizedBox(
                  width: data.size.width * 0.7,
                  height: data.size.height * 0.35,
                  child: Image.network(widget.data.avatar),
                ),
                Expanded(
                    child: Column(
                  children: [
                    if (widget.type == "Equipment")
                      NumField(
                          onChange: (index) {
                            num = index;
                          },
                          initValue: num,
                          label: "个数"),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text("日期: "),
                          DateSelector(
                              onChange: (String value) {
                                var now = DateTime.now();
                                date = value;
                                if (date ==
                                    formatDate(
                                        now, ['yyyy', '-', 'mm', '-', 'dd'])) {
                                  start = now.hour;
                                } else {
                                  start = 0;
                                }
                                getNowRemainder().then((resp) {
                                  number = resp.data["data"];
                                  builder(() {});
                                  return resp;
                                });
                                setState(() {});
                              },
                              time: date)
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text("起止时间: "),
                          TimeSelect(
                            onchange: (int start, int end) {
                              this.start = start;
                              this.end = end;
                            },
                            min: start,
                          )
                        ],
                      ),
                    ),
                    if (widget.type == "Equipment")
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [Text("剩余个数:$number")],
                      )
                  ],
                ))
              ],
            ),
          );
        }),
        actions: [
          TextButton(
            onPressed: () {
              addReserve().then((value) {
                print(value);
                if (value.data["code"] == 0) {
                  cart.save(reserve.Reserve.fromJson(value.data["data"]));
                }
                Navigator.of(context).pop(widget.data);
                return value;
              });
            },
            child: const Text("确 定"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("取 消"))
        ],
      ),
    );
  }
}

class DateSelector extends StatefulWidget {
  const DateSelector({super.key, required this.onChange, required this.time});

  final void Function(String) onChange;
  final String time;

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  late DateTime _nowTime;
  late String _now;

  @override
  void initState() {
    super.initState();
    _now = widget.time;
    _nowTime = DateTime.tryParse(_now) ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () async {
          var res = await showDatePicker(
              context: context,
              initialDate: DateTime.tryParse(_now) ?? _nowTime,
              firstDate: DateTime.now(),
              lastDate: _nowTime.add(const Duration(days: 15)));
          if (res != null) {
            _now = formatDate(res, ['yyyy', '-', 'mm', '-', 'dd']);
            widget.onChange(_now);
            setState(() {});
          }
        },
        child: Text(_now));
  }
}

class ReserveSelector extends StatelessWidget {
  final String name;
  final String avatar;
  final num price;
  final String unit;
  final Widget show;
  final int number;

  const ReserveSelector(
      {super.key,
      required this.name,
      required this.avatar,
      required this.show,
      required this.price,
      required this.unit,
      this.number = 0});

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) async {
        // print("did");
        await showDialog(
            context: context,
            builder: (ctx) {
              return show;
            });
      },
      child: Container(
          height: 80,
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
              if (number != 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [Text("剩余$number个")],
                )
            ],
          )),
    );
  }
}

class NumField extends StatefulWidget {
  final int initValue;

  final int min;

  final int? max;

  const NumField(
      {super.key,
      required this.onChange,
      required this.label,
      this.initValue = 1,
      this.min = 0,
      this.max});

  final Function(int) onChange;
  final String label;

  @override
  State<NumField> createState() => _NumFieldState();
}

class _NumFieldState extends State<NumField> {
  var num = 0;

  @override
  void initState() {
    super.initState();
    num = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("${widget.label}: "),
        TextButton(
            onPressed: () {
              if (widget.max != null && num == widget.max) {
                return;
              }
              num += 1;
              setState(() {});
              widget.onChange(num);
            },
            child: const Icon(Icons.add)),
        Container(
            margin: const EdgeInsets.all(10), child: Text(num.toString())),
        TextButton(
            onPressed: () {
              if (num == widget.min) {
                return;
              }
              num -= 1;
              setState(() {});
              widget.onChange(num);
            },
            child: const Icon(Icons.remove))
      ],
    );
  }
}

class TimeSelect extends StatefulWidget {
  final int min;

  final int max;

  final void Function(int, int) onchange;

  const TimeSelect(
      {super.key, required this.onchange, this.min = 0, this.max = 23});

  @override
  State<TimeSelect> createState() => _TimeSelectState();
}

class _TimeSelectState extends State<TimeSelect> {
  late int start = widget.min;

  late int end = widget.max;

  @override
  Widget build(BuildContext context) {
    MediaQueryData data = MediaQuery.of(context);
    return Expanded(
        child: Listener(
      onPointerDown: (e) {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text("选择预约起止时间"),
                content: SizedBox(
                  width: data.size.width * 0.6,
                  height: data.size.height * 0.6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TimeSelector(
                        data: data,
                        onChange: (int value) {
                          start = value;
                        },
                        min: widget.min,
                        max: widget.max,
                      ),
                      const Text("到"),
                      TimeSelector(
                        data: data,
                        onChange: (int value) {
                          end = value;
                        },
                        min: start,
                        max: widget.max,
                      )
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        widget.onchange(start, end);
                        Navigator.of(context).pop();
                        setState(() {});
                      },
                      child: const Text("确 定")),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("取消"))
                ],
              );
            });
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            "$start到$end",
            style: const TextStyle(color: Colors.blueAccent, inherit: true),
          )
        ],
      ),
    ));
  }
}

class TimeSelector extends StatelessWidget {
  const TimeSelector(
      {Key? key,
      required this.data,
      required this.onChange,
      this.min = 0,
      this.max = 23})
      : super(key: key);

  final MediaQueryData data;
  final void Function(int) onChange;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      width: data.size.width * 0.2,
      height: data.size.height * 0.4,
      child: CupertinoPicker(
        looping: true,
        itemExtent: 30,
        onSelectedItemChanged: (int value) {
          onChange(min + value);
        },
        children: [
          for (int start = min; start <= max; start++)
            Text("${start < 10 ? "0" : ""}$start")
        ],
      ),
    );
  }
}

class AffirmOrder extends StatelessWidget {
  final List<reserve.Reserve> reserves;

  const AffirmOrder({super.key, required this.reserves});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.6,
      height: size.height * 0.6,
      child: ListView(
        children: [
          for (var reserve in reserves)
            Container(
              height: 60,
              width: size.width * 0.6,
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Image.network(reserve.goods.avatar),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [Text(reserve.goods.name)],
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}

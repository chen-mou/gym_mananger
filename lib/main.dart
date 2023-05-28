import 'package:flutter/material.dart';
import 'package:gym_mananger/page/cart.dart';
import 'package:gym_mananger/page/map.dart';
import 'package:gym_mananger/page/user.dart';
import 'package:gym_mananger/state/cart.dart';
import 'package:gym_mananger/state/user.dart';
import 'package:gym_mananger/util/http.dart';
import 'package:provider/provider.dart';

import 'models/allReserve.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => UserState(),
          ),
          ChangeNotifierProvider(create: (ctx) => MapState()),
          ChangeNotifierProvider(create: (ctx) => CartState())
        ],
        child: MaterialApp(
          routes: {
            "/map": (ctx) => const MapPage(),
            "/login": (ctx) => const LoginPage(),
          },
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const Home(),
        ));
  }
}

class Home extends StatelessWidget {
  Future<List<AllReserve>> getReserve() async {
    var resp = await HttpUtil.get("/reserve/myAllReserve");
    var res = <AllReserve>[];
    for (var v in resp.data["data"]) {
      res.add(AllReserve.fromJson(v));
    }
    return res;
  }

  Future<List<AllReserve>> getOrderData() async {
    var resp = await HttpUtil.get("/order/myPayOrder");
    var res = <AllReserve>[];
    for (var v in resp.data["data"]) {
      res.add(AllReserve.fromJson(v));
    }
    return res;
  }

  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData data = MediaQuery.of(context);
    var user = context.watch<UserState>();
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 60,
            width: data.size.width,
            color: Colors.blue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Listener(
                  onPointerDown: (e) {
                    if (!user.isLogin || !HttpUtil.checkLogin()) {
                      Navigator.of(context).pushNamed("/login");
                    }
                  },
                  child: !user.isLogin || !HttpUtil.checkLogin()
                      ? UserAvatar(user: user)
                      : PopupMenuButton(
                          itemBuilder: (BuildContext context) {
                            return const [
                              PopupMenuItem(
                                value: "reserve",
                                child: Text("我的预约"),
                              ),
                              PopupMenuItem(
                                value: "cart",
                                child: Text("购物车"),
                              )
                            ];
                          },
                          onSelected: (String value) {
                            switch (value) {
                              case "reserve":
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => CartPage(
                                          getData: getOrderData,
                                          title: "我的预约",
                                        ),
                                    settings:
                                        const RouteSettings(name: "/cart")));
                                break;
                              case "cart":
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => CartPage(
                                          getData: getReserve,
                                          title: "购物车",
                                        ),
                                    settings:
                                        const RouteSettings(name: "/cart")));
                            }
                          },
                          child: UserAvatar(user: user),
                        ),
                )
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(builder: (context, con) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: con.maxWidth * 0.5,
                      height: con.maxWidth * 0.5,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Image(
                        image: const AssetImage("img/home.jpg"),
                        width: con.maxWidth * 0.5,
                        height: con.maxWidth * 0.5,
                      ),
                    ),
                    SizedBox(
                        height: con.maxHeight * 0.1,
                        width: con.maxWidth * 0.5,
                        child: ElevatedButton(
                            onPressed: () {
                              if (user.isLogin && HttpUtil.checkLogin()) {
                                Navigator.pushNamed(context, "/map");
                              } else {
                                Navigator.of(context).pushNamed("/login");
                              }
                            },
                            child: const Text("立即预约")))
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserState user;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: ClipOval(
        child: SizedBox(
          // margin: const EdgeInsets.only(left: 10),
          height: 50,
          width: 50,
          child: !user.isLogin
              ? Image.network("http://8.130.122.134/img/default.jpg")
              : Image.network(user.user.avatar),
        ),
      ),
    );
  }
}

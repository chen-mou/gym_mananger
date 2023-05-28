import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gym_mananger/page/gym.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../config/config.dart';
import '../models/gym.dart';
import '../util/http.dart';

class MapState extends ChangeNotifier {
  List<Marker> markers = [];
  var _hmap = <String, Marker>{};
  double latitude = 0;
  double longitude = 0;

  void addMarker(Marker marker) {
    markers.add(marker);
    notifyListeners();
  }

  void addMarkers(List<Marker> marker) {
    markers = [];
    for (var element in marker) {
      _hmap[element.id] = element;
    }
    markers.addAll(_hmap.values);
    notifyListeners();
  }

  void setPoint(double latitude, double longitude) {
    this.longitude = longitude;
    this.latitude = latitude;
    notifyListeners();
  }
}

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: const [Map(), Selector()],
      ),
    );
  }
}

class Selector extends StatefulWidget {
  const Selector({super.key});

  @override
  State<Selector> createState() => _SelectorState();
}

class _SelectorState extends State<Selector>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double _lastY = double.infinity;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _animation = Tween(begin: 0.8, end: 0.2).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  Future<List<Gym>> getData(double la, double long) async {
    var resp = await HttpUtil.get("/gym/near", params: {
      "latitude": la,
      "longitude": long,
      "page": 1,
    });
    var res = <Gym>[];
    for (var value in resp.data["data"]) {
      res.add(Gym.fromJson(value));
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    var state = context.watch<MapState>();

    return LayoutBuilder(builder: (ctx, con) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: con.maxWidth,
            height: con.maxHeight * _animation.value,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                color: Colors.white),
            child: FutureBuilder<List<Gym>>(
                future: getData(state.latitude, state.longitude),
                builder: (ctx, AsyncSnapshot<List<Gym>> snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const CircularProgressIndicator();
                  }
                  var data = snapshot.data ?? [];
                  var markers = <Marker>[];
                  for (var element in data) {
                    markers.add(Marker(
                      position: LatLng(element.latitude.toDouble(),
                          element.longitude.toDouble()),
                      //使用默认hue的方式设置Marker的图标
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueOrange),
                    ));
                  }
                  return Column(
                    children: [
                      GestureDetector(
                        onVerticalDragStart: (e) {
                          if (e.globalPosition.dy < _lastY) {
                            state.addMarkers(markers);
                            _controller.forward();
                          } else {
                            _controller.reverse();
                          }
                          _lastY = e.globalPosition.dy;
                          // state.addMarkers(markers);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              color: Colors.black12,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          width: con.maxWidth * 0.8,
                          height: 10,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: ListView.builder(
                          itemBuilder: (ctx, i) {
                            return SizedBox(
                              height: 70,
                              width: double.infinity,
                              child: GymCard(gym: data[i]),
                            );
                          },
                          itemCount: data.length,
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ],
      );
    });
  }
}

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  AMapController? mapController;

  /// 定位插件
  AMapFlutterLocation? location;

  /// 权限状态
  PermissionStatus? permissionStatus;

  /// 相机位置
  CameraPosition? currentLocation;

  /// 地图类型
  late MapType _mapType;

  /// 周边数据
  List poisData = [];

  var markerLatitude;
  var markerLongitude;

  double? meLatitude;
  double? meLongitude;

  @override
  void initState() {
    super.initState();
    _mapType = MapType.normal;

    /// 设置Android和iOS的apikey，
    AMapFlutterLocation.setApiKey(ConstConfig.androidKey, ConstConfig.iosKey);

    /// 设置是否已经取得用户同意，如果未取得用户同意，高德定位SDK将不会工作,这里传true
    AMapFlutterLocation.updatePrivacyAgree(true);

    /// 设置是否已经包含高德隐私政策并弹窗展示显示用户查看，如果未包含或者没有弹窗展示，高德定位SDK将不会工作,这里传true
    AMapFlutterLocation.updatePrivacyShow(true, true);
    requestPermission();
  }

  Future<void> requestPermission() async {
    final status = await Permission.location.request();
    permissionStatus = status;
    switch (status) {
      case PermissionStatus.denied:
        print("拒绝");
        break;
      case PermissionStatus.granted:
        requestLocation();
        break;
      case PermissionStatus.limited:
        print("限制");
        break;
      default:
        print("其他状态");
        requestLocation();
        break;
    }
  }

  /// 请求位置
  void requestLocation() {
    location = AMapFlutterLocation()
      ..setLocationOption(AMapLocationOption())
      ..onLocationChanged().listen((event) {
        // print(event);
        double? latitude = double.tryParse(event['latitude'].toString());
        double? longitude = double.tryParse(event['longitude'].toString());
        markerLatitude = latitude.toString();
        markerLongitude = longitude.toString();
        if (latitude != null &&
            longitude != null &&
            latitude != meLatitude &&
            longitude != meLongitude) {
          setState(() {
            currentLocation = CameraPosition(
              target: LatLng(latitude, longitude),
              zoom: 15,
            );
            meLatitude = latitude;
            meLongitude = longitude;
          });
        }
      })
      ..startLocation();
  }

  //需要先设置一个空的map赋值给AMapWidget的markers，否则后续无法添加marker
  final _markers = <String, Marker>{};
  //添加一个marker
  void _addMarker(LatLng markPostion) async {
    _removeAll();
    final Marker marker = Marker(
      position: markPostion,
      //使用默认hue的方式设置Marker的图标
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );
    //调用setState触发AMapWidget的更新，从而完成marker的添加
    setState(() {
      //将新的marker添加到map里
      _markers[marker.id] = marker;
    });
    _changeCameraPosition(markPostion);
  }

  /// 清除marker
  void _removeAll() {
    if (_markers.isNotEmpty) {
      setState(() {
        _markers.clear();
      });
    }
  }

  /// 改变中心点
  void _changeCameraPosition(LatLng markPostion, {double zoom = 13}) {
    mapController?.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            //中心点
            target: markPostion,
            //缩放级别
            zoom: zoom,
            //俯仰角0°~45°（垂直与地图时为0）
            tilt: 30,
            //偏航角 0~360° (正北方为0)
            bearing: 0),
      ),
      animated: true,
    );
  }

  @override
  void dispose() {
    location?.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentLocation == null) {
      return const SizedBox();
    }
    var state = context.watch<MapState>();
    return SizedBox.expand(
      child: AMapWidget(
        // 隐私政策包含高德 必须填写
        privacyStatement: ConstConfig.amapPrivacyStatement,
        apiKey: ConstConfig.amapApiKeys,
        // 初始化地图中心店
        initialCameraPosition: currentLocation!,
        // //定位小蓝点
        myLocationStyleOptions: MyLocationStyleOptions(
          true,
        ),
        // // 普通地图normal,卫星地图satellite,夜间视图night,导航视图 navi,公交视图bus,
        mapType: _mapType,
        // // 缩放级别范围
        minMaxZoomPreference: const MinMaxZoomPreference(3, 20),
        zoomGesturesEnabled: true,
        // onPoiTouched: _onMapPoiTouched,
        markers: Set<Marker>.of(state.markers),
        // 地图创建成功时返回AMapController
        onMapCreated: (AMapController controller) {
          mapController = controller;
          state.setPoint(currentLocation?.target.latitude ?? 0,
              currentLocation?.target.longitude ?? 0);
          // setState(() {});
        },
      ),
    );
  }

  /// 获取周边数据
  Future<void> _getPoisData() async {
    var response = await Dio().get(
        'https://restapi.amap.com/v3/place/around?key=${ConstConfig.webKey}&location=$markerLatitude,$markerLongitude&keywords=&types=&radius=1000&offset=20&page=1&extensions=base');
    setState(() {
      poisData = response.data['pois'];
    });
  }
}

class GymCard extends StatelessWidget {
  final Gym gym;

  const GymCard({super.key, required this.gym});

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) {
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) {
                      return GymPage(gym: gym);
                    },
                    settings:
                        RouteSettings(name: "gym", arguments: {"id": gym.id})))
            .then((value) {
          Navigator.of(context).pop();
        });
      },
      child: Container(
        height: 60,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              gym.name,
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              "距离您:${gym.distance}km",
              style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
            ),
          ],
        ),
      ),
    );
  }
}

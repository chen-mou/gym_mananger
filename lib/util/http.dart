import 'package:dio/dio.dart';

class HttpUtil {
  static const _baseUrl = "http://192.168.5.159:15666";
  static final _CookieInterceptor _cookieInterceptor = _CookieInterceptor();
  static final _dio = Dio()..interceptors.add(_cookieInterceptor);

  static Future<Response> get(String path, {Map<String, dynamic>? params}) {
    return _dio.get(_baseUrl + path,
        queryParameters: params,
        options: _cookieInterceptor.session == ""
            ? null
            : Options(headers: {
                "cookie": "JSESSIONID=${_cookieInterceptor.session}"
              }));
  }

  static Future<Response> post(String path, {Map<String, dynamic>? params}) {
    return _dio.post(_baseUrl + path,
        data: params,
        options: Options(
            headers: _cookieInterceptor.session == ""
                ? null
                : {"cookie": "JSESSIONID=${_cookieInterceptor.session}"},
            contentType: "application/json"));
  }

  static bool checkLogin() {
    return _cookieInterceptor.session != "";
  }
}

class _CookieInterceptor extends Interceptor {
  String session = '';
  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    var s = response.headers.value("set-cookie") ?? "";
    if (s != "") {
      session = s.split(";").first.split("=").last;
    }
    print("收到的session:$session");
    handler.next(response);
  }
}

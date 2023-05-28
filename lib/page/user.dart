import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym_mananger/state/user.dart';
import 'package:gym_mananger/util/http.dart';
import 'package:gym_mananger/util/toast.dart';
import 'package:provider/provider.dart';

import '../models/login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var headText = "登录";
  bool onload = false;
  bool isLogin = true;
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _affirm = TextEditingController();
  Future<Response<dynamic>> login() {
    return HttpUtil.post("/user/login",
        params: {"name": _username.text, "password": _password.text});
  }

  Future<Response> register() {
    return HttpUtil.post("/user/register",
        params: {"name": _username.text, "password": _password.text});
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData data = MediaQuery.of(context);
    double width = data.size.width * 0.6;
    double height = 80;
    EdgeInsets bottom = const EdgeInsets.only(bottom: 10);

    UserState userState = context.watch<UserState>();
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: bottom,
                width: width,
                height: height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isLogin ? "登录" : "注册",
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 40),
                    )
                  ],
                ),
              ),
              InputField(
                width: width,
                bottom: bottom,
                text: "用户名",
                controller: _username,
              ),
              InputField(
                width: width,
                bottom: bottom,
                text: "密码",
                controller: _password,
                obscureText: true,
              ),
              Offstage(
                offstage: isLogin,
                child: InputField(
                  width: width,
                  bottom: bottom,
                  text: "确认密码",
                  controller: _affirm,
                  obscureText: true,
                ),
              ),
              SizedBox(
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                        onPressed: () {
                          isLogin = !isLogin;
                          setState(() {});
                        },
                        child: Text(isLogin ? "注 册" : "已有账号?返回登录")),
                  ],
                ),
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(width, 50)),
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromRGBO(0, 170, 183, onload ? 0.3 : 1))),
                  onPressed: () async {
                    onload = true;
                    setState(() {});
                    Response resp;
                    try {
                      if (isLogin) {
                        resp = await login().then((value) {
                          Navigator.of(context).pop();
                          return value;
                        });
                      } else {
                        if (_affirm.text != _password.text) {
                          Toast(context).error("两次输入密码不一样");
                          return;
                        }
                        resp = await register().then((value) {
                          Navigator.of(context).pop();
                          return value;
                        });
                      }
                    } finally {
                      onload = false;
                      setState(() {});
                    }
                    Login l = Login.fromJson(resp.data);
                    userState.login(l.data);
                  },
                  child: !onload
                      ? Text(
                          isLogin ? "登录" : "注册",
                          style: const TextStyle(color: Colors.white),
                        )
                      : const CircularProgressIndicator())
            ],
          ),
        ],
      ),
    );
  }
}

class InputField extends StatefulWidget {
  const InputField(
      {Key? key,
      required this.width,
      required this.bottom,
      required this.text,
      required this.controller,
      this.obscureText = false})
      : super(key: key);

  final double width;
  final EdgeInsets bottom;
  final String text;
  final TextEditingController controller;
  final bool obscureText;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField>
    with SingleTickerProviderStateMixin {
  late Animation<Color?> _animation;
  late AnimationController _controller;
  late FocusNode _focusNode;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));

    _animation = ColorTween(
            begin: Colors.black12, end: const Color.fromRGBO(28, 115, 232, 1))
        .animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _focusNode = FocusNode()
      ..addListener(() {
        if (_focusNode.hasFocus) {
          _controller.forward();
        } else {
          _controller.reset();
        }
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      child: Container(
        width: widget.width,
        height: 60,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            border: Border.all(
                color: _animation.value ?? Colors.black12, width: 1)),
        margin: widget.bottom,
        child: TextField(
          obscureText: widget.obscureText,
          controller: widget.controller,
          focusNode: _focusNode,
          decoration:
              InputDecoration(hintText: widget.text, border: InputBorder.none),
        ),
      ),
    );
  }
}

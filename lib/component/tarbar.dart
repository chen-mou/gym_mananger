import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardElement {
  final String title;

  final Widget child;

  const CardElement({required this.title, required this.child});
}

class CardTarBar extends StatefulWidget {
  final List<CardElement> children;

  const CardTarBar({super.key, required this.children});

  @override
  State<StatefulWidget> createState() => _CardTarBar();
}

class _CardTarBar extends State<CardTarBar> {
  var now = 0;

  late Widget page;

  @override
  void initState() {
    super.initState();
    page = widget.children.isEmpty
        ? const Placeholder()
        : widget.children[0].child;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      children: [
        SizedBox(
          height: 100,
          child: Row(
            children: [
              for (var index = 0; index < widget.children.length; index++)
                Card(
                  onPress: () {
                    now = index;
                    page = widget.children[now].child;
                    setState(() {});
                  },
                  title: widget.children[index].title,
                  isClick: index == now,
                )
            ],
          ),
        ),
        page
      ],
    ));
  }
}

class Card extends StatefulWidget {
  final Function() onPress;
  final String title;
  final bool isClick;

  const Card(
      {super.key,
      required this.onPress,
      required this.title,
      this.isClick = false});

  @override
  State<StatefulWidget> createState() => _Card();
}

class _Card extends State<Card> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;
  late Animation<Color?> _textAnimation;

  @override
  void initState() {
    super.initState();
    // print("${widget.title}:$isClick");
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 100),
        value: widget.isClick ? 0 : 1);
    _animation = ColorTween(begin: Color(0xC9D3D3D3), end: Colors.orangeAccent)
        .animate(_controller)
      ..addListener(() {
        // print(_controller.status);
        setState(() {});
      });
    _textAnimation = ColorTween(begin: Colors.black, end: Colors.orangeAccent)
        .animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isClick) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    return Listener(
      onPointerDown: (e) {
        widget.onPress();
      },
      child: SizedBox(
        height: 80,
        width: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: Text(
                widget.title,
                style: TextStyle(color: _textAnimation.value, fontSize: 20),
              ),
            ),
            Container(
              height: 5,
              width: _controller.value * 180,
              decoration: BoxDecoration(
                  color: _animation.value,
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
            )
          ],
        ),
      ),
    );
  }
}

class VerticalTarbar extends StatefulWidget {
  final List<CardElement> children;

  const VerticalTarbar({super.key, required this.children});

  @override
  State<VerticalTarbar> createState() => _VerticalTarbarState();
}

class _VerticalTarbarState extends State<VerticalTarbar> {
  var now = 0;

  @override
  Widget build(BuildContext context) {
    return Expanded(child: LayoutBuilder(builder: (ctx, con) {
      return Row(
        children: [
          Container(
            width: con.maxWidth * 0.2,
            height: con.maxHeight,
            decoration: const BoxDecoration(
              color: Color(0xffeaebf1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                for (var i = 0; i < widget.children.length; i++)
                  Listener(
                    onPointerDown: (e) {
                      now = i;
                      setState(() {});
                    },
                    child: Container(
                      width: con.maxWidth * 0.2,
                      height: 50,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: (now == i ? Colors.white : Colors.transparent),
                      ),
                      child: Center(
                        child: Text(
                          widget.children[i].title,
                          style: TextStyle(
                              color: i == now ? Colors.blueGrey : Colors.black),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
          SizedBox(
              width: con.maxWidth * 0.8,
              height: con.maxHeight,
              child: widget.children[now].child)
        ],
      );
    }));
  }
}

import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

class BackgroundWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BackgroundWidgetState();
  }
}

class BackgroundWidgetState extends State<BackgroundWidget> {
  Alignment alignment = Alignment(0, 0);
  @override
  Widget build(BuildContext context) {
    listener();
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
      child: AnimatedAlign(
        alignment: alignment,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
        child: Image.asset(
          'assets/images/background.png',
          color: Color(0xff40404D),
        ),
      ),
    );
  }

  listener() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      print(event);
      alignment = Alignment(event.x * 0.3, event.y * 0.3);
      setState(() {});
    });
  }
}
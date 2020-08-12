import 'dart:math';

import 'package:car_repair_service/login/login.dart';
import 'package:car_repair_service/pages/login.dart';
import 'package:car_repair_service/state/state.dart';
import 'package:car_repair_service/transition/custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';

import 'menu.dart';

class LoaderPage extends StatefulWidget {
  @override
  _LoaderPageState createState() => _LoaderPageState();
}

class _LoaderPageState extends State<LoaderPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    _animation = Tween(begin: 0.0, end: 260.0).animate(_controller)
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          var store = StoreProvider.of<AppState>(context);
          Widget homeRoute = new LoginPage();
          if (store.state.authStatus == AuthStatus.LOGGED_IN) {
            homeRoute = new MenuPage();
          }
          Navigator.pushReplacement(
              context, MyCustomRoute(builder: (context) => homeRoute));
        }
      })
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Transform.scale(
              scale: (50 + _animation.value) /
                  MediaQuery.of(context).size.width *
                  3,
              child: Transform.translate(
                offset: Offset(_animation.value, 0),
                child: Transform.rotate(
                  angle: 2 * pi * _animation.value / 360,
                  child: SvgPicture.asset(
                    'assets/svg/wheel.svg',
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

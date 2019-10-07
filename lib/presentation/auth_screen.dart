import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mitso/app_theme.dart';

const TITLE_TEXT = 'Вход';
const BUTTON_TEXT = 'Войти';

class AuthScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Container(
            decoration: BoxDecoration(color: MAIN_COLOR_2),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 40, left: 40),
                  child: Text(
                    TITLE_TEXT,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton.extended(
              elevation: 4.0,
              backgroundColor: Colors.white,
              icon: const Icon(Icons.done, color: MAIN_COLOR_2),
              label: const Text(BUTTON_TEXT,
                  style: TextStyle(color: MAIN_COLOR_2)),
            )
        )
    );
  }
}

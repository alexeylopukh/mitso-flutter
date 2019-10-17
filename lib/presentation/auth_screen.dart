import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mitso/app_theme.dart';
import 'package:mitso/data/app_scope_data.dart';
import 'package:mitso/network/parser.dart';

const TITLE_TEXT = 'Вход в личный кабинет:';
const BUTTON_TEXT = 'Войти';

class AuthScreen extends StatefulWidget {

  AuthScreen();

  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {

  bool passwordHide;
  TextEditingController loginController;
  TextEditingController passController;
  AppScopeData appScopeData;


  @override
  void initState() {
    super.initState();
    passwordHide = true;
    loginController = TextEditingController();
    passController = TextEditingController();
  }

  @override
  Widget build(BuildContext baseContext) {
    appScopeData = AppScopeWidget.of(context);
    return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: MAIN_COLOR_2,
          child: Padding(
            padding: EdgeInsets.only(top: 20, left: 40, right: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text(
                    TITLE_TEXT,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                TextFormField(
                  controller: loginController,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(8.0),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(12.0))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                        borderRadius: BorderRadius.all(Radius.circular(12.0))),
                    hintText: "Лицевой счет",
                    hintStyle: TextStyle(color: Colors.white70),
                      suffixIcon: IconButton(
                          icon: Icon(Icons.clear, color: Colors.white),
                          onPressed: () {
                            loginController.clear();
                          }),

                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: TextFormField(
                    cursorColor: Colors.white,
                    controller: passController,
                    keyboardType: TextInputType.number,
                    obscureText: passwordHide,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8.0),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.all(Radius.circular(12.0))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                            borderRadius: BorderRadius.all(Radius.circular(12.0))),
                        hintText: "Пароль",
                        hintStyle: TextStyle(color: Colors.white70),
                        suffixIcon: IconButton(
                          icon: Icon(passwordHide
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white),
                          onPressed: () {
                            passwordHide = !passwordHide;
                            setState(() {});
                          },
                        )
                    ),
                  ),
                ),
                Spacer()
              ],
            )
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
              onPressed: () => startAuth()
            )
        )
    );
  }

  startAuth() async {
    final personInfo = await Parser().getAuth(
        loginController.text, passController.text);
    if (personInfo != null)
      appScopeData.setPersonInfo(personInfo, auth: true);
    else
      createErrorDialog(context);
  }

  createErrorDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            elevation: 4,
            title: Text('Ошибка'),
            content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Не удалось авторизоваться.'),
                    Text('Проверьте правильность введенных данных,'),
                    Text('а также Ваше интернет-соединение.'),
                  ],
                )),
            actions: <Widget>[
              FlatButton(
                child: Text('Ок'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],);
        });
  }

}

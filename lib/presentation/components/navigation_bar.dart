import 'package:flutter/material.dart';

class NavigationBar extends StatelessWidget {
  final void Function() onTap;
  final Widget child;
  final bool showButtonTitle;
  final bool showBackIcon;
  final bool showBottomLine;
  final Color backgroundColor;
  final Color buttonTitleColor;

  NavigationBar(
      {Key key,
      @required this.onTap,
      this.child,
      this.showButtonTitle = true,
      this.showBackIcon = true,
      this.showBottomLine = false,
      this.backgroundColor,
      this.buttonTitleColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
            child: Container(
          color: backgroundColor != null
              ? backgroundColor
              : Theme.of(context).backgroundColor,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          onTap();
                        },
                        child: Row(
                          children: <Widget>[
                            showBackIcon == true
                                ? IconButton(
                                    icon: Icon(Icons.arrow_back),
                                    onPressed: onTap,
                                  )
                                : Container(),
                            showButtonTitle == true
                                ? Text("Back", style: TextStyle(fontSize: 17.0))
                                : Container(),
                          ],
                        ),
                      ),
                      child != null
                          ? Flexible(
                              child: child,
                            )
                          : Container()
                    ],
                  )
                ],
              ),
              showBottomLine
                  ? SizedBox(
                      width: double.infinity,
                      child: Container(
                        height: 1.0,
                        color: Colors.grey,
                      ))
                  : Container()
            ],
          ),
        ))
      ],
    );
  }
}

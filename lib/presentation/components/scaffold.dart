import 'package:flutter/material.dart';

class GeneralScaffold extends StatelessWidget {
  final Widget child;
  final bool topConstraint;
  final bool bottomConstraint;
  final Widget bottomNavBar;
  final Widget floatButton;
  final Color backgroundColor;
  final AppBar appBar;

  GeneralScaffold(
      {@required this.child,
      this.topConstraint = true,
      this.bottomConstraint = true,
      this.bottomNavBar,
      this.floatButton,
      this.backgroundColor,
      this.appBar});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: this.backgroundColor == null
          ? Theme.of(context).backgroundColor
          : backgroundColor,
      child: SafeArea(
        bottom: bottomConstraint,
        top: topConstraint,
        child: Scaffold(
          appBar: this.appBar,
          body: child,
          bottomNavigationBar: bottomNavBar,
          floatingActionButton: floatButton,
        ),
      ),
    );
  }
}

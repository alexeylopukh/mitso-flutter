import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mitso/app_theme.dart';
import 'package:mitso/data/schedule_data.dart';

class PageItemWidget extends StatelessWidget {
  final Day day;
  final ScrollController controller;

  PageItemWidget({@required this.day, @required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: day.countLessons == 0
                ? Container(
                    child: Center(
                        child: Text(
                    "Занятия отсутсвуют",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: FONT_COLOR_2),
                  )))
                : ListView.builder(
                    controller: controller,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemBuilder: (context, position) {
                      if (day.lessons[position].aud != null)
                        return getCardItem(day.lessons[position], context);
                      else
                        return Container();
                    },
                    itemCount: day.lessons.length,
                  ),
          ),
        ],
      ),
    );
  }

  Widget getCardItem(Lesson lesson, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, bottom: 3),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 1.5,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text(
                  lesson.time,
                  style: Theme.of(context).accentTextTheme.headline6,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(lesson.lesson,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).accentTextTheme.bodyText2),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    lesson.aud,
                    style: Theme.of(context).accentTextTheme.headline6,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

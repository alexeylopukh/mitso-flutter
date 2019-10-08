import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mitso/app_theme.dart';
import 'package:mitso/data/schedule_data.dart';

class PageItemWidget extends StatelessWidget {
  final Day day;

  PageItemWidget(this.day);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: BACK_COLOR),
      child: Column(
        children: <Widget>[
          Expanded(
            child: day.countLessons == 0
                ? Container(
                child: Center(
                    child: Text(
                      "Занятия отсутсвуют",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                          color: FONT_COLOR_2),
                    )))
                : ListView.builder(
              padding: EdgeInsets.zero,
              //controller: _hideButtonController,
              shrinkWrap: true,
              itemBuilder: (context, position) {
                if (day.lessons[position].aud != null)
                  return getCardItem(day.lessons[position]);
                else
                  return Container();
              },
              itemCount: day.lessons.length,
            ),
          )
        ],
      ),
    );
  }

  Widget getCardItem(Lesson lesson) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, bottom: 3),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 1,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text(
                  lesson.time,
                  style: TextStyle(
                      fontFamily: 'Montserrat-bold',
                      color: FONT_COLOR_2,
                      fontSize: 16),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(lesson.lesson,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Montserrat-Light',
                          color: FONT_COLOR_2,
                          fontSize: 13)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    lesson.aud,
                    style: TextStyle(
                        fontFamily: 'Montserrat-Bold',
                        color: FONT_COLOR_2,
                        fontSize: 14),
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
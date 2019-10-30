import 'package:flutter/cupertino.dart';
import 'dart:convert';

const _NO_LESSON_TEXT = 'Нет занятий';

class Schedule {
  List<Day> days;

  Schedule({
    this.days,
  });

  factory Schedule.fromMap(Map<String, dynamic> json) => Schedule(
        days: List<Day>.from(json["days"].map((x) => Day.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "days": List<dynamic>.from(days.map((x) => x.toMap())),
      };
}

class Day {
  String data;
  String dayWeek;
  List<Lesson> lessons;
  int countLessons;

  Day(this.data, this.dayWeek, this.lessons) {
    final List<String> newAuds = List();
    var lastAud = 0;
    for (var lesson = 0; lesson < lessons.length; lesson++) {
      if (lessons[lesson].lesson == _NO_LESSON_TEXT) {
        lessons[lesson].lesson = null;
        newAuds.add(null);
      } else {
        newAuds.add(lessons[lastAud].aud);
        lastAud++;
      }
    }
    for (var lesson = 0; lesson < lessons.length; lesson++) {
      lessons[lesson].aud = newAuds[lesson];
    }
    countLessons = _getCountLessons();
  }

  factory Day.fromMap(Map<String, dynamic> json) => Day(
        json["data"],
        json["dayWeek"],
        List<Lesson>.from(json["lessons"].map((x) => Lesson.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "data": data,
        "dayWeek": dayWeek,
        "lessons": List<dynamic>.from(lessons.map((x) => x.toMap())),
      };

  int _getCountLessons() {
    int result = 0;
    for (int i = 0; i < lessons.length; i++) {
      if (lessons[i].aud != null) result++;
    }
    return result;
  }
}

class Lesson {
  String time;
  String lesson;
  String aud;

  Lesson({
    this.time,
    this.lesson,
    this.aud,
  });

  factory Lesson.fromMap(Map<String, dynamic> json) => Lesson(
        time: json["time"],
        lesson: json["lesson"],
        aud: json["aud"],
      );

  Map<String, dynamic> toMap() => {
        "time": time,
        "lesson": lesson,
        "aud": aud,
      };
}

class UserScheduleInfo {
  final String form;
  final String fak;
  final String kurs;
  final String group;

  const UserScheduleInfo({
    @required this.form,
    @required this.fak,
    @required this.kurs,
    @required this.group,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserScheduleInfo &&
          runtimeType == other.runtimeType &&
          form == other.form &&
          fak == other.fak &&
          kurs == other.kurs &&
          group == other.group);

  @override
  int get hashCode =>
      form.hashCode ^ fak.hashCode ^ kurs.hashCode ^ group.hashCode;

  @override
  String toString() {
    return 'UserScheduleInfo{' +
        ' form: $form,' +
        ' fak: $fak,' +
        ' kurs: $kurs,' +
        ' group: $group,' +
        '}';
  }

  UserScheduleInfo copyWith({
    String form,
    String fak,
    String kurs,
    String group,
  }) {
    return new UserScheduleInfo(
      form: form ?? this.form,
      fak: fak ?? this.fak,
      kurs: kurs ?? this.kurs,
      group: group ?? this.group,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'form': this.form,
      'fak': this.fak,
      'kurs': this.kurs,
      'group': this.group,
    };
  }

  factory UserScheduleInfo.fromMap(Map<String, dynamic> map) {
    return new UserScheduleInfo(
      form: map['form'] as String,
      fak: map['fak'] as String,
      kurs: map['kurs'] as String,
      group: map['group'] as String,
    );
  }
}

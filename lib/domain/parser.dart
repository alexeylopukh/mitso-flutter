import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:mitso/data/person_info_data.dart';
import 'package:mitso/data/schedule_data.dart';

const KAF = 'Glavnaya+kafedra';

class Parser {
  Future<List<String>> getFakList() async {
    var html = await http.get('https://mitso.by/schedule/search');
    var document = parse(html.body);
    List<Element> fakElementList = document.querySelectorAll('option');
    var fakList = _getTextListFromElementList(fakElementList);
    return fakList;
  }

  Future<List<String>> getFormList(String fak) async {
    var html = await http
        .get('https://mitso.by/schedule_update?type=form&kaf=$KAF&fak=$fak');
    var document = parse(html.body);
    List<Element> formElementList = document.querySelectorAll('option');
    var formList = _getTextListFromElementList(formElementList);
    return formList;
  }

  Future<List<String>> getKursList(String form, String fak) async {
    var html = await http.get(
        'https://mitso.by/schedule_update?type=kurse&kaf=$KAF&form=$form&fak=$fak');
    var document = parse(html.body);
    List<Element> kursElementList = document.querySelectorAll('option');
    var kursList = _getTextListFromElementList(kursElementList);
    return kursList;
  }

  Future<List<String>> getGroupList(
      String form, String fak, String kurs) async {
    var html = await http.get(
        'https://mitso.by/schedule_update?type=group_class&kaf=$KAF&form=$form'
        '&fak=$fak&kurse=$kurs');
    var document = parse(html.body);
    List<Element> groupElementList = document.querySelectorAll('option');
    var groupList = _getTextListFromElementList(groupElementList);
    return groupList;
  }

  Future<List<String>> getDateList(
      String form, String fak, String kurs, String group) async {
    var html = await http.get(
        'https://mitso.by/schedule_update?type=date&kaf=$KAF&form=$form&fak='
        '$fak&kurse=$kurs&group_class=$group');
    var document = parse(html.body);
    List<Element> groupElementList = document.querySelectorAll('option');
    var groupList = _getTextListFromElementList(groupElementList);
    return groupList;
  }

  List<String> _getTextListFromElementList(List<Element> elementList) {
    var resultList = List<String>();
    for (var i = 0; i < elementList.length; i++)
      resultList.add(elementList[i].text);
    return resultList;
  }

  Future<List<Day>> getWeek({Future<UserScheduleInfo> futureInfo, int week = 0}) async {
    var info = await futureInfo.then((value){
      return value;
    });
    var url =
        'https://mitso.by/schedule/${info.form}/${info.fak}/${info.kurs}/${info.group}/$week';
    var html = await http.get(url);
    var document = parse(html.body);
    List<Element> dateEl = document.querySelectorAll('div.rp-ras-data');
    List<Element> dayWeekEl = document.querySelectorAll('div.rp-ras-data2');
    List<Element> dayEl = document.querySelectorAll('div.rp-ras-opis');

    List<Day> days = List();
    for (var day = 0; day < dateEl.length; day++) {
      final List<Element> timeEl = dayEl[day].querySelectorAll('div.rp-r-time');
      final List<Element> lessonEl = dayEl[day].querySelectorAll('div.rp-r-op');
      final List<Element> audEl = dayEl[day].querySelectorAll('div.rp-r-aud');

      List<Lesson> lessons = List();

      for (var lesson = 0; lesson < timeEl.length; lesson++) {
        if (audEl.length > lesson)
          lessons.add(Lesson(
              time: timeEl[lesson].text,
              lesson: lessonEl[lesson].text,
              aud: audEl[lesson].text));
        else
          lessons.add(Lesson(time: timeEl[lesson].text,
              lesson: lessonEl[lesson].text,
              aud: ''));
      }

      days.add(Day(dateEl[day].text, dayWeekEl[day].text, lessons));
    }

    return days;
  }

  Future<PersonInfo> getAuth(String login, String password) async {
    var url = 'https://student.mitso.by/login_stud.php';
    Map<String, String> body = {'login':login, 'password':password};
    try {
      var html = await http.post(url, body: body);
      var document = parse(html.body);
      String name = document.querySelector('div.topmenu').text.trim();
      String info = document.querySelector('div [id=what_section]').text.trim();
      List<Element> balanceListEl = document.querySelectorAll('table td');
      double balance = double.parse(balanceListEl[1].text);
      double debt = double.parse(balanceListEl[3].text);
      double fine = double.parse(balanceListEl[5].text);
      return PersonInfo(
          name: name,
          info: info,
          balance: balance,
          debt: debt,
          fine: fine
      );
    } catch (error) {
      return null;
    }
  }
}

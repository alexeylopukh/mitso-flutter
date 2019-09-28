import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mitso/data/app_scope_data.dart';
import 'package:mitso/data/schedule_data.dart';
import 'package:mitso/domain/parser.dart';
import '../app_theme.dart';

class SchedulePagesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SchedulePagesScreenState();
  }
}

const double MAX_APPBAR_HEIGHT = 50;
const double MIN_APPBAR_HEIGHT = 0;

class SchedulePagesScreenState extends State<SchedulePagesScreen> {
  final _pageController = PageController(
    initialPage: 0,
  );

  GlobalKey<ScaffoldState> _key = GlobalKey();

  ScrollController _hideButtonController;

  double height = MAX_APPBAR_HEIGHT;
  double width = double.infinity;

  bool refresh = false;

  int selectedPage = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: BACK_COLOR, statusBarIconBrightness: Brightness.dark));
    _hideButtonController = new ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          height = MIN_APPBAR_HEIGHT;
        });
      } else {
        if (_hideButtonController.position.userScrollDirection ==
            ScrollDirection.forward) {
          setState(() {
            height = MAX_APPBAR_HEIGHT;
          });
        }
      }
    });
    _pageController.addListener(() {
      if (height != MAX_APPBAR_HEIGHT)
        setState(() {
          height = MAX_APPBAR_HEIGHT;
        });
    });

    refresh = true;
  }

  List<BottomNavigationBarItem> buildBottomNavBarItems(List<Day> list) {
    List<BottomNavigationBarItem> result = List();
    for (var i = 0; i < list.length; i++) {
      result.add(
        BottomNavigationBarItem(
            icon: Icon(
              null,
              size: 0,
            ),
            title: Column(
              children: <Widget>[
                Text(getShortNameOfDayWeek(list[i].dayWeek)),
                Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Text(getDigitFromString(list[i].data),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)))
              ],
            )),
      );
    }
    return result;
  }

  String getShortNameOfDayWeek(String longName) {
    switch (longName.toLowerCase()) {
      case 'понедельник':
        return 'ПН';
        break;
      case 'вторник':
        return 'ВТ';
        break;
      case 'среда':
        return 'СР';
        break;
      case 'четверг':
        return 'ЧТ';
        break;
      case 'пятница':
        return 'ПТ';
        break;
      case 'суббота':
        return 'СБ';
        break;
      case 'воскресенье':
        return 'ВС';
        break;
      default:
        return '';
    }
  }

  String getDigitFromString(String text) {
    List<String> list = text.split('');
    try {
      int.parse(list[0] + list[1]);
      return list[0] + list[1];
    } catch (e) {
      return list[0];
    }
  }

  void pageChanged(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  void tabTapped(int index) {
    setState(() {
      selectedPage = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 1000), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (refresh) updateSchedule();

    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: AnimatedOpacity(
          opacity: height == MAX_APPBAR_HEIGHT ? 1 : 0,
          duration: Duration(milliseconds: 200),
          child: FloatingActionButton.extended(
            elevation: 4.0,
            backgroundColor: FONT_COLOR_1,
            icon: const Icon(Icons.history),
            label: const Text('Сменить неделю'),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                  ),
                  builder: ((_) {
                    return FutureBuilder(
                      future: getDates()
                    );
                  })
              );
            },
          ),
        ),
        key: _key,
        bottomNavigationBar: PreferredSize(
          preferredSize: Size(
            width,
            height,
          ),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height: height,
            child: BottomAppBar(
                elevation: 2,
                color: MAIN_COLOR_1,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: FONT_COLOR_2,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                            ),
                            builder: ((_) {
                              return Container(
                                height: 200,

                              );
                            }));
                      },
                    ),
                  ],
                )),
          ),
        ),
        body: FutureBuilder(
          future: AppScopeWidget.of(context).schedule(),
          builder: (BuildContext context, AsyncSnapshot<Schedule> snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            if (snapshot.data == null) return Text('No data');
            return pageView(snapshot.data.days, _pageController);
          },
        ));
  }

  updateSchedule() async {
    final days = await Parser()
        .getWeek(futureInfo: AppScopeWidget.of(context).userScheduleInfo());
    final newSchedule = Schedule(days: days);
    final oldSchedule = await AppScopeWidget.of(context).schedule();
    if (newSchedule != null) {
      //ToDo: Добавить проврку действительно ли является новое расписание новым
      AppScopeWidget.of(context).setSchedule(newSchedule).then((_) {
        setState(() {
          refresh = false;
        });
      });
    }
  }

  Future<List<String>> getDates() async {
    final userInfo = await AppScopeWidget.of(context).userScheduleInfo();
    final list = await Parser().getDateList(
        userInfo.form, userInfo.fak,
        userInfo.kurs, userInfo.group);

  }

  Widget pageView(List<Day> list, PageController pageController) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: BACK_COLOR,
            selectedItemColor: FONT_COLOR_1,
            elevation: 8.0,
            items: buildBottomNavBarItems(list),
            currentIndex: selectedPage,
            onTap: (index) => tabTapped(index),
          ),
        ),
        Expanded(
          child: PageView.builder(
            itemBuilder: (context, position) => page(list[position]),
            controller: pageController,
            itemCount: list.length,
            onPageChanged: (index) => pageChanged(index),
          ),
        ),
      ],
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

  Widget page(Day day) {
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
                    controller: _hideButtonController,
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
}

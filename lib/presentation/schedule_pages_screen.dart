import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mitso/data/app_scope_data.dart';
import 'package:mitso/data/schedule_data.dart';
import 'package:mitso/domain/parser.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:toast/toast.dart';
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

  RefreshController _refreshController;

  GlobalKey<ScaffoldState> _key = GlobalKey();

  ScrollController _hideButtonController;

  double height = MAX_APPBAR_HEIGHT;
  double width = double.infinity;

  List<String> weekList;

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
    _refreshController = RefreshController(initialRefresh: true);
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
                        textAlign: TextAlign.center,
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
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: AnimatedOpacity(
          opacity: height == MAX_APPBAR_HEIGHT ? 1 : 0,
          duration: Duration(milliseconds: 200),
          child: FloatingActionButton.extended(
            elevation: 4.0,
            backgroundColor: MAIN_COLOR_2,
            icon: const Icon(Icons.history),
            label: const Text('Сменить неделю'),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),),
                  ),
                  builder: ((_) {
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 5, bottom: 5),
                          child: Container(height: 4, width: 60,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20)
                          ),),
                        ),
                        getWeekItems()
                      ],
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
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                            ),
                            builder: ((_) {
                              return Container(
                                height: 200,

                              );
                            })
                        );
                      },
                    ),
                  ],
                )),
          ),
        ),
        body: Container(
          color: BACK_COLOR,
          child: FutureBuilder(
            future: AppScopeWidget.of(context).schedule(),
            builder: (BuildContext context, AsyncSnapshot<Schedule> snapshot) {
              if (snapshot.hasData) {
                return pageView(snapshot.data.days, _pageController);
              }
              if (snapshot.connectionState == ConnectionState.waiting)
                return Container();
              if (snapshot.data == null) {
                return loadSchedule();
              }
                return Container();
            },
          ),
        )
    );
  }

  Widget getWeekItems() {
    List<Widget> childrens = List();
    childrens.add(Container(
        decoration: new BoxDecoration(
            color: Colors.grey,
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(40.0),
                topRight: const Radius.circular(40.0)))));
    for (int i = 0; i < weekList.length; i++) {
      childrens.add(OutlineButton(
          borderSide: BorderSide(color: FONT_COLOR_2, width: 2),
          shape: StadiumBorder(),
          child: Text(weekList[i], style: TextStyle(
              color: FONT_COLOR_2, fontSize: 18)),
          onPressed: () {
            int week;
            try {
              week = int.parse(
                  getDigitFromString(weekList[i]));
            } catch (e) {
              week = 0;
            }
            Navigator.pop(context);
            refreshSchedule(week: week);
          }));
    }
    return Column(
        children: childrens
    );
  }

  Widget loadSchedule() {
    getDates().then((weeks) {
      weekList = weeks;
    });
    _refreshController = RefreshController(initialRefresh: false);
    return Center(
      child: FutureBuilder(
          future: Parser()
              .getWeek(futureInfo: AppScopeWidget.of(context).userScheduleInfo()),
          builder: (BuildContext context, AsyncSnapshot<List<Day>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Container(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          MAIN_COLOR_2))
              );
            if (snapshot.hasData) {
              List<Day> days = snapshot.data;
              AppScopeWidget.of(context).setSchedule(Schedule(days: days));
              return pageView(days, _pageController);
            }
            if (snapshot.hasError)
              return getErrorDialog(context);
            return Container();
          })
    );
  }

  refreshSchedule({int week = 0}) async {
    _refreshController.requestRefresh();
    try {
      getDates().then((weeks) {
        weekList = weeks;
      });
      final days = await Parser()
          .getWeek(futureInfo: AppScopeWidget.of(context).userScheduleInfo(),
          week: week);
      final newSchedule = Schedule(days: days);
      final oldSchedule = await AppScopeWidget.of(context).schedule();
      _refreshController.refreshCompleted();
      if (newSchedule != null) {
        //ToDo: Добавить проврку действительно ли является новое расписание новым
        AppScopeWidget.of(context).setSchedule(newSchedule).then((_) {
          setState(() {
          });
        });
      }
    } catch(error) {
      _refreshController.refreshCompleted();
      Toast.show("Не удалось обновить распсиание", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  Future<List<String>> getDates() async {
    final userInfo = await AppScopeWidget.of(context).userScheduleInfo();
    final list = await Parser().getDateList(
        userInfo.form, userInfo.fak,
        userInfo.kurs, userInfo.group);
    return list;
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
            elevation: 2,
            items: buildBottomNavBarItems(list),
            currentIndex: selectedPage,
            onTap: (index) => tabTapped(index),
          ),
        ),
        Expanded(
          child: SmartRefresher(
            controller: _refreshController,
            onRefresh: refreshSchedule,
            header: CustomHeader(
                builder: (BuildContext context, RefreshStatus status) {
                  if (status == RefreshStatus.idle) return Container();
                  return Center(
                      child: Container(
                          width: 20.0,
                          height: 20.0,
                          margin: EdgeInsets.only(bottom: 15.0),
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  MAIN_COLOR_2),
                              strokeWidth: 2.0)));
                }),
            footer: CustomFooter(
                loadStyle: LoadStyle.ShowWhenLoading,
                builder: (BuildContext context, LoadStatus mode) {
                  if (mode == LoadStatus.idle) return Container();
                  return Center(
                      child: Container(
                          margin: EdgeInsets.only(top: 20.0),
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  MAIN_COLOR_2),
                              strokeWidth: 2.0)));
                }
            ),
            child: PageView.builder(
              itemBuilder: (context, position) => page(list[position]),
              controller: pageController,
              itemCount: list.length,
              onPageChanged: (index) => pageChanged(index),
            ),
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

  Widget getErrorDialog(context) {
    return AlertDialog(
      elevation: 4,
      title: Text('Ошибка'),
      content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Не удалось получить данные.'),
              Text('Рекомендуем посетить сайт и проверить расписание вручную.'),
              Text('А также Ваше интернет-соединение.'),
            ],
          )),
      actions: <Widget>[
        FlatButton(
          child: Text('Посетить сайт'),
          onPressed: () {
            _launchURL("https://www.mitso.by/schedule/search");
          },
        ),
        FlatButton(
          child: Text('Обновить'),
          onPressed: () {
            setState(() {

            });
          },
        ),
      ],);
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

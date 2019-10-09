import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mitso/data/app_scope_data.dart';
import 'package:mitso/data/schedule_data.dart';
import 'package:mitso/network/parser.dart';
import 'package:mitso/presentation/schedule_screen/page_item_widget.dart';
import 'package:mitso/presentation/schedule_screen/schedule_screen_presenter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../app_theme.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScheduleScreenState();
  }
}

const double MAX_APPBAR_HEIGHT = 50;
const double MIN_APPBAR_HEIGHT = 0;

class ScheduleScreenState extends State<ScheduleScreen> {
  ScheduleScreenPresenter presenter;

  PageController _pageController;

  RefreshController _refreshController;

  GlobalKey<ScaffoldState> _key = GlobalKey();

  ScrollController _hideButtonController;

  double height = MAX_APPBAR_HEIGHT;
  double width = double.infinity;

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

    _pageController = PageController(
      initialPage: 0,
    );
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
                Text(presenter.getShortNameOfDayWeek(list[i].dayWeek)),
                Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Text(presenter.getDigitFromString(list[i].data).toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)))
              ],
            )),
      );
    }
    return result;
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
    if (presenter == null) {
      presenter = ScheduleScreenPresenter(
          this, AppScopeWidget.of(context), Parser());
    }
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
    for (int i = 0; i < presenter.weekList.length; i++) {
      childrens.add(OutlineButton(
          borderSide: BorderSide(color: FONT_COLOR_2, width: 2),
          shape: StadiumBorder(),
          child: Text(presenter.weekList[i], style: TextStyle(
              color: FONT_COLOR_2, fontSize: 18)),
          onPressed: () {
            int week;
            try {
              week = presenter.getDigitFromString(presenter.weekList[i]);
            } catch (e) {
              week = 0;
            }
            Navigator.pop(context);
            presenter.refreshSchedule(week: week);
          }));
    }
    return Column(
        children: childrens
    );
  }

  Widget loadSchedule() {
    _refreshController = RefreshController(initialRefresh: false);
    return Center(
      child: FutureBuilder(
          future: presenter.loadSchedule(),
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
              presenter.createErrorDialog(context);
            return Container();
          })
    );
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
            onRefresh: presenter.onRefresh(),
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
              itemBuilder: (context, position) => PageItemWidget(list[position]),
              controller: pageController,
              itemCount: list.length,
              onPageChanged: (index) => pageChanged(index),
            ),
          ),
        ),
      ],
    );
  }



  forceRefresh() {
    _refreshController.requestRefresh();
  }

  completeRefresh() {
    _refreshController.refreshCompleted();
  }

  update(){
    setState(() {});
  }


}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mitso/data/app_scope_data.dart';
import 'package:mitso/data/schedule_data.dart';
import 'package:mitso/interactor/get_digit_from_string.dart';
import 'package:mitso/interactor/parser.dart';
import 'package:mitso/presentation/schedule_screen/widgets/menu_widget.dart';
import 'package:mitso/presentation/schedule_screen/widgets/page_item_widget.dart';
import 'package:mitso/presentation/schedule_screen/schedule_screen_presenter.dart';
import 'package:mitso/presentation/schedule_screen/widgets/schedule_widget/weeks_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../app_theme.dart';

class ScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppScopeWidget.of(context).analyticsHelper.sendCurrentScreenToAnalytics(
        'Screen', 'Schedule', 'Schedule pages screen');
    return ScheduleScreenWidget();
  }
}

class ScheduleScreenWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScheduleScreenWidgetState();
  }
}

const double MAX_APPBAR_HEIGHT = 50;
const double MIN_APPBAR_HEIGHT = 0;

class ScheduleScreenWidgetState extends State<ScheduleScreenWidget> {
  ScheduleScreenPresenter presenter;

  PageController _pageController;

  RefreshController _refreshController;

  GlobalKey<ScaffoldState> _key = GlobalKey();

//  ScrollController _hideButtonController;

  double height = MAX_APPBAR_HEIGHT;
  double width = double.infinity;

  int selectedPage = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: BACK_COLOR,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));
    /*
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
    });*/

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
                    child: Text(
                        GetDigitFromString(text: list[i].data)
                            .execute()
                            .toString(),
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
      presenter =
          ScheduleScreenPresenter(this, AppScopeWidget.of(context), Parser());
    }
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: AnimatedOpacity(
          opacity: height == MAX_APPBAR_HEIGHT ? 1 : 0,
          duration: Duration(milliseconds: 200),
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: FloatingActionButton.extended(
              elevation: 4.0,
              backgroundColor: MAIN_COLOR_2,
              icon: const Icon(Icons.history),
              label: const Text('Сменить неделю'),
              onPressed: () async {
                AppScopeWidget.of(context).adManager.hideMainBanner();
                showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        builder: ((_) {
                          return Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: Container(
                                  height: 4,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                              ),
                              WeeksWidget(weeks: presenter.weekList)
                            ],
                          );
                        }))
                    .then((result) {
                  AppScopeWidget.of(context).adManager.showMainBanner();
                  if (result != null && result.containsKey('week')) {
                    presenter.refreshSchedule(week: result['week']);
                  }
                });
              },
            ),
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
                      onPressed: () async {
                        AppScopeWidget.of(context).adManager.hideMainBanner();
                        final userScheduleInfo =
                            await presenter.userScheduleInfo;
                        final personInfo =
                            await presenter.appScopeData.personInfo();
                        showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                ),
                                builder: ((_) {
                                  return MenuWidget(
                                      presenter: this.presenter,
                                      userScheduleInfo: userScheduleInfo,
                                      personInfo: personInfo);
                                }))
                            .then((_) {
                          AppScopeWidget.of(context).adManager.showMainBanner();
                        });
                      },
                    ),
                  ],
                )),
          ),
        ),
        body: Container(color: BACK_COLOR, child: body()));
  }

  Widget body() {
    switch (presenter.scheduleStatus) {
      case ScheduleStatus.FirstLoad:
        _refreshController = RefreshController(initialRefresh: false);
        return Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(MAIN_COLOR_2)),
        );
        break;
      case ScheduleStatus.Empty:
        return Center(child: Text('Рассписание отсуствует'));
        break;
      case ScheduleStatus.Loaded:
        return pageView(presenter.schedule.days, _pageController);
        break;
      default:
        return Container();
    }
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
          child: Padding(
            padding: EdgeInsets.only(bottom: presenter.isAdShowed ? 60 : 0),
            child: SmartRefresher(
              controller: _refreshController,
              onRefresh: presenter.onRefresh,
              header: CustomHeader(
                  builder: (BuildContext context, RefreshStatus status) {
                if (status == RefreshStatus.idle) return Container();
                return Center(
                    child: Container(
                        width: 20.0,
                        height: 20.0,
                        margin: EdgeInsets.only(bottom: 15.0),
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(MAIN_COLOR_2),
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
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(MAIN_COLOR_2),
                                strokeWidth: 2.0)));
                  }),
              child: PageView.builder(
                itemBuilder: (context, position) => PageItemWidget(
                  day: list[position],
//                controller: _hideButtonController,
                ),
                controller: pageController,
                itemCount: list.length,
                onPageChanged: (index) => pageChanged(index),
              ),
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

  update() {
    setState(() {});
  }

  @override
  void dispose() {
    AppScopeWidget.of(context).adManager.hideMainBanner();
    super.dispose();
  }
}
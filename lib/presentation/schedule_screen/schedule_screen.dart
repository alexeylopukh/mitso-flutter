import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mitso/data/app_scope_data.dart';
import 'package:mitso/data/schedule_data.dart';
import 'package:mitso/interactor/get_digit_from_string.dart';
import 'package:mitso/interactor/parser.dart';
import 'package:mitso/presentation/schedule_screen/widgets/background_widget.dart';
import 'package:mitso/presentation/schedule_screen/widgets/menu_widget.dart';
import 'package:mitso/presentation/schedule_screen/widgets/page_item_widget.dart';
import 'package:mitso/presentation/schedule_screen/schedule_screen_presenter.dart';
import 'package:mitso/presentation/schedule_screen/widgets/schedule_widget/weeks_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vibration/vibration.dart';
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

  PageController pageController;

  RefreshController _refreshController;

  GlobalKey<ScaffoldState> _key = GlobalKey();

  ScrollController scrollController;

  double height = MAX_APPBAR_HEIGHT;
  double width = double.infinity;

  int selectedPage = 0;
  bool isFirstView = true;

  bool hasVibrator = false;

  @override
  void initState() {
    super.initState();
    Vibration.hasVibrator().then((result) {
      hasVibrator = result;
    });
    scrollController = ScrollController();
    /*
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

    pageController = PageController(
      initialPage: 0,
    );
    pageController.addListener(() {
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
    if (hasVibrator &&
        AppScopeWidget.of(context).appSettings.isVibrationEnabled) {
      Vibration.vibrate(duration: 10);
    }
    setState(() {
      selectedPage = index;
    });
  }

  void tabTapped(int index) {
    try {
      selectedPage = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 1000), curve: Curves.ease);
    } catch (e) {}
  }

  AppScopeData appScope;

  @override
  Widget build(BuildContext context) {
    appScope = AppScopeWidget.of(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).backgroundColor,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarColor: Theme.of(context).bottomAppBarColor,
        systemNavigationBarIconBrightness:
            Theme.of(context).brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark));
    if (presenter == null) {
      presenter =
          ScheduleScreenPresenter(this, AppScopeWidget.of(context), Parser());
      presenter.checkAppVersion(context);
    }
    return Container(
      color: Theme.of(context).backgroundColor,
      child: SafeArea(
        child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: AnimatedOpacity(
              opacity: height == MAX_APPBAR_HEIGHT ? 1 : 0,
              duration: Duration(milliseconds: 200),
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: FloatingActionButton.extended(
                  elevation: 4.0,
                  backgroundColor: Theme.of(context).buttonColor,
                  icon: const Icon(
                    Icons.history,
                    color: Colors.white,
                  ),
                  label: Text(
                      (presenter.currentWeek == 0
                              ? 'Текущая'
                              : '${presenter.currentWeek + 1}') +
                          ' неделя',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    AppScopeWidget.of(context).adManager.canLaunchAd = false;
                    AppScopeWidget.of(context).adManager.hideMainBanner();
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        builder: ((_) {
                          return Wrap(
                            children: <Widget>[
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      child: Container(
                                        height: 4,
                                        width: 60,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      ),
                                    ),
                                    WeeksWidget(weeks: presenter.weekList)
                                  ],
                                ),
                                width: double.infinity,
                              )
                            ],
                          );
                        })).then((result) {
                      AppScopeWidget.of(context).adManager.canLaunchAd = true;
                      AppScopeWidget.of(context)
                          .remoteConfig
                          .then((remoteConfig) {
                        AppScopeWidget.of(context)
                            .adManager
                            .showMainBanner(remoteConfig);
                        if (result != null && result.containsKey('week')) {
                          presenter.currentWeek = result['week'];
                          forceRefresh();
                          //presenter.refreshSchedule(week: );
                        }
                      });
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
                    color: Theme.of(context).bottomAppBarColor,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: FONT_COLOR_2,
                          ),
                          onPressed: () {
                            AppScopeWidget.of(context).adManager.canLaunchAd =
                                false;
                            AppScopeWidget.of(context)
                                .adManager
                                .hideMainBanner();
                            presenter.userScheduleInfo.then((userScheduleInfo) {
                              presenter.appScopeData
                                  .personInfo()
                                  .then((personInfo) {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20)),
                                    ),
                                    builder: ((_) {
                                      return Wrap(
                                        children: <Widget>[
                                          MenuWidget(
                                              presenter: this.presenter,
                                              userScheduleInfo:
                                                  userScheduleInfo,
                                              personInfo: personInfo),
                                        ],
                                      );
                                    })).then((_) {
                                  AppScopeWidget.of(context)
                                      .adManager
                                      .canLaunchAd = true;
                                  AppScopeWidget.of(context)
                                      .remoteConfig
                                      .then((remoteConfig) {
                                    AppScopeWidget.of(context)
                                        .adManager
                                        .showMainBanner(remoteConfig);
                                  });
                                });
                              });
                            });
                          },
                        ),
                      ],
                    )),
              ),
            ),
            body: Stack(
              children: <Widget>[BackgroundWidget(), body()],
            )),
      ),
    );
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
        return Center(
            child: Text('Расписание отсутствует',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: FONT_COLOR_2)));
        break;
      case ScheduleStatus.Loaded:
        return pageView(presenter.schedule.days, pageController);
        break;
      default:
        return Container();
    }
  }

  Widget pageView(List<Day> list, PageController pageController) {
    Future.delayed(Duration(milliseconds: 100), () {
      if (isFirstView) {
        final route = presenter.goToCurrentDay();
        if (route) isFirstView = false;
      }
    });
    return SafeArea(
      child: Column(
        children: <Widget>[
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).backgroundColor,
            selectedItemColor: FONT_COLOR_1,
            elevation: 2,
            items: buildBottomNavBarItems(list),
            currentIndex: selectedPage,
            onTap: (index) => tabTapped(index),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: presenter.isAdShowed ? 60 : 0),
              child: SmartRefresher(
                controller: _refreshController,
                scrollController: scrollController,
                onRefresh: presenter.refreshSchedule,
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      MAIN_COLOR_2),
                                  strokeWidth: 2.0)));
                    }),
                child: PageView.builder(
                  itemBuilder: (context, position) => PageItemWidget(
                    day: list[position],
                    controller: scrollController,
                  ),
                  controller: pageController,
                  itemCount: list.length,
                  onPageChanged: (index) => pageChanged(index),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  forceRefresh() async {
    appScope.remoteConfig.then((c) {
      appScope.adManager.showFullScreen(c);
    });
    _refreshController.requestRefresh();
  }

  completeRefresh() {
    _refreshController.refreshCompleted();
  }

  update() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    presenter.dispose();
    presenter = null;
    appScope.adManager.hideMainBanner();
    super.dispose();
  }
}

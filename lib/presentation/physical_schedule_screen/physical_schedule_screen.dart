import 'package:flutter/material.dart';
import 'package:mitso/data/app_scope_data.dart';
import 'package:mitso/presentation/physical_schedule_screen/physical_schedule_presenter.dart';
import 'package:url_launcher/url_launcher.dart';

class PhysicalScheduleScreen extends StatefulWidget {
  PhysicalScheduleScreen({Key key}) : super(key: key);

  @override
  PhysicalScheduleScreenState createState() => PhysicalScheduleScreenState();
}

class PhysicalScheduleScreenState extends State<PhysicalScheduleScreen> {
  PhysicalSchedulePresenter presenter;

  @override
  Widget build(BuildContext context) {
    if (presenter == null)
      presenter = PhysicalSchedulePresenter(
          view: this, appScopeData: AppScopeWidget.of(context));

    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          body: Container(child: Center(child: generateBody())),
        ),
      ),
    );
  }

  update() {
    setState(() {});
  }

  Widget generateBody() {
    switch (presenter.currentStatus) {
      case PhysicalScheduleStatus.Loading:
        return CircularProgressIndicator();
        break;
      case PhysicalScheduleStatus.Loaded:
        return ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemBuilder: (context, position) {
            return GestureDetector(
              onTap: () => _launchURL(presenter.scheduleList[position].url),
              child: Text(presenter.scheduleList[position].text),
            );
          },
          itemCount: presenter.scheduleList.length,
        );
        break;
      case PhysicalScheduleStatus.Error:
        return Text('Произошла ошибка');
        break;
      default:
        return Container();
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:mitso/data/app_scope_data.dart';
import 'package:mitso/data/physical_schedule_data.dart';
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
        final childrens = List<Widget>();
        childrens.add(Text(
          'РАСПИСАНИЕ ЗАНЯТИЙ ПО ФИЗКУЛЬТУРЕ',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ));
        for (var fsi in presenter.scheduleList) {
          childrens.add(generatePhysicalScheduleItem(fsi));
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: childrens,
            ),
          ),
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

  generatePhysicalScheduleItem(PhysicalScheduleData item) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: GestureDetector(
          onTap: () => _launchURL(item.url),
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
                    child: Text(
                      item.text,
                      style: TextStyle(fontSize: 20),
                    ),
                  )),
                  Icon(Icons.arrow_forward_ios)
                ],
              )),
        ));
  }
}

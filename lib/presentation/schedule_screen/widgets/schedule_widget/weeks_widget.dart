import 'package:flutter/material.dart';
import 'package:mitso/app_theme.dart';
import 'package:mitso/data/app_scope_data.dart';
import 'package:mitso/interactor/get_digit_from_string.dart';
import 'package:mitso/presentation/schedule_screen/widgets/schedule_widget/weeks_widget_presenter.dart';

class WeeksWidget extends StatefulWidget {
  final List<String> weeks;

  WeeksWidget({this.weeks});

  @override
  WeeksWidgetState createState() => WeeksWidgetState();
}

class WeeksWidgetState extends State<WeeksWidget> {
  WeeksWidgetPresenter presenter;

  @override
  Widget build(BuildContext context) {
    if (presenter == null)
      presenter = WeeksWidgetPresenter(
          view: this, appScopeData: AppScopeWidget.of(context), weeks: widget.weeks);
    return generateBody();
  }

  Widget generateBody() {
    if (presenter.status == WeeksStatus.Loading)
      return loadingWidget();
    else if (presenter.status == WeeksStatus.Loaded)
      return weeksWidget();
    else if (presenter.status == WeeksStatus.Empty)
      return emptyWidget();
    else if (presenter.status == WeeksStatus.Error) return errorWidget();
    return Container();
  }

  Widget weeksWidget() {
    final List<Widget> result = [];
    presenter.weeks.forEach((String weekName) {
      result.add(Padding(
        padding: EdgeInsets.only(right: 20, left: 20, bottom: 5),
        child: OutlineButton(
          borderSide: BorderSide(color: FONT_COLOR_2, width: 2),
          shape: StadiumBorder(),
          child: Text(weekName, style: TextStyle(color: FONT_COLOR_2, fontSize: 18)),
          onPressed: () {
            int week;
            try {
              week = GetDigitFromString(text: weekName).execute() - 1;
            } catch (e) {
              week = 0;
            }
            Navigator.of(context).pop({'week': week});
          },
        ),
      ));
    });
    return Column(
      children: result,
    );
  }

  Widget loadingWidget() {
    return Center(
      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(MAIN_COLOR_2)),
    );
  }

  Widget emptyWidget() {
    return Container(
        height: 150,
        alignment: Alignment.center,
        child: Text(
          'Данные отсутвуют :(',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ));
  }

  Widget errorWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Произошла ошибка при попытке загрузить данные'),
        OutlineButton(
            borderSide: BorderSide(color: FONT_COLOR_2, width: 2),
            shape: StadiumBorder(),
            child: Text('Повторить попытку', style: TextStyle(color: FONT_COLOR_2, fontSize: 18)),
            onPressed: () {
              presenter.updateWeeks();
            })
      ],
    );
  }

  update() {
    setState(() {});
  }

  @override
  void dispose() {
    presenter.dispose();
    presenter = null;
    super.dispose();
  }
}

import 'package:flutter/cupertino.dart';
import 'package:mitso/data/app_scope_data.dart';
import 'package:mitso/interactor/parser.dart';
import 'package:mitso/presentation/schedule_screen/widgets/schedule_widget/weeks_widget.dart';

class WeeksWidgetPresenter {
  WeeksWidgetState view;
  AppScopeData appScopeData;
  List<String> weeks;
  Parser parser;
  WeeksStatus status;

  WeeksWidgetPresenter(
      {@required this.view,
      @required this.appScopeData,
      @required this.weeks}) {
    parser = Parser();
    if (weeks == null) {
      status = WeeksStatus.Loading;
      loadWeeks();
    } else {
      if (weeks.length > 0)
        status = WeeksStatus.Loaded;
      else
        status = WeeksStatus.Empty;
    }
  }

  updateWeeks() {
    status = WeeksStatus.Loading;
    loadWeeks();
  }

  loadWeeks() async {
    status = WeeksStatus.Loading;
    final userScheduleInfo = await appScopeData.userScheduleInfo();
    parser
        .getWeekList(
            form: userScheduleInfo.form,
            fak: userScheduleInfo.fak,
            kurs: userScheduleInfo.kurs,
            group: userScheduleInfo.group)
        .catchError((error) => onError(error))
        .then((weeks) {
      if (status != WeeksStatus.Error) {
        if (weeks == null || weeks.length == 0)
          status = WeeksStatus.Empty;
        else {
          this.weeks = weeks;
          if (weeks.length > 0)
            status = WeeksStatus.Loaded;
          else
            status = WeeksStatus.Empty;
        }
      }
      view.update();
    });
  }

  onError(e) {
    print(e);
    status = WeeksStatus.Error;
  }

  dispose() {
    view = null;
    appScopeData = null;
  }
}

enum WeeksStatus { Empty, Loading, Loaded, Error }

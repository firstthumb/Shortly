import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:shortly/app/view/bloc/tab/tab_event.dart';
import 'package:shortly/app/view/models/app_tab.dart';

class TabBloc extends Bloc<TabEvent, AppTab> {
  @override
  AppTab get initialState => AppTab.home;

  @override
  Stream<AppTab> mapEventToState(TabEvent event) async* {
    if (event is UpdateTab) {
      yield event.tab;
    }
  }
}

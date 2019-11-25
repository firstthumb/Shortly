import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:shortly/app/view/bloc/blocs.dart';
import 'package:shortly/app/view/bloc/tab/tab_event.dart';

class TabBloc extends Bloc<TabEvent, TabState> {
  @override
  TabState get initialState => HomeTab();

  @override
  Stream<TabState> mapEventToState(TabEvent event) async* {
    if (event is UpdateTab) {
      switch (event.tab) {
        case AppTab.home:
          yield HomeTab();
          break;
        case AppTab.settings:
          yield SettingsTab();
          break;
      }
    }
  }
}

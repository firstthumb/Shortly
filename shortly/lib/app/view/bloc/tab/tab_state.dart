import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum AppTab { home, favourites, settings }

@immutable
abstract class TabState extends Equatable {
  TabState([List props = const <dynamic>[]]) : super(props);

  AppTab get currentTab;
}

class HomeTab extends TabState {
  final AppTab tab = AppTab.home;

  @override
  List get props => [tab];

  @override
  AppTab get currentTab => tab;
}

class FavouritesTab extends TabState {
  final AppTab tab = AppTab.favourites;

  @override
  List get props => [tab];

  @override
  AppTab get currentTab => tab;
}

class SettingsTab extends TabState {
  final AppTab tab = AppTab.settings;

  @override
  List get props => [tab];

  @override
  AppTab get currentTab => tab;
}

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shortly/app/view/bloc/tab/tab_state.dart';

@immutable
abstract class TabEvent extends Equatable {
  TabEvent([List props = const <dynamic>[]]) : super(props);
}

class UpdateTab extends TabEvent {
  final AppTab tab;

  UpdateTab(this.tab) : super([tab]);

  @override
  String toString() => 'UpdateTab { tab: $tab }';
}

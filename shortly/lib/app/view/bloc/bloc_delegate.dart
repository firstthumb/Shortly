import 'package:bloc/bloc.dart';
import 'package:shortly/core/util/logger.dart';

class SimpleBlocDelegate extends BlocDelegate {
  final logger = getLogger('SimpleBlocDelegate');

  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    logger.v(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    logger.v(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    logger.v(error);
  }
}

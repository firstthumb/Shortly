import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../blocs.dart';
import 'fav_event.dart';
import 'fav_state.dart';

class FavBloc extends Bloc<FavEvent, FavState> {
  final ShortenBloc shortenBloc;
  StreamSubscription shortenSubscription;

  FavBloc({@required this.shortenBloc}) {
    print("***********");
    print("FavBloc");
    print("***********");
    shortenSubscription = shortenBloc.listen((state) {
      if (state is Loaded) {
        add(FavListEvent(shortens: state.shortens));
      }

      print("FavBloc listen $state");
    }, onError: (error) {
      print("ON_ERROR : $error");
    });
  }

  @override
  FavState get initialState => FavEmpty();

  @override
  Stream<FavState> mapEventToState(FavEvent event) async* {
    print("FavBloc mapEventToState $state");
    if (event is FavListEvent) {
      yield FavLoaded(shortens: event.shortens);
    }
  }

  @override
  Future<void> close() {
    shortenSubscription.cancel();
    return super.close();
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:shortly/app/domain/entities/shorten.dart';
import 'package:shortly/app/domain/usecases/get_fav_shorten_list_usecase.dart';
import 'package:shortly/core/error/failures.dart';
import 'package:shortly/core/usecases/usecase.dart';

import 'fav_event.dart';
import 'fav_state.dart';

class FavBloc extends Bloc<FavEvent, FavState> {
  final GetFavShortenListUseCase getFavShortenList;

  FavBloc({
    @required this.getFavShortenList,
  });

  @override
  FavState get initialState => FavEmpty();

  @override
  Stream<FavState> mapEventToState(FavEvent event) async* {
    if (event is FavListEvent) {
      yield FavLoading();
      yield* _mapGetFavShortenListToState(await getFavShortenList(NoParams()));
    }
  }

  Stream<FavState> _mapGetFavShortenListToState(
      Either<Failure, List<Shorten>> either) async* {
    yield either.fold(
          (failure) => FavError(message: "Load shorten failed : $failure"),
          (result) => FavLoaded(shortens: result),
    );
  }
}

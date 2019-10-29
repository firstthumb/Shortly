import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:shortly/app/domain/entities/shorten.dart';
import 'package:shortly/app/domain/usecases/usecases.dart';
import 'package:shortly/app/view/bloc/shorten/shorten_event.dart';
import 'package:shortly/app/view/bloc/shorten/shorten_state.dart';
import 'package:shortly/core/error/failures.dart';

class ShortenBloc extends Bloc<ShortenEvent, ShortenState> {
  final AddShortenUseCase addShorten;

  ShortenBloc({
    @required this.addShorten,
  });

  @override
//  ShortenState get initialState => Empty();
  ShortenState get initialState =>
      Loaded(shortens: [
        Shorten(link: "Link", shortLink: "Short Link", fav: true)
      ]);

  @override
  Stream<ShortenState> mapEventToState(ShortenEvent event) async* {
    if (event is GetShortenListEvent) {
      yield Loading();
//      yield* _mapLoadTodoToState(await getShortenList(GetShortenListParam(filter: event.filter)));
    } else if (event is AddShortenEvent) {
      yield Loading();
      yield* _mapAddShortenToState(await addShorten(
          AddShortenParam(link: event.link, shortLink: event.shortLink)));
    }
  }

  Stream<ShortenState> _mapLoadShortenToState(
      Either<Failure, List<Shorten>> either) async* {
    yield either.fold(
      (failure) => Error(message: "Load shorten failed : $failure"),
      (result) => Loaded(shortens: result),
    );
  }

  Stream<ShortenState> _mapAddShortenToState(
      Either<Failure, Shorten> either) async* {
    yield either.fold(
      (failure) => Error(message: "Add shorten failed : $failure"),
      (result) => Loaded(shortens: null),
    );
  }
}

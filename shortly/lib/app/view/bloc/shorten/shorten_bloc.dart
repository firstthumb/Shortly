import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:shortly/app/domain/entities/shorten.dart';
import 'package:shortly/app/domain/usecases/get_shorten_list_usecase.dart';
import 'package:shortly/app/domain/usecases/usecases.dart';
import 'package:shortly/app/view/bloc/blocs.dart';
import 'package:shortly/app/view/bloc/shorten/shorten_event.dart';
import 'package:shortly/app/view/bloc/shorten/shorten_state.dart';
import 'package:shortly/core/error/failures.dart';
import 'package:shortly/core/usecases/usecase.dart';
import 'package:shortly/core/util/logger.dart';

class ShortenBloc extends Bloc<ShortenEvent, ShortenState> {
  final logger = getLogger('ShortenBloc');

  final AddShortenUseCase addShorten;
  final GetShortenListUseCase getShortenList;

  ShortenBloc({
    @required this.addShorten,
    @required this.getShortenList,
  });

  @override
  ShortenState get initialState => Empty();

//  ShortenState get initialState => Loaded(
//      shortens: [Shorten(link: "Link", shortLink: "Short Link", fav: true)]);

  @override
  Stream<ShortenState> mapEventToState(ShortenEvent event) async* {
    logger.v("BEFORE State : $currentState, Event : $event");

    if (event is GetShortenListEvent) {
      yield Loading();
      yield* _mapGetShortenListToState(await getShortenList(NoParams()));
    } else if (event is CreateShortenEvent) {
      yield Loading();
      yield* _mapCreateShortenToState(
          await addShorten(AddShortenParam(link: event.link)));
      dispatch(GetShortenListEvent());
    }
  }

  Stream<ShortenState> _mapGetShortenListToState(Either<Failure, List<Shorten>> either) async* {
    logger.v("_mapGetShortenListToState");
    yield either.fold(
          (failure) => Error(message: "Load shorten failed : $failure"),
          (result) => Loaded(shortens: result),
    );
  }

  Stream<ShortenState> _mapCreateShortenToState(Either<Failure, Shorten> either) async* {
    logger.v("_mapCreateShortenToState");
    yield either.fold(
          (failure) => Error(message: "Create shorten failed : $failure"),
          (result) => Created(shorten: result),
    );
  }
}

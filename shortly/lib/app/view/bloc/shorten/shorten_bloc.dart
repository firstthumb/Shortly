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
  final DeleteShortenUseCase deleteShorten;
  final ToggleFavShortenUseCase toggleFavShorten;

  ShortenBloc({
    @required this.addShorten,
    @required this.getShortenList,
    @required this.deleteShorten,
    @required this.toggleFavShorten,
  });

  @override
  ShortenState get initialState => Empty();

  @override
  Stream<ShortenState> mapEventToState(ShortenEvent event) async* {
    logger.v("BEFORE State : $state, Event : $event");

    if (event is GetShortenListEvent) {
      yield Loading();
      yield* _mapGetShortenListToState(await getShortenList(NoParams()));
    } else if (event is CreateShortenEvent) {
      yield Loading();
      yield* _mapCreateShortenToState(
          await addShorten(AddShortenParam(link: event.link)));
      yield* _mapGetShortenListToState(await getShortenList(NoParams()));
    } else if (event is ToggleFavShortenEvent) {
      yield* _mapToggleFavShortenToState(
          await toggleFavShorten(ToggleFavShortenParam(id: event.id)));
    } else if (event is DeleteShortenEvent) {
      yield* _mapDeleteShortenToState(
          await deleteShorten(DeleteShortenParam(id: event.id)));
    }
  }

  Stream<ShortenState> _mapDeleteShortenToState(
      Either<Failure, String> either) async* {
    logger.v("_mapDeleteShortenToState");
    yield either.fold(
          (failure) => Error(message: "Load shorten failed : $failure"),
          (result) {
        if (state is Loaded) {
          final List<Shorten> shortens = (state as Loaded).shortens.where((
              shorten) => shorten.id != result).toList();
          return Loaded(shortens: shortens);
        }

        return Empty();
      },
    );
  }

  Stream<ShortenState> _mapGetShortenListToState(
      Either<Failure, List<Shorten>> either) async* {
    logger.v("_mapGetShortenListToState");
    yield either.fold(
          (failure) => Error(message: "Load shorten failed : $failure"),
          (result) => Loaded(shortens: result),
    );
  }

  Stream<ShortenState> _mapCreateShortenToState(
      Either<Failure, Shorten> either) async* {
    logger.v("_mapCreateShortenToState");
    yield either.fold(
          (failure) => Error(message: "Create shorten failed : $failure"),
          (result) => Created(shorten: result),
    );
  }

  Stream<ShortenState> _mapToggleFavShortenToState(
      Either<Failure, Shorten> either) async* {
    logger.v("_mapToggleFavShortenToState");
    yield either.fold(
          (failure) => Error(message: "Toggle fav shorten failed : $failure"),
          (result) {
        if (state is Loaded) {
          final List<Shorten> updatedShorten =
          (state as Loaded).shortens.map((shorten) {
            if (shorten.id == result.id) {
              return result;
            }
            return shorten;
          }).toList();

          return Loaded(shortens: updatedShorten);
        } else {
          return Loaded(shortens: []);
        }
      },
    );
  }
}

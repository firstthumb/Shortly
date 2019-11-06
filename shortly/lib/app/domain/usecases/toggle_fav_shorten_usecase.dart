import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:shortly/app/domain/entities/shorten.dart';
import 'package:shortly/app/domain/repositories/shorten_repository.dart';
import 'package:shortly/core/error/failures.dart';
import 'package:shortly/core/usecases/usecase.dart';

class ToggleFavShortenUseCase implements UseCase<Shorten, ToggleFavShortenParam> {
  final ShortenRepository repository;

  ToggleFavShortenUseCase({@required this.repository});

  @override
  Future<Either<Failure, Shorten>> call(ToggleFavShortenParam params) async {
    return await repository.toggleFavShorten(params.id);
  }
}

class ToggleFavShortenParam extends Params {
  final String id;

  ToggleFavShortenParam({
    @required this.id,
  }) : super([id]);
}

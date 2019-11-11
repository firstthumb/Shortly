import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:shortly/app/domain/entities/shorten.dart';
import 'package:shortly/app/domain/repositories/shorten_repository.dart';
import 'package:shortly/core/error/failures.dart';
import 'package:shortly/core/usecases/usecase.dart';

class SyncShortenUseCase
    implements UseCase<List<Shorten>, SyncShortenUseCaseParam> {
  final ShortenRepository repository;

  SyncShortenUseCase({@required this.repository});

  @override
  Future<Either<Failure, List<Shorten>>> call(
      SyncShortenUseCaseParam params) async {
    return await repository.syncShortens(params.userId);
  }
}

class SyncShortenUseCaseParam extends Params {
  final String userId;

  SyncShortenUseCaseParam({
    @required this.userId,
  }) : super([userId]);
}

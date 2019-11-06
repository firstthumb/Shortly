import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:shortly/app/domain/entities/shorten.dart';
import 'package:shortly/app/domain/repositories/shorten_repository.dart';
import 'package:shortly/core/error/failures.dart';
import 'package:shortly/core/usecases/usecase.dart';

class DeleteShortenUseCase implements UseCase<bool, DeleteShortenParam> {
  final ShortenRepository repository;

  DeleteShortenUseCase({@required this.repository});

  @override
  Future<Either<Failure, bool>> call(DeleteShortenParam params) async {
    return await repository.deleteShorten(params.id);
  }
}

class DeleteShortenParam extends Params {
  final String id;

  DeleteShortenParam({
    @required this.id,
  }) : super([id]);
}

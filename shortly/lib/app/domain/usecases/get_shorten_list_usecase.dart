import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:shortly/app/domain/entities/shorten.dart';
import 'package:shortly/app/domain/repositories/shorten_repository.dart';
import 'package:shortly/core/error/failures.dart';
import 'package:shortly/core/usecases/usecase.dart';

class GetShortenListUseCase implements UseCase<List<Shorten>, NoParams> {
  final ShortenRepository repository;

  GetShortenListUseCase({@required this.repository});

  @override
  Future<Either<Failure, List<Shorten>>> call(NoParams params) async {
    return await repository.getAllShortens();
  }
}

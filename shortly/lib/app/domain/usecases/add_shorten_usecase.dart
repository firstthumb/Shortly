import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:shortly/app/domain/entities/shorten.dart';
import 'package:shortly/app/domain/repositories/shorten_repository.dart';
import 'package:shortly/core/error/failures.dart';
import 'package:shortly/core/usecases/usecase.dart';

class AddShortenUseCase implements UseCase<Shorten, AddShortenParam> {
  final ShortenRepository repository;

  AddShortenUseCase({@required this.repository});

  @override
  Future<Either<Failure, Shorten>> call(AddShortenParam params) async {
    return await repository.createShorten(params.link, params.type);
  }
}

class AddShortenParam extends Params {
  final String link;
  final String type;

  AddShortenParam({
    @required this.link,
    @required this.type,
  }) : super([link, type]);
}

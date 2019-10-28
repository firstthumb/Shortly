import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:shortly/app/data/datasources/shorten_local_datasource.dart';
import 'package:shortly/app/data/models/shorten_model.dart';
import 'package:shortly/app/domain/entities/shorten.dart';
import 'package:shortly/app/domain/repositories/shorten_repository.dart';
import 'package:shortly/core/error/failures.dart';

class ShortenRepositoryImpl implements ShortenRepository {
  final ShortenLocalDataSource localDataSource;

  ShortenRepositoryImpl({
    @required this.localDataSource
  });

  @override
  Future<Either<Failure, List<Shorten>>> getAllShortens() async {
    final shortenList = await localDataSource.getShortens();
    return Right(shortenList.map((model) => model.toEntity()).toList());
  }

  @override
  Future<Either<Failure, Shorten>> saveShorten(Shorten shorten) async {
    final shortenModel = await localDataSource.saveShorten(
        ShortenModel.fromEntity(shorten));
    return Right(shortenModel.toEntity());
  }
}

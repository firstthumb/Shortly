import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:shortly/app/data/datasources/shorten_local_datasource.dart';
import 'package:shortly/app/data/datasources/shorten_remote_datasource.dart';
import 'package:shortly/app/data/models/shorten_model.dart';
import 'package:shortly/app/domain/entities/shorten.dart';
import 'package:shortly/app/domain/repositories/shorten_repository.dart';
import 'package:shortly/core/error/failures.dart';
import 'package:shortly/core/util/logger.dart';

class ShortenRepositoryImpl implements ShortenRepository {
  final logger = getLogger('ShortenRepository');

  final ShortenLocalDataSource localDataSource;
  final ShortenRemoteDataSource remoteDataSource;

  ShortenRepositoryImpl({
    @required this.localDataSource,
    @required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<Shorten>>> getAllShortens() async {
    logger.v("Getting all shortens");
    try {
      final shortenList = await localDataSource.getShortens();
      logger.v("Shortens => $shortenList");
      return Right(shortenList.map((model) => model.toEntity()).toList());
    } on Error catch (e) {
      logger.e("Could not fetch local shortens: $e");
      return Left(LocalFailure());
    }
  }

  @override
  Future<Either<Failure, Shorten>> saveShorten(Shorten shorten) async {
    final shortenModel =
    await localDataSource.saveShorten(ShortenModel.fromEntity(shorten));
    return Right(shortenModel.toEntity());
  }

  @override
  Future<Either<Failure, Shorten>> createShorten(String url) async {
    logger.v("Creating shorten => Url : $url");
    try {
      final shortenModel = await remoteDataSource.createShorten(url);
      // TODO: Silently fail on cache
      final savedShortenModel = await localDataSource.saveShorten(shortenModel);
      return Right(savedShortenModel.toEntity());
    } on Error catch (e) {
      logger.e("Failed to create: $e");
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteShorten(String id) async {
    localDataSource.deleteShorten(id);
    return Right(true);
  }

  @override
  Future<Either<Failure, Shorten>> toggleFavShorten(String id) async {
    try {
      final shorten = await localDataSource.getShorten(id);
      final savedShortenModel = await localDataSource.saveShorten(
          ShortenModel.fromEntity(Shorten(id: id,
              link: shorten.link,
              shortLink: shorten.shortLink,
              fav: !shorten.fav)));
      return Right(savedShortenModel.toEntity());
    } on Error catch (e) {
      logger.e("Could not toggle fav: $e");
      return Left(LocalFailure());
    }
  }
}

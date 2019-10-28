import 'package:dartz/dartz.dart';
import 'package:shortly/app/domain/entities/shorten.dart';
import 'package:shortly/core/error/failures.dart';

abstract class ShortenRepository {
  Future<Either<Failure, List<Shorten>>> getAllShortens();

  Future<Either<Failure, Shorten>> saveShorten(Shorten shorten);
}

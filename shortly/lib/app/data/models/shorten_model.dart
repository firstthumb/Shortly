import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

const String todoModelHiveName = "TodoModelHive";

@HiveType()
class ShortenModel extends Equatable {
  @HiveField(0)
  final String id;

  ShortenModel({
    this.id,
  }) : super([id]);
}

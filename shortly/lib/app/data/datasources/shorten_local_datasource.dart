import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:shortly/app/data/models/shorten_model.dart';

abstract class ShortenLocalDataSource {
  Future<List<ShortenModel>> getShortens();

  Future<ShortenModel> saveShorten(ShortenModel model);
}

class ShortenLocalDataSourceImpl implements ShortenLocalDataSource {
  final Box shortenBox;

  ShortenLocalDataSourceImpl({@required this.shortenBox});

  @override
  Future<List<ShortenModel>> getShortens() async {
    return shortenBox.values;
  }

  @override
  Future<ShortenModel> saveShorten(ShortenModel model) async {
    await shortenBox.put(model.id, model);
    return model;
  }
}

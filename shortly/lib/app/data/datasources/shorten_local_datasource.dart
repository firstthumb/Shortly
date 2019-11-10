import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:shortly/app/data/models/shorten_model.dart';
import 'package:shortly/core/util/logger.dart';
import 'package:uuid/uuid.dart';

abstract class ShortenLocalDataSource {
  Future<List<ShortenModel>> getShortens();

  Future<List<ShortenModel>> getFavShortens();

  Future<ShortenModel> getShorten(String id);

  Future<ShortenModel> saveShorten(ShortenModel model);

  void deleteShorten(String id);
}

class ShortenLocalDataSourceImpl implements ShortenLocalDataSource {
  final logger = getLogger('ShortenLocalDataSource');

  final Box shortenBox;

  ShortenLocalDataSourceImpl({@required this.shortenBox});

  @override
  Future<List<ShortenModel>> getShortens() async {
    final list = List<ShortenModel>();
    for (var value in shortenBox.values) {
      if (value is ShortenModel) {
        list.add(value);
      }
    }

    logger.v("Get shortens => $list");

    return list;
  }

  @override
  Future<ShortenModel> saveShorten(ShortenModel model) async {
    logger.v("Saving shorten => Model : $model");
    final id = model.id ?? Uuid().v4();
    final savedModel = ShortenModel(
      id: id,
      link: model.link,
      shortLink: model.shortLink,
      fav: model.fav,
      createdAt: DateTime.now(),
    );
    await shortenBox.put(id, savedModel);
    logger.v("Saved shorten => Model : $savedModel");
    return savedModel;
  }

  @override
  void deleteShorten(String id) {
    logger.v("Deleting shorten => Id : $id");
    shortenBox.delete(id);
  }

  @override
  Future<ShortenModel> getShorten(String id) async {
    logger.v("Get shorten => Id : $id");
    return shortenBox.get(id);
  }

  @override
  Future<List<ShortenModel>> getFavShortens() async {
    return (await getShortens()).where((shorten) => shorten.fav).toList();
  }
}

import 'dart:convert';

import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:shortly/app/data/models/shorten_model.dart';
import 'package:shortly/core/util/logger.dart';

import '../../../core/error/exceptions.dart';

const String SHORTEN_SERVICE =
    "https://us-central1-mainproject-226019.cloudfunctions.net/ShortlyService/v1/shorten";

abstract class ShortenRemoteDataSource {
  Future<ShortenModel> createShorten(String url);
}

class ShortenRemoteDataSourceImpl implements ShortenRemoteDataSource {
  final logger = getLogger('ShortenRemoteDataSource');

  final Client client;

  ShortenRemoteDataSourceImpl({@required this.client});

  @override
  Future<ShortenModel> createShorten(String url) => _createShorten(url);

  Future<ShortenModel> _createShorten(String url) async {
    final response = await client.post(
      SHORTEN_SERVICE,
      headers: {"Content-type": "application/json"},
      body: '{"link": "$url"}',
    );

    logger.v("Response : $response");

    if (response.statusCode == 200) {
      return ShortenModel.fromJson(json.decode(response.body));
    } else {
      logger.v("Response Status Code : ${response.statusCode}");
      throw ServerException();
    }
  }
}

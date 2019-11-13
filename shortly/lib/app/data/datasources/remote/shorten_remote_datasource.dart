import 'dart:convert';

import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:shortly/app/data/datasources/remote/requests/sync_request.dart';
import 'package:shortly/app/data/datasources/remote/responses/responses.dart';
import 'package:shortly/app/data/models/shorten_model.dart';
import 'package:shortly/core/util/logger.dart';

import '../../../../core/error/exceptions.dart';

const String SHORTEN_SERVICE =
    "https://us-central1-mainproject-226019.cloudfunctions.net/ShortlyService/v1";

abstract class ShortenRemoteDataSource {
  Future<ShortenModel> createShorten(String url);

  Future<List<ShortenModel>> syncShortens(String userId,
      List<ShortenModel> shortens, List<String> deleted);

  Future<List<ShortenModel>> getSyncShortens(String userId);
}

class ShortenRemoteDataSourceImpl implements ShortenRemoteDataSource {
  final logger = getLogger('ShortenRemoteDataSource');

  final Client client;

  ShortenRemoteDataSourceImpl({@required this.client});

  @override
  Future<ShortenModel> createShorten(String url) async {
    final response = await client.post(
      SHORTEN_SERVICE + "/shorten",
      headers: {"Content-type": "application/json"},
      body: '{"link": "$url"}',
    );

    logger.v("Response : $response");

    if (response.statusCode == 200) {
      return ShortenModel.fromJson(json.decode(response.body));
    } else {
      logger.v("Response Status Code : ${response.statusCode}");
      final errorResponse = ErrorResponse.fromJson(jsonDecode(response.body));
      logger.e("Error Response : $errorResponse");
      throw ServerException();
    }
  }

  @override
  Future<List<ShortenModel>> syncShortens(String userId,
      List<ShortenModel> shortens, List<String> deleted) async {
    logger.v("Syncing => UserId : $userId");

    final request = SyncRequest(shortens: shortens, deleted: deleted);
    final payload = jsonEncode(request);
    logger.v("Payload => $payload");

    final response = await client.post(
      SHORTEN_SERVICE + "/sync/$userId",
      headers: {"Content-type": "application/json"},
      body: payload,
    );

    logger.v("Response : ${response.body}");

    if (response.statusCode == 200) {
      return SyncResponse
          .fromJson(jsonDecode(response.body))
          .shortens;
    } else {
      logger.e("Response Status Code : ${response.statusCode}");
      final errorResponse = ErrorResponse.fromJson(jsonDecode(response.body));
      logger.e("Error Response : $errorResponse");
      throw ServerException();
    }
  }

  @override
  Future<List<ShortenModel>> getSyncShortens(String userId) async {
    final response = await client.get(
      SHORTEN_SERVICE + "/sync/$userId",
      headers: {"Content-type": "application/json"},
    );

    logger.v("Response : ${response.body}");

    if (response.statusCode == 200) {
      return SyncResponse
          .fromJson(jsonDecode(response.body))
          .shortens;
    } else {
      logger.v("Response Status Code : ${response.statusCode}");
      final errorResponse = ErrorResponse.fromJson(jsonDecode(response.body));
      logger.e("Error Response : $errorResponse");
      throw ServerException();
    }
  }
}

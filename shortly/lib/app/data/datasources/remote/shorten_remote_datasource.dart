import 'dart:convert';

import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:shortly/app/data/datasources/remote/requests/requests.dart';
import 'package:shortly/app/data/datasources/remote/requests/sync_request.dart';
import 'package:shortly/app/data/datasources/remote/responses/responses.dart';
import 'package:shortly/app/data/datasources/remote/responses/shorten_response.dart';
import 'package:shortly/app/data/models/shorten_model.dart';
import 'package:shortly/core/util/logger.dart';

import '../../../../core/error/exceptions.dart';

const String SHORTEN_SERVICE =
    "https://us-central1-mainproject-226019.cloudfunctions.net/ShortlyService/v1";

abstract class ShortenRemoteDataSource {
  Future<ShortenModel> createShorten(String url, String type);

  Future<List<ShortenModel>> syncShortens(String userId, String email,
      String name,
      List<ShortenModel> shortens, List<String> deleted);

  Future<List<ShortenModel>> getSyncShortens(String userId);
}

class ShortenRemoteDataSourceImpl implements ShortenRemoteDataSource {
  final logger = getLogger('ShortenRemoteDataSource');

  final Client client;

  ShortenRemoteDataSourceImpl({@required this.client});

  @override
  Future<ShortenModel> createShorten(String url, String type) async {
    final request = ShortenRequest(link: url, type: type);
    final payload = jsonEncode(request);
    logger.v("Payload => $payload");

    final response = await client.post(
      SHORTEN_SERVICE + "/shorten",
      headers: {"Content-type": "application/json"},
      body: payload,
    );

    logger.v("Response : $response");

    if (response.statusCode == 200) {
      final shortenResponse = ShortenResponse.fromJson(
          jsonDecode(response.body));
      return ShortenModel(link: shortenResponse.url,
          shortLink: shortenResponse.shortUrl,
          createdAt: DateTime.now().toUtc(),
          fav: false);
    } else {
      logger.v("Response Status Code : ${response.statusCode}");
      final errorResponse = ErrorResponse.fromJson(jsonDecode(response.body));
      logger.e("Error Response : $errorResponse");
      throw ServerException();
    }
  }

  @override
  Future<List<ShortenModel>> syncShortens(String userId, String email,
      String name,
      List<ShortenModel> shortens, List<String> deleted) async {
    logger.v("Syncing => UserId : $userId");

    final request = SyncRequest(
        shortens: shortens, deleted: deleted, email: email, name: name);
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

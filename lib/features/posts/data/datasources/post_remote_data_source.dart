import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getPosts({required int start, required int limit});
  Future<PostModel> getPostById(int id);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final http.Client client;
  PostRemoteDataSourceImpl(this.client);

  /// json-server style pagination: GET /posts?_start=0&_limit=15
  /// (same API as `?_page=&_limit=`, but lets us load 15 first and 10 per page).
  @override
  Future<List<PostModel>> getPosts({
    required int start,
    required int limit,
  }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.postsEndpoint}')
        .replace(queryParameters: {'_start': '$start', '_limit': '$limit'});

    final response = await _get(uri);
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PostModel> getPostById(int id) async {
    final uri =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.postsEndpoint}/$id');
    final response = await _get(uri);
    return PostModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<http.Response> _get(Uri uri) async {
    try {
      final response = await client
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(ApiConstants.timeout);
      if (response.statusCode != 200) {
        throw ServerException(statusCode: response.statusCode);
      }
      return response;
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const NetworkException();
    } on http.ClientException {
      throw const NetworkException();
    }
  }
}

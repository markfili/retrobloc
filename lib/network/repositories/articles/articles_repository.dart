import 'dart:core';

import 'package:dio/dio.dart';
import 'package:retrobloc/models/article.dart';
import 'package:retrobloc/network/api_client.dart';

import '../../api_result.dart';

class ArticlesRepository {
  final ApiClient client;

  ArticlesRepository({required this.client});

  Future<ApiResult<List<Article>>> getArticles() async {
    try {
      var articles = await client.getArticles();
      return ApiResult<List<Article>>(data:articles);
    } on DioError catch (e) {
      throw ApiError(error: e);
    }
  }
}

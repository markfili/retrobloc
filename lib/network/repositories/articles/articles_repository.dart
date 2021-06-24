import 'dart:core';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrobloc/models/article.dart';
import 'package:retrobloc/network/api_client.dart';

import '../../api_result.dart';

@injectable
class ArticlesRepository {
  late final ApiClient client;

  ArticlesRepository(this.client);

  Future<ApiResult<List<Article>>> getArticles() async {
    try {
      var articles = await client.getArticles();
      return ApiResult<List<Article>>(data: articles);
    } on DioError catch (e) {
      throw ApiError(error: e);
    }
  }
}

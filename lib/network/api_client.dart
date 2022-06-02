import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrobloc/models/article.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flutter/foundation.dart';

part 'api_client.g.dart';

@injectable
@RestApi(parser: Parser.FlutterCompute)
abstract class ApiClient {
  @factoryMethod
  factory ApiClient(Dio dio, {@Named("baseUrl") String baseUrl}) = _ApiClient;

  @GET("/articles")
  Future<List<Article>> getArticles();
}

Article deserializeArticle(Map<String, dynamic> json) => Article.fromJson(json);

List<Article> deserializeArticleList(List<Map<String, dynamic>> json) => json.map(deserializeArticle).toList();

Map<String, dynamic> serializeArticle(Article object) => object.toJson();

List<Map<String, dynamic>> serializeArticleList(List<Article> objects) => objects.map(serializeArticle).toList();

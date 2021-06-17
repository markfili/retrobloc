import 'package:dio/dio.dart';
import 'package:retrobloc/models/article.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: "https://60cb5abe21337e0017e448a4.mockapi.io")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET("/articles")
  Future<List<Article>> getArticles();
}

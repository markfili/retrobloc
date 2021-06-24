import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrobloc/models/article.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

@injectable
@RestApi()
abstract class ApiClient {
  @factoryMethod
  factory ApiClient(Dio dio, {@Named("baseUrl") String baseUrl}) = _ApiClient;

  @GET("/articles")
  Future<List<Article>> getArticles();
}

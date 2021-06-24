import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@module
abstract class NetworkModule {
  @Named("baseUrl")
  String baseUrl() => "https://60cb5abe21337e0017e448a4.mockapi.io";

  @lazySingleton
  Dio dio() {
    var dio = Dio();
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: false,
    ));
    return dio;
  }
}

@module
abstract class LoggerModule {

  @singleton
  Logger logger() => Logger();
}
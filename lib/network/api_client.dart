import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: "https://60cb5abe21337e0017e448a4.mockapi.io")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET("/articles")
  Future<List<Article>> getArticles();
}

@JsonSerializable()
@immutable
class Article extends Equatable {
  final String id;
  final String author;
  final String image;
  final String title;
  final String createdAt;

  Article({
    required this.id,
    required this.author,
    required this.image,
    required this.title,
    required this.createdAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleToJson(this);

  @override
  List<Object?> get props => [id, author, image, title, createdAt];
}

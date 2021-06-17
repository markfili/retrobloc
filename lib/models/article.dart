import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'article.g.dart';

@immutable
@JsonSerializable()
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

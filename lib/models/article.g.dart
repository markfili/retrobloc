// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Article _$ArticleFromJson(Map<String, dynamic> json) {
  return Article(
    id: json['id'] as String,
    author: json['author'] as String,
    image: json['image'] as String,
    title: json['title'] as String,
    createdAt: json['createdAt'] as String,
  );
}

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'image': instance.image,
      'title': instance.title,
      'createdAt': instance.createdAt,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'articles_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticlesLoading _$ArticlesLoadingFromJson(Map<String, dynamic> json) =>
    ArticlesLoading();

Map<String, dynamic> _$ArticlesLoadingToJson(ArticlesLoading instance) =>
    <String, dynamic>{};

ArticlesSuccess _$ArticlesSuccessFromJson(Map<String, dynamic> json) =>
    ArticlesSuccess(
      articles: (json['articles'] as List<dynamic>)
          .map((e) => Article.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ArticlesSuccessToJson(ArticlesSuccess instance) =>
    <String, dynamic>{
      'articles': instance.articles,
    };

ArticlesFailure _$ArticlesFailureFromJson(Map<String, dynamic> json) =>
    ArticlesFailure(
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$ArticlesFailureToJson(ArticlesFailure instance) =>
    <String, dynamic>{
      'errorMessage': instance.errorMessage,
    };

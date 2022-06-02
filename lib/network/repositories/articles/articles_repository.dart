import 'dart:core';

import 'package:dio/dio.dart';
import 'package:retrobloc/models/article.dart';
import 'package:retrobloc/network/api_client.dart';

import '../../../utils/logging.dart';
import '../../api_result.dart';

class ArticlesRepository {
  final ApiClient client;
  final Favorites favorites = Favorites();

  ArticlesRepository({required this.client});

  Future<List<Article>> getArticles() async {
    try {
      var articles = await client.getArticles();
      favorites.checkForFavorites(articles);
      logger.i("Received ${articles.length} articles, ${articles.where((e) => e.isFavorited).length} favorited");
      return articles;
    } on DioError catch (e) {
      throw ApiError(error: e);
    }
  }

  Article saveArticleFavoriteState(List<Article> articles, String articleId) {
    var article = articles.singleWhere((article) => article.id == articleId);
    article.favorited = favorites.toggleArticleFavoriteState(article);
    favorites.checkForFavorites(articles);
    return article;
  }
}

class Favorites {
  final Set<String> favoriteIds = Set<String>();

  /// adds or removes article from favorites
  /// returns if article is in favorites
  bool toggleArticleFavoriteState(Article article) {
    if (!favoriteIds.remove(article.id)) {
      favoriteIds.add(article.id);
    }
    return favoriteIds.contains(article.id);
  }

  void checkForFavorites(List<Article> data) {
    data.forEach((element) => element.favorite = favoriteIds.contains(element.id));
  }
}

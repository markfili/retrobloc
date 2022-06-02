import 'package:flutter_test/flutter_test.dart';
import 'package:retrobloc/models/article.dart';
import 'package:retrobloc/network/repositories/articles/articles_repository.dart';

void main() {
  group("Test favorites", () {
    var articles = [
      Article.fromJson({
        "id": "test_1",
        "author": "test",
        'image': 'test_image',
        'title': 'test_title',
        'createdAt': DateTime.now().toString(),
      })
    ];
    var favorites = Favorites();
    test("Test adding to favorites", () {
      articles.first.favorited = favorites.toggleArticleFavoriteState(articles.first);
      expect(articles.first.isFavorited, true);
    });

    test("Test favorites array single", () {
      favorites.checkForFavorites(articles);
      expect(articles.where((element) => element.isFavorited).length, 1);
    });

    test("Test removing from favorites", () {
      articles.first.favorited = favorites.toggleArticleFavoriteState(articles.first);
      expect(articles.first.isFavorited, false);
    });

    test("Test favorites array empty", () {
      favorites.checkForFavorites(articles);
      expect(articles.where((element) => element.isFavorited).length, 0);
    });
  });
}

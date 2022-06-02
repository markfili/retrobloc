import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:retrobloc/models/article.dart';
import 'package:retrobloc/network/api_result.dart';
import 'package:retrobloc/network/repositories/articles/articles_repository.dart';
import 'package:retrobloc/utils/logging.dart';

part 'articles_event.dart';

part 'articles_state.dart';

class ArticlesBloc extends HydratedBloc<ArticlesEvent, ArticlesState> {
  final ArticlesRepository repository;

  ArticlesBloc({required this.repository}) : super(InitialArticlesState()) {
    on<LoadArticles>(_mapLoadArticlesToState);
    on<RefreshArticles>(_mapRefreshArticlesToState);
    on<ArticleFavorited>(_mapFavoritedArticleToState);
    if (state is InitialArticlesState) {
      add(LoadArticles());
    }
  }

  void _mapLoadArticlesToState(LoadArticles event, Emitter<ArticlesState> emit) async {
    try {
      emit(ArticlesLoading());
      var articles = await repository.getArticles();
      emit(ArticlesSuccess(articles: articles));
    } on ApiError catch (e) {
      emit(ArticlesFailure(errorMessage: e.errorMessage));
    }
  }

  void _mapRefreshArticlesToState(RefreshArticles event, Emitter<ArticlesState> emit) async {
    try {
      emit(ArticlesRefreshing(
          articles: (state is ArticlesSuccess) ? (state as ArticlesSuccess).articles : List.empty()));
      var articles = await repository.getArticles();
      emit(ArticlesSuccess(articles: articles));
    } on ApiError catch (_) {
      emit(state);
    }
  }

  void _mapFavoritedArticleToState(ArticleFavorited event, Emitter<ArticlesState> emit) async {
    if (state is ArticlesSuccess) {
      var articles = (state as ArticlesSuccess).articles;
      var article = repository.saveArticleFavoriteState(articles, event.article.id);
      logger.i("Article ${event.article.id} favorited: ${article.isFavorited}");
      emit(ArticlesSuccess(
        articles: articles,
        favoritedArticleId: article.id,
        isFavorited: article.isFavorited,
      ));
    }
  }

  @override
  ArticlesState? fromJson(Map<String, dynamic> json) {
    logger.i("Retrieving data from storage!");
    try {
      return ArticlesSuccess(articles: (json["articles"] as List).map((value) => Article.fromJson(value)).toList());
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(ArticlesState state) {
    if (state is ArticlesSuccess) {
      return {"articles": state.articles.map((e) => e.toJson()).toList()};
    }
    return null;
  }
}

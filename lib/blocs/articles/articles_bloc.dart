import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:retrobloc/models/article.dart';
import 'package:retrobloc/network/api_result.dart';
import 'package:retrobloc/network/repositories/articles/articles_repository.dart';
import 'package:retrobloc/utils/logging.dart';

part 'articles_bloc.g.dart';
part 'articles_event.dart';
part 'articles_state.dart';

class ArticlesBloc extends HydratedBloc<ArticlesEvent, ArticlesState> {
  final ArticlesRepository repository;

  ArticlesBloc({required this.repository}) : super(ArticlesLoading()) {
    on<LoadArticles>(_mapLoadArticlesToState);
    on<RefreshArticles>(_mapRefreshArticlesToState);
  }

  void _mapLoadArticlesToState(LoadArticles event, Emitter<ArticlesState> emit) async {
    try {
      emit(ArticlesLoading());
      var result = await repository.getArticles();
      logger.i("Received ${result.data!.length} articles!");
      emit(ArticlesSuccess(articles: result.data!));
    } on ApiError catch (e) {
      emit(ArticlesFailure(errorMessage: e.errorMessage));
    }
  }

  void _mapRefreshArticlesToState(RefreshArticles event, Emitter<ArticlesState> emit) async {
    try {
      var result = await repository.getArticles();
      logger.i("Received ${result.data!.length} articles!");
      emit(ArticlesLoading()); // FIXME hack to emit exact same state with equal data
      emit(ArticlesSuccess(articles: result.data!));
    } on ApiError catch (_) {
      emit(state);
    }
  }

  @override
  ArticlesState? fromJson(Map<String, dynamic> json) {
    logger.i("Reading state from storage");
    logger.i(json);
    if (json["state"] == "success") {
      return ArticlesSuccess(articles: (json["articles"] as List).map((e) => Article.fromJson(e)).toList());
    }
    if (json["state"] == "failure") {
      return ArticlesFailure(errorMessage: json["message"] as String);
    }
    return ArticlesLoading();
  }

  @override
  Map<String, dynamic>? toJson(ArticlesState state) {
    if (state is ArticlesSuccess) {
      return {"state": "success", "articles": state.articles.map((e) => e.toJson()).toList()};
    }
    if (state is ArticlesFailure) {
      return {"state": "failure", "message": state.errorMessage};
    }
    return {"state": "loading"};
  }
}

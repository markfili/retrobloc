import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:retrobloc/models/article.dart';
import 'package:retrobloc/network/api_result.dart';
import 'package:retrobloc/network/repositories/articles/articles_repository.dart';
import 'package:retrobloc/utils/logging.dart';

part 'articles_event.dart';
part 'articles_state.dart';

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
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
}

part of 'articles_bloc.dart';

@immutable
abstract class ArticlesState extends Equatable with SealedArticlesStates {
  const ArticlesState();

  @override
  List<Object?> get props => [];
}

class InitialArticlesState extends ArticlesState {}

class ArticlesLoading extends ArticlesState {}

class ArticlesRefreshing extends ArticlesState {
  final List<Article> articles;

  const ArticlesRefreshing({required this.articles});

  @override
  List<Object?> get props => [articles];
}

class ArticlesSuccess extends ArticlesState {
  final List<Article> articles;
  final String? favoritedArticleId;
  final bool? isFavorited;

  const ArticlesSuccess({required this.articles, this.favoritedArticleId, this.isFavorited});

  @override
  List<Object?> get props => [articles, favoritedArticleId, isFavorited];
}

class ArticlesFailure extends ArticlesState {
  final String? errorMessage;

  ArticlesFailure({this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

/// Extension helper class to handle states in views.
///
/// Can be more generic for broader use, this is just an example and it should be created using the freezed package.
abstract class SealedArticlesStates<T> {
  R when<R>({
    required R Function(List<Article>) success,
    required R Function(String?) error,
    required R Function() loading,
  }) {
    if (this is ArticlesSuccess) {
      return success.call((this as ArticlesSuccess).articles);
    }
    if (this is ArticlesFailure) {
      return error.call(((this as ArticlesFailure).errorMessage));
    }
    if (this is InitialArticlesState || this is ArticlesLoading) {
      return loading.call();
    }
    if (this is ArticlesRefreshing) {
      return success.call((this as ArticlesRefreshing).articles);
    }
    throw new Exception('If you got here, there are probably no more states handled in SealedArticlesStates class');
  }
}

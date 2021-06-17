part of 'articles_bloc.dart';

@immutable
abstract class ArticlesState extends Equatable {
  const ArticlesState();

  @override
  List<Object?> get props => [];
}

class InitialArticlesState extends ArticlesState {}

class ArticlesLoading extends ArticlesState {}

class ArticlesSuccess extends ArticlesState {
  final List<Article> articles;

  const ArticlesSuccess({required this.articles});

  @override
  List<Object?> get props => [articles];
}

class ArticlesFailure extends ArticlesState {}

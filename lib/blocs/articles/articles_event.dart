part of 'articles_bloc.dart';

@immutable
abstract class ArticlesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadArticles extends ArticlesEvent {}

class RefreshArticles extends ArticlesEvent {}


class ArticleFavorited extends ArticlesEvent {
  final Article article;

  ArticleFavorited({required this.article});

  @override
  List<Object?> get props => [article];
}
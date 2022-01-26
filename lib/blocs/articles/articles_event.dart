part of 'articles_bloc.dart';

@immutable
abstract class ArticlesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadArticles extends ArticlesEvent {}

class RefreshArticles extends ArticlesEvent {}

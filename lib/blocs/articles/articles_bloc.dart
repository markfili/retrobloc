import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:retrobloc/models/article.dart';
import 'package:retrobloc/network/api_client.dart';

part 'articles_event.dart';

part 'articles_state.dart';

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  final ApiClient client;

  ArticlesBloc({required this.client}) : super(InitialArticlesState());

  @override
  Stream<ArticlesState> mapEventToState(ArticlesEvent event) async* {
    if (event is LoadArticles) {
      yield* _mapLoadArticlesToState();
    }
  }

  Stream<ArticlesState> _mapLoadArticlesToState() async* {
    try {
      yield ArticlesLoading();
      var articles = await client.getArticles();
      yield ArticlesSuccess(articles: articles);
    } catch (_) {
      yield ArticlesFailure();
    }
  }
}

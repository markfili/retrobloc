import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:retrobloc/models/article.dart';
import 'package:retrobloc/network/api_result.dart';
import 'package:retrobloc/network/repositories/articles/articles_repository.dart';

part 'articles_event.dart';
part 'articles_state.dart';

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  final ArticlesRepository repository;

  ArticlesBloc({required this.repository}) : super(InitialArticlesState());

  @override
  Stream<ArticlesState> mapEventToState(ArticlesEvent event) async* {
    if (event is LoadArticles) {
      yield* _mapLoadArticlesToState();
    }
  }

  Stream<ArticlesState> _mapLoadArticlesToState() async* {
    try {
      yield ArticlesLoading();
      var result = await repository.getArticles();
      // here you handle a successful response and state of returned data
      if (result.data!.isNotEmpty) {
        yield ArticlesSuccess(articles: result.data!);
      } else {
        yield ArticlesFailure(errorMessage: "Currently there are no articles to read! Try again later");
      }
    } on ApiError catch (e) {
      // here you would intercept the error and send an appropriate message/response if there was a logic error
      // otherwise pass generic messages for certain I/O errors
      yield ArticlesFailure(errorMessage: e.errorMessage);
    }
  }
}

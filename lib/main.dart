import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:path_provider/path_provider.dart';
import 'package:retrobloc/network/api_client.dart';
import 'package:retrobloc/network/repositories/articles/articles_repository.dart';
import 'package:retrobloc/utils/logging.dart';

import 'blocs/articles/articles_bloc.dart';
import 'di/injector.dart';
import 'models/article.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// This value defaults to true in debug mode and false in release mode.
  /// Seems it's not necessary to set it unless wanted in release mode
  EquatableConfig.stringify = kDebugMode;
  configureDependencies();
  final storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  HydratedBlocOverrides.runZoned(
    () => runApp(MyApp()),
    blocObserver: SimpleBlocObserver(),
    storage: storage,
  );
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    logger.i("$bloc $transition");
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Network Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RepositoryProvider<ArticlesRepository>(
        create: (_) => ArticlesRepository(client: getIt.get<ApiClient>()),
        child: BlocProvider<ArticlesBloc>(
          create: (context) => ArticlesBloc(repository: context.read<ArticlesRepository>()),
          child: MyHomePage(title: 'Flutter Network Demo'),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Builder(
        builder: (context) {
          return LiquidPullToRefresh(
            showChildOpacityTransition: false,
            onRefresh: _reloadArticles,
            child: BlocBuilder<ArticlesBloc, ArticlesState>(
              builder: (context, state) {
                return state.when(
                    success: (articles) {
                      return ListView.builder(
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          var article = articles[index];
                          return ListTile(
                            leading: CircleAvatar(foregroundImage: NetworkImage(article.image)),
                            title: Text(article.title),
                            subtitle: Text("${article.createdAt} * ${article.author}"),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ArticleScreen(
                                    article: article,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    error: (errorMessage) {
                      return CustomScrollView(
                        slivers: [
                          SliverFillRemaining(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(errorMessage ?? "It seems you won't be reading any articles today!"),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                    loading: () => Center(child: LinearProgressIndicator(minHeight: 10)));
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _reloadArticles() async {
    var articlesBloc = context.read<ArticlesBloc>();
    articlesBloc.add(RefreshArticles());
    await articlesBloc.stream.first;
  }
}

class ArticleScreen extends StatelessWidget {
  final Article article;

  const ArticleScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: Column(
        children: [
          Image.network(article.image),
          Text(article.author),
          Text(article.createdAt),
        ],
      ),
    );
  }
}

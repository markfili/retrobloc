import 'package:cached_network_image/cached_network_image.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:path_provider/path_provider.dart';
import 'package:retrobloc/network/api_client.dart';
import 'package:retrobloc/network/repositories/articles/articles_repository.dart';
import 'package:retrobloc/utils/datetime_formatter.dart';
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
    return RepositoryProvider<ArticlesRepository>(
      create: (_) => ArticlesRepository(client: getIt.get<ApiClient>()),
      child: BlocProvider<ArticlesBloc>(
        create: (context) => ArticlesBloc(repository: context.read<ArticlesRepository>()),
        child: MaterialApp(
          title: 'Flutter Network Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          restorationScopeId: 'news-app',
          home: MyHomePage(title: '"Articles"🧭 🏳️\u200d🌈🧋🧉'),
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

class _MyHomePageState extends State<MyHomePage> with RestorationMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      restorationId: 'scaffold',
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
                        restorationId: 'list',
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          var article = articles[index];
                          return Card(
                            child: ListTile(
                              leading: Hero(
                                tag: "article-avatar-${article.id}",
                                child: CircleAvatar(foregroundImage: CachedNetworkImageProvider(article.image)),
                              ),
                              title: Text(article.title),
                              subtitle: Text(
                                "${DateTimeFormatter.toHumanFormat(article.createdAt)} • ${article.author}",
                                style: TextStyle(fontSize: 12),
                              ),
                              trailing: IconButton(splashRadius: 20,
                                onPressed: () => context.read<ArticlesBloc>().add(
                                      ArticleFavorited(article: article),
                                    ),
                                icon: Icon(
                                  article.isFavorited ? Icons.favorite : Icons.favorite_border,
                                  color: article.isFavorited ? Colors.red : Colors.blueGrey,
                                ),
                              ),
                              onTap: () => Navigator.restorablePush<Article>(
                                context,
                                buildMaterialPageRoute,
                                arguments: article.toJson(),
                              ),
                            ),
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

  static Route<Article> buildMaterialPageRoute(BuildContext context, Object? object) {
    if (object != null && object is Map) {
      return MaterialPageRoute(
        builder: (_) => ArticleScreen(
          article: Article.fromJson(
            (Map<String, dynamic>.from(object)),
          ),
        ),
      );
    }
    return MaterialPageRoute(
      builder: (_) => Container(
        color: Colors.black,
      ),
    );
  }

  Future<void> _reloadArticles() async {
    var articlesBloc = context.read<ArticlesBloc>();
    articlesBloc.add(RefreshArticles());
    await articlesBloc.stream.firstWhere((element) => !(element is ArticlesRefreshing));
  }

  @override
  String? get restorationId => 'articles-list';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {}
}

class ArticleScreen extends StatelessWidget {
  final Article article;

  const ArticleScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
        actions: [
          IconButton(
            onPressed: () => context.read<ArticlesBloc>().add(ArticleFavorited(article: article)),
            icon: Icon(
                _isFavorited(article, context.watch<ArticlesBloc>().state) ? Icons.favorite : Icons.favorite_border),
          ),
        ],
      ),
      body: Column(
        children: [
          Hero(
            tag: "article-avatar-${article.id}",
            child: Image.network(article.image),
          ),
          Text(article.author),
          Text(article.createdAt),
        ],
      ),
    );
  }

  _isFavorited(Article article, ArticlesState state) {
    if (state is ArticlesSuccess) {
      article.favorite = state.isFavorited ?? article.isFavorited;
    }
    return article.isFavorited;
  }
}

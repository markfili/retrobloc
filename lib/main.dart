import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrobloc/network/repositories/articles/articles_repository.dart';

import 'blocs/articles/articles_bloc.dart';
import 'models/article.dart';
import 'network/api_client.dart';

void main() {
  /// This value defaults to true in debug mode and false in release mode.
  /// Seems it's not necessary to set it unless wanted in release mode
  EquatableConfig.stringify = kDebugMode;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Network Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Network Demo'),
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
  final logger = Logger();
  late final ApiClient _apiClient;

  @override
  void initState() {
    super.initState();
    var dio = Dio();
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: false,
    ));
    // play with timeout values to simulate TimeoutException
    //    dio.options.connectTimeout = 10;
    //    dio.options.receiveTimeout = 10;
    _apiClient = ApiClient(dio);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RepositoryProvider<ArticlesRepository>(
        create: (_) => ArticlesRepository(client: _apiClient),
        child: BlocProvider<ArticlesBloc>(
          create: (context) => ArticlesBloc(repository: context.read<ArticlesRepository>())..add(LoadArticles()),
          child: Builder(
            builder: (context) {
              return LiquidPullToRefresh(
                showChildOpacityTransition: false,
                onRefresh: () => _reloadArticles(context),
                child: BlocBuilder<ArticlesBloc, ArticlesState>(
                  builder: (context, state) {
                    return state.when(
                        success: (articles) {
                          logger.i("Received ${articles.length} articles!");
                          return ListView.builder(
                            itemCount: articles.length,
                            itemBuilder: (context, index) {
                              var article = articles[index];
                              return ListTile(
                                leading: CircleAvatar(foregroundImage: NetworkImage(article.image)),
                                title: Text(article.title),
                                subtitle: Text("${article.createdAt} * ${article.author}"),
                                onTap: () => _showSnackBar(article, context),
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
        ),
      ),
    );
  }

  Future<void> _reloadArticles(BuildContext context) async {
    context.read<ArticlesBloc>().add(LoadArticles());
  }

  void _showSnackBar(Article article, BuildContext context) {
    Flushbar(
      title: "Hey Ninja",
      titleColor: Colors.white,
      message: "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundColor: Colors.red,
      boxShadows: [BoxShadow(color: Colors.blue, offset: Offset(0.0, 2.0), blurRadius: 3.0)],
      backgroundGradient: LinearGradient(colors: [Colors.blueGrey, Colors.black]),
      isDismissible: false,
      duration: Duration(seconds: 4),
      icon: Icon(
        Icons.check,
        color: Colors.greenAccent,
      ),
      mainButton: TextButton(
        onPressed: () {},
        child: Text(
          "CLAP",
          style: TextStyle(color: Colors.amber),
        ),
      ),
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: Colors.blueGrey,
      titleText: Text(
        "${article.title}, ID: ${article.id}",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.yellow[600], fontFamily: "ShadowsIntoLightTwo"),
      ),
      messageText: Text(
        "Usually this would show the article's content, but right now it's just a wacky Snackbar!",
        style: TextStyle(fontSize: 18.0, color: Colors.green, fontFamily: "ShadowsIntoLightTwo"),
      ),
    )..show(context);
  }
}

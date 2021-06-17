import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

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
  late Future<List<Article>> _articles;

  @override
  void initState() {
    super.initState();
    var dio = Dio();
    _apiClient = ApiClient(dio);
    _reloadArticles();
  }

  Future<void> _reloadArticles() async {
    _articles = _apiClient.getArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: _reloadArticles,
        child: Center(
          child: FutureBuilder<List<Article>>(
            future: _articles,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return LinearProgressIndicator(
                  minHeight: 10,
                );
              }
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text("It seems you won't be reading articles today!");
              }
              var articles = snapshot.data!;
              logger.i("Received ${articles.length} articles!");
              return ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  var article = articles[index];
                  return ListTile(
                    leading: CircleAvatar(
                      foregroundImage: NetworkImage(article.image),
                    ),
                    title: Text(article.title),
                    subtitle: Text("${article.createdAt} * ${article.author}"),
                    onTap: () => _showSnackBar(article, context),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
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
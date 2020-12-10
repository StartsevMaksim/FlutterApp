import 'dart:async';
import 'dart:convert';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


Future<Album> fetchAlbumUS() async {
  final response =
  await http.get('http://newsapi.org/v2/top-headlines?' +
      'country=us&'+
      'apiKey=714721d5e0e0444f98f8f487617edf61');
  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

Future<Album> fetchAlbumRU() async {
  final response =
  await http.get('http://newsapi.org/v2/top-headlines?' +
      'country=ru&' +
      'apiKey=714721d5e0e0444f98f8f487617edf61');
  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

Future<Album> fetchAlbumGB() async {
  final response =
  await http.get('http://newsapi.org/v2/top-headlines?' +
      'country=gb&' +
      'apiKey=714721d5e0e0444f98f8f487617edf61');
  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class Album {
  final String status;
  final int totalResults;
  final List<Article> articles;

  Album({this.status, this.totalResults, this.articles});

  factory Album.fromJson(Map<String, dynamic> json) {
    List<dynamic> result = json['articles'];
    List<Article> art = new List();
    for (int i=0; i<result.length; i++){
      art.add(Article(author: result[i]['author'], title: result[i]['title'], description: result[i]['description'],
        url: result[i]['url'], urlToImage: result[i]['urlToImage'], publishedAt: DateTime.parse(result[i]['publishedAt']), content: result[i]['content']));
    }
    return Album(
      status: json['status'],
      totalResults: json['totalResults'],
      articles: art
    );
  }
}

class Article {
  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  DateTime publishedAt;
  String content;

  Article({this.author, this.title, this.description, this.url, this.urlToImage, this.publishedAt, this.content});
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Album> futureAlbumUS;
  Future<Album> futureAlbumRU;
  Future<Album> futureAlbumGB;

  @override
  void initState() {
    super.initState();
    futureAlbumUS = fetchAlbumUS();
    futureAlbumRU = fetchAlbumRU();
    futureAlbumGB = fetchAlbumGB();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Feed',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                tabs: [
                  Tab(text: "USA"),
                  Tab(text: "RUSSIA"),
                  Tab(text: "UK"),
                ],
              ),
            title: Text('News Feed'),
            ),
            body: TabBarView(
            children: [
              FutureBuilder<Album>(
              future: futureAlbumUS,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Article> resultArticles=new List();
                  for (int i=0; i<snapshot.data.articles.length; i++){
                    if ((snapshot.data.articles[i].urlToImage != null)&&(snapshot.data.articles[i].url != null)&&(snapshot.data.articles[i].author != null)&&
                        (snapshot.data.articles[i].description != null)){
                      resultArticles.add(snapshot.data.articles[i]);
                    }
                  }
                  return ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.black,
                      ),
                      padding: const EdgeInsets.all(8),
                      itemCount: resultArticles.length,
                      itemBuilder: (BuildContext context, int index){
                        return Column(
                          children: [
                            Image.network(resultArticles[index].urlToImage),
                            Text(resultArticles[index].title),
                            Container(
                              margin: EdgeInsets.only(top:30, bottom: 15),
                              height: 50,
                              width: 200,
                              color: Colors.cyan,
                              alignment: Alignment.center,
                              child: ListTile(title: Text("More", style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center),
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context)=>detailedInformation(), settings: RouteSettings(arguments: resultArticles[index]))
                                    );
                                  }),
                            )
                          ],
                        );
                      }
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
                },
              ),
              FutureBuilder<Album>(
                future: futureAlbumRU,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Article> resultArticles=new List();
                    for (int i=0; i<snapshot.data.articles.length; i++){
                      if ((snapshot.data.articles[i].urlToImage != null)&&(snapshot.data.articles[i].url != null)&&(snapshot.data.articles[i].author != null)&&
                          (snapshot.data.articles[i].description != null)){
                        resultArticles.add(snapshot.data.articles[i]);
                      }
                    }
                    return ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.black,
                        ),
                        padding: const EdgeInsets.all(8),
                        itemCount: resultArticles.length,
                        itemBuilder: (BuildContext context, int index){
                          return Column(
                            children: [
                              Image.network(resultArticles[index].urlToImage),
                              Text(resultArticles[index].title),
                              Container(
                                margin: EdgeInsets.only(top:30, bottom: 15),
                                height: 50,
                                width: 200,
                                color: Colors.cyan,
                                alignment: Alignment.center,
                                child: ListTile(title: Text("More", style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center),
                                    onTap: (){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context)=>detailedInformation(), settings: RouteSettings(arguments: resultArticles[index]))
                                      );
                                    }),
                              )
                            ],
                          );
                        }
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return CircularProgressIndicator();
                },
              ),
              FutureBuilder<Album>(
                future: futureAlbumGB,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Article> resultArticles=new List();
                    for (int i=0; i<snapshot.data.articles.length; i++){
                      if ((snapshot.data.articles[i].urlToImage != null)&&(snapshot.data.articles[i].url != null)&&(snapshot.data.articles[i].author != null)&&
                          (snapshot.data.articles[i].description != null)){
                        resultArticles.add(snapshot.data.articles[i]);
                      }
                    }
                    return ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.black,
                        ),
                        padding: const EdgeInsets.all(8),
                        itemCount: resultArticles.length,
                        itemBuilder: (BuildContext context, int index){
                          return Column(
                            children: [
                              Image.network(resultArticles[index].urlToImage),
                              Text(resultArticles[index].title),
                              Container(
                                margin: EdgeInsets.only(top:30, bottom: 15),
                                height: 50,
                                width: 200,
                                color: Colors.cyan,
                                alignment: Alignment.center,
                                child: ListTile(title: Text("More", style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center),
                                    onTap: (){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context)=>detailedInformation(), settings: RouteSettings(arguments: resultArticles[index]))
                                      );
                                    }),
                              )
                            ],
                          );
                        }
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class detailedInformation extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final Article article=ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Detailed Information"),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top:15),
              height: 60,
              child: Text(article.author, style: TextStyle(color: Colors.deepPurple, fontSize: 20)),
            ),
            Image.network(article.urlToImage),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(top:15),
              child: Text("${article.publishedAt.day}."+findMonth(article.publishedAt.month)+"."+"${article.publishedAt.year}"),
            ),
            Container(
              child: Text(article.description, style: TextStyle(fontSize: 12)),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(top:15),
              child: Linkify(
                onOpen: (link) async {
                  if (await canLaunch(link.url)) {
                    await launch(link.url);
                  } else {
                    throw 'Could not launch $link';
                  }
                },
                text: article.url,
                linkStyle: TextStyle(color: Colors.cyan, fontSize: 12),
              )
            ),
          ],
        ),
      ),
    );
  }
}

String findMonth (int num){
  if (num==1){
    return "JAN";
  }
  else if (num==2){
    return "FEB";
  }
  else if (num==2){
    return "MAR";
  }
  else if (num==2){
    return "APR";
  }
  else if (num==2){
    return "MAY";
  }
  else if (num==2){
    return "JUN";
  }
  else if (num==2){
    return "JUL";
  }
  else if (num==2){
    return "AUG";
  }
  else if (num==2){
    return "SEP";
  }
  else if (num==2){
    return "OCT";
  }
  else if (num==2){
    return "NOV";
  }
  else{
    return "DEC";
  }
}
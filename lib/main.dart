// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main(){
  runApp(App());
}

class GalleryPage extends StatelessWidget {
  String title;
  List<String> urls;

  GalleryPage({Key? key, required this.title, required this.urls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      body: GridView.count(
        primary: false,
        crossAxisCount: 2,
        children: List.of(urls.map((url) => Photo(url: url))),
      ),
    );
  }
}

const List<String> urls =[
  "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png",
  "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png",
  "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png",
  "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png",
];

class App extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Photo Viewer',
      home: GalleryPage(
        title: 'Image Gallery',
        urls: urls,
      ),
      );
  }
}

class Photo extends StatelessWidget{
  final url;

  Photo({this.url});

  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.all(10),
      child: Image.network(url),
    );
  }
}

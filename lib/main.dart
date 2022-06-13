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
  "https://burst.shopifycdn.com/photos/person-holds-a-book-over-a-stack-and-turns-the-page.jpg?width=500&format=pjpg&exif=0&iptc=0",
  "https://media.istockphoto.com/photos/green-lawn-at-hill-at-sunrise-picture-id1294990080?b=1&k=20&m=1294990080&s=170667a&w=0&h=-VYbhmVtOU1u6wx03JJwhiQjTc3N4IhddyvQliHs5sM=",
  "https://www.esa.int/var/esa/storage/images/esa_multimedia/images/2020/07/solar_orbiter_s_first_views_of_the_sun5/22136942-2-eng-GB/Solar_Orbiter_s_first_views_of_the_Sun_pillars.gif",
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

class Photo extends StatefulWidget{
  String url;

  Photo({Key? key, required this.url}) : super(key: key);

  @override
  PhotoState createState() => PhotoState(url: this.url);
}

class PhotoState extends State<Photo>{
  String url;
  int index = 0;

  PhotoState({required this.url});

  onTap(){
    setState(() {
     index >= urls.length - 1 ? index = 0 : index++;
    });
    url = urls[index];
  }

  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.all(10),
      child: GestureDetector(child: Image.network(url),
      onTap: onTap),
    );
  }
}

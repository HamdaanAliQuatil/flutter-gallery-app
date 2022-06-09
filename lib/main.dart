// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main(){
  runApp(App());
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
      home: Photo(),
    );
  }
}

class Photo extends StatelessWidget{
  final url = "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png";
  @override
  Widget build(BuildContext context){
    return Image.network(url);
  }
}

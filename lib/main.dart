// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
void main(){
  runApp(App());
}

class GalleryPage extends StatelessWidget {
  String title;
  List<PhotoState> photoStates;
  final bool tagging;

  final Function toggleTagging;
  final Function onPhotoSelect;

  GalleryPage({
    required this.title,
    required this.photoStates,
    required this.tagging,
    required this.toggleTagging,
    required this.onPhotoSelect,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      body: GridView.count(
        primary: false,
        crossAxisCount: 2,
        children: List.of(photoStates.map((ps) => Photo(state: ps,
          selectable: tagging,
          onSelect: onPhotoSelect,
          onLongPress: toggleTagging,
        ))),
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

class App extends StatefulWidget{
  @override
  AppState createState() => AppState();
}

class AppState extends State<App>{
  bool isTagging = false;
  List<PhotoState> photoStates = List.of(urls.map((url) => PhotoState(url)));

  void toggleTagging(String url){
    setState(() {
      isTagging = !isTagging;
      photoStates.forEach((element) {
        if(isTagging && element.url == url){
          element.selected = true;
        }
        else{
          element.selected = false;
        }
      });
    });
  }

  void onPhototSelect(String url, bool selected){
    setState(() {
      photoStates.forEach((element) {
        if(element.url == url){
          element.selected = selected;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Photo Viewer',
      home: GalleryPage(
        title: 'Image Gallery',
        photoStates: photoStates,
        tagging: isTagging,
        toggleTagging: toggleTagging,
        onPhotoSelect: onPhototSelect,
      ),
      );
  }
}

class PhotoState{
  String url;
  bool selected;

  PhotoState(this.url, {this.selected = false});
}

class Photo extends StatelessWidget{
  final PhotoState state;
  final bool selectable;

  final Function onLongPress;
  final Function onSelect;

  Photo({required this.state, required this.selectable, required this.onLongPress, required this.onSelect});

  @override
  Widget build(BuildContext context){
    List<Widget> children = [
      GestureDetector(
        child: Image.network(state.url),
        onLongPress: () => onLongPress(state.url),
      )
    ];
    if(selectable){
      children.add(
        Positioned(
          left: 20,
          top: 0,
          child: Theme(
            data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.grey[200]),
            child: Checkbox(
              value: state.selected,
              onChanged: (value) => onSelect(state.url, value),
              activeColor: Colors.white,
              checkColor: Colors.black,
            ),
          ))
      );
    }
  return Container(
    padding: EdgeInsets.only(top: 10),
    child: Stack(alignment: Alignment.center, children: children),
  );
  }
}
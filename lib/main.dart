// ignore_for_file: prefer_const_constructors_in_immutables, unnecessary_this, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(App());
}

const List<String> urls =[
  "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png",
  "https://burst.shopifycdn.com/photos/person-holds-a-book-over-a-stack-and-turns-the-page.jpg?width=500&format=pjpg&exif=0&iptc=0",
  "https://media.istockphoto.com/photos/green-lawn-at-hill-at-sunrise-picture-id1294990080?b=1&k=20&m=1294990080&s=170667a&w=0&h=-VYbhmVtOU1u6wx03JJwhiQjTc3N4IhddyvQliHs5sM=",
  "https://www.esa.int/var/esa/storage/images/esa_multimedia/images/2020/07/solar_orbiter_s_first_views_of_the_sun5/22136942-2-eng-GB/Solar_Orbiter_s_first_views_of_the_Sun_pillars.gif",
];

class App extends StatefulWidget {
  @override
  AppModel createState() => AppModel();
}

class PhotoState {
  String url;
  late bool selected;
  late bool display;
  Set<String> tags = {};

  PhotoState(this.url, {selected = false, display = true, tags});
}

class MyInheritedWidget extends InheritedWidget {
  final AppModel model;

  MyInheritedWidget({Key? key, required Widget child, required this.model})
      : super(key: key, child: child);

  static AppModel of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<MyInheritedWidget>()!
        .model;
  }

  @override
  bool updateShouldNotify(_) => true;
}

class AppModel extends State<App> {
  bool isTagging = false;

  List<PhotoState> photoStates = List.of(urls.map((url) => PhotoState(url)));

  Set<String> tags = {"all", "nature", "cat"};

  void toggleTagging(String url) {
    setState(() {
      isTagging = !isTagging;
      photoStates.forEach((element) {
        if (isTagging && element.url == url) {
          element.selected = true;
        } else {
          element.selected = false;
        }
      });
    });
  }

  void onPhotoSelect(String url, bool selected) {
    setState(() {
      photoStates.forEach((element) {
        if (element.url == url) {
          element.selected = selected;
        }
      });
    });
  }

  void selectTag(String tag) {
    setState(() {
      if (isTagging) {
        if (tag != "all") {
          photoStates.forEach((element) {
            if (element.selected) {
              element.tags.add(tag);
            }
          });
        }
        toggleTagging('');
      } else {
        photoStates.forEach((element) {
          element.display = tag == "all" ? true : element.tags.contains(tag);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Photo Viewer',
        home: MyInheritedWidget(
            child: Builder(builder: (BuildContext innerContext) {
              return GalleryPage(
                  title: "Image Gallery",
                  model: MyInheritedWidget.of(innerContext));
            }),
            model: this));
  }
}

class GalleryPage extends StatelessWidget {
  final String title;
  final AppModel model;

  GalleryPage({required this.title, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(this.title)),
      body: Builder(builder: (BuildContext innerContext) {
        return GridView.count(
            primary: false,
            crossAxisCount: 2,
            children: List.of(model.photoStates
                .where((ps) => ps.display)
                .map((ps) => Photo(
                    state: ps, model: MyInheritedWidget.of(innerContext)))));
      }),
      drawer: Drawer(
          child: ListView(
        children: List.of(model.tags.map((t) => ListTile(
              title: Text(t),
              onTap: () {
                model.selectTag(t);
                Navigator.of(context).pop();
              },
            ))),
      )),
    );
  }
}

class Photo extends StatelessWidget {
  final PhotoState state;
  final AppModel model;

  Photo({required this.state, required this.model});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      GestureDetector(
          child: Image.network(state.url),
          onLongPress: () => model.toggleTagging(state.url))
    ];

    if (model.isTagging) {
      children.add(Positioned(
          left: 20,
          top: 0,
          child: Theme(
              data: Theme.of(context)
                  .copyWith(unselectedWidgetColor: Colors.grey[200]),
              child: Checkbox(
                onChanged: (value) {
                  model.onPhotoSelect(state.url, value!);
                },
                value: state.selected,
                activeColor: Colors.white,
                checkColor: Colors.black,
              ))));
    }

    return Container(
        padding: EdgeInsets.only(top: 10),
        child: Stack(alignment: Alignment.center, children: children));
  }
}
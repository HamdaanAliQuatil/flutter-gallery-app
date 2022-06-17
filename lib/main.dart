// ignore_for_file: prefer_const_constructors_in_immutables, unnecessary_this, use_key_in_widget_constructors, import_of_legacy_library_into_null_safe, prefer_final_fields, unused_field

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';

void main() {
  AppModel model = AppModel();
  runApp(App(model));
}

const List<String> urls =[
  "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png",
  "https://burst.shopifycdn.com/photos/person-holds-a-book-over-a-stack-and-turns-the-page.jpg?width=500&format=pjpg&exif=0&iptc=0",
  "https://media.istockphoto.com/photos/green-lawn-at-hill-at-sunrise-picture-id1294990080?b=1&k=20&m=1294990080&s=170667a&w=0&h=-VYbhmVtOU1u6wx03JJwhiQjTc3N4IhddyvQliHs5sM=",
  "https://www.esa.int/var/esa/storage/images/esa_multimedia/images/2020/07/solar_orbiter_s_first_views_of_the_sun5/22136942-2-eng-GB/Solar_Orbiter_s_first_views_of_the_Sun_pillars.gif",
];

class App extends StatelessWidget {
  final AppModel model;

  App(this.model);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
            title: 'Photo Viewer',
            home: GalleryPage(
                      title: "Image Gallery", model: model
                    ));
  }
}

class PhotoState {
  String url;
  late bool selected = true;
  late bool display = true;
  Set<String> tags = {};

  PhotoState(this.url, {selected = false, display = true, tags});
}

class AppModel with ChangeNotifier {
  Stream<bool> get isTagging => _taggingController.stream;
  Stream<List<PhotoState>> get photoStates => _photoStateController.stream;

  bool _isTagging = false;
  List<PhotoState> _photoStates = List.of(urls.map((url) => PhotoState(url)));

  Set<String> tags = {"all", "nature", "logo", "book"};

  // static AppModel of(BuildContext context) => ScopedModel.of<AppModel>(context);
  StreamController<bool> _taggingController = StreamController.broadcast();
  StreamController<List<PhotoState>> _photoStateController = StreamController.broadcast();

  AppModel(){
    _photoStateController.onListen = () {
      _photoStateController.add(_photoStates);
    };
    _taggingController.onListen = () {
      _taggingController.add(_isTagging);
    };
  }

  void toggleTagging(String url) {
    _isTagging = !_isTagging;
    _photoStates.forEach((element) {
      if (_isTagging && element.url == url) {
        element.selected = true;
      } else {
        element.selected = false;
      }
    });
    _taggingController.add(_isTagging);
    _photoStateController.add(_photoStates);
  }

  void onPhotoSelect(String url, bool selected) {
    _photoStates.forEach((element) {
      if (element.url == url) {
        element.selected = selected;
      }
    });
    _photoStateController.add(_photoStates);
  }

  void selectTag(String tag) {
    if (_isTagging) {
      if (tag != "all") {
        _photoStates.forEach((element) {
          if (element.selected) {
            element.tags.add(tag);
          }
        });
      }
      toggleTagging('');
    } else {
      _photoStates.forEach((element) {
        element.display = tag == "all" ? true : element.tags.contains(tag);
      });
      _photoStateController.add(_photoStates);
    }
    notifyListeners();
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
      body: StreamBuilder<List<PhotoState>>(
        initialData: const [],
        stream: model.photoStates,
        builder: (context, snapshot) {
          return GridView.count(
              primary: false,
              crossAxisCount: 2,
              children: List.of(snapshot.data!
                  .where((ps) => ps.display)
                  .map((ps) => Photo(state: ps, model:model))));
        }
      ),
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
    return StreamBuilder<bool>(
      initialData: false,
      stream: model.isTagging,
      builder: (context, snapshot){
            List<Widget> children = [
      GestureDetector(
          child: Image.network(state.url),
          onLongPress: () => model.toggleTagging(state.url))
    ];

    if (snapshot.data != null) {
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
    );
  }
}

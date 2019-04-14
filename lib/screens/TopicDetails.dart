import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_snap/models/Topic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_snap/util/utils.dart';
import 'package:study_snap/widgets/Grid.dart';

class TopicDetails extends StatelessWidget {
  TopicDetails({Key key, this.topic}) : super(key: key);

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topic.title),
      ),
      body: Grid(
        topic: topic,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          return showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: new SingleChildScrollView(
                    child: new ListBody(
                      children: <Widget>[
                        GestureDetector(
                          child: new Text('Take a picture'),
                          onTap: openCamera,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                        ),
                        GestureDetector(
                          child: new Text('Select from gallery'),
                          onTap: openGallery,
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }

  void openCamera() async {
    File image = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 500,
      maxHeight: 500,
    );
    saveImage(image);
  }

  void openGallery() async {
    File image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 500,
      maxHeight: 500,
    );
    saveImage(image);
  }

  void saveImage(File image) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt(topic.title) ?? 0;
    String path = appDocDir.path +
        '/' +
        stripWhitespaces(topic.title) +
        '/' +
        count.toString();
    image.copy(path);
    prefs.setInt(topic.title, ++count);
  }
}

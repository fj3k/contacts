import 'package:flutter/material.dart';

import 'circles.dart';
import 'datastore.dart';
import 'data.dart';
import 'settings.dart';

void main() => runApp(AOSContactsApp());

class AOSContactsApp extends StatelessWidget {
  static final title = 'AOS Contacts'; //Pravas

  @override
  Widget build(BuildContext context) {
    new DataStore(); //Initialise the data store
    var p = new People();
    p.getContacts();
    return MaterialApp(
      title: title,
      theme: new ThemeData(
        primaryColor: Colors.blueGrey,
      ),
      home: CirclesWgt(),
    );
  }

  static Widget appBar(BuildContext context) {
    return AppBar(
      //Don't use leading: if it's not there the back button will appear
      title: Text(title),
      actions: <Widget>[
        new IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Navigator.of(context).push(
                new MaterialPageRoute<void>(
                  builder: (BuildContext context) => new SettingsWgt(),
                ),
              );
            }),
      ],
    );
  }
}

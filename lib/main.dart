import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:simple_permissions/simple_permissions.dart';

import 'circles.dart';
import 'datastore.dart';
import 'data.dart';
import 'settings.dart';
// import 'form.dart';

void main() => runApp(AOSContactsApp());

class AOSContactsApp extends StatelessWidget {
  static final title = 'AOS Contacts'; //Pravas

  Future<bool> checkPermissions() async {
    // Should be checking the 'Storage' permission. Always fails.
    // if (!await SimplePermissions.checkPermission(Permission.ReadExternalStorage)) {
    //   var res = await SimplePermissions.requestPermission(Permission.ReadExternalStorage);
    //   if (res != PermissionStatus.authorized) AutoForm.canLibrary = false;
    // }

    // This one works, but to be consistent with the above, disabling the check here.
    // if (!await SimplePermissions.checkPermission(Permission.Camera)) {
    //   var res = await SimplePermissions.requestPermission(Permission.Camera);
    //   if (res != PermissionStatus.authorized) AutoForm.canCamera = false;
    // }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    new DataStore(); //Initialise the data store
    var p = new People();
    p.getContacts();
    checkPermissions();
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

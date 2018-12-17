import 'dart:async';

import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

import 'main.dart';
import 'data.dart';

class CircleWgtState extends State<CircleWgt> {
  final people = new People();
  final _saved = new Set<String>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AOSContactsApp.appBar(context),
      body: _buildCircle(),
    );
  }

  Widget _buildCircle() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: people.people.length * 2 - 1,
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          // if (index >= _suggestions.length) {
          //   getContactNames();
          // }
          if (index >= people.people.length) return null;
          return _buildRow(people.people[index]);
        });
  }

  Future<int> getContactNames() async {
    var start = new DateTime.now().millisecondsSinceEpoch;
    Iterable<Contact> contacts = await ContactsService.getContacts();
    var end = new DateTime.now().millisecondsSinceEpoch;
    debugPrint("contacts fetched in ${(end - start)} milliseconds");
    setState(() {
      contacts.forEach((contact) {
        List<String> name = [];
        if (contact.givenName != null) name.add(contact.givenName);
        if (contact.middleName != null) name.add(contact.middleName);
        if (contact.familyName != null) name.add(contact.familyName);
        // if (contact.identifier != null) name.add("(${contact.identifier})");
        // if (name.length > 0) _suggestions.add([name.join(" "), contact.avatar]);
      });
    });
    return contacts.length;
  }

  Widget _buildRow(Person deets) {
    final alreadySaved = _saved.contains(deets.core.name);
    var avatar;
    if (deets.core.avatar.length == 0) {
      avatar = CircleAvatar(
        backgroundColor: Colors.blueGrey,
        child: Text("${deets.core.name[0]}"),
      );
    } else {
      avatar = CircleAvatar(
        backgroundImage: MemoryImage(deets.core.avatar)
      );
    }

    return ListTile(
      leading: avatar,
      title: Text(
        deets.core.name,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.star : Icons.star_border,
        color: alreadySaved ? Colors.yellow[700] : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(deets.core.name);
          } else {
            _saved.add(deets.core.name);
          }
        });
      },
    );
  }
}

class CircleWgt extends StatefulWidget {
  @override
  CircleWgtState createState() => new CircleWgtState();
}

import 'package:flutter/material.dart';

import 'main.dart';
import 'data.dart';
import 'person.dart';

class CircleWgtState extends State<CircleWgt> {
  final people = new People();
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
          if (index >= people.people.length) return null;
          return _buildRow(people.people[index]);
        });
  }

  Widget _buildRow(Person deets) {
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
      onTap: () {
        Navigator.of(context).push(
          new MaterialPageRoute<void>(
            builder: (BuildContext context) => new PersonWgt(deets, false, this),
          )
        );
      },
    );
  }
}

class CircleWgt extends StatefulWidget {
  @override
  CircleWgtState createState() => new CircleWgtState();
}

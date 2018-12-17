import 'package:flutter/material.dart';

import 'circle.dart';
import 'person.dart';
import 'edit.circle.dart';
import 'main.dart';
import 'data.dart';

class CirclesWgtState extends State<CirclesWgt> {
  final _vips = new List<PersonData>();
  final _circles = new List<CircleData>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    if (_vips.length == 0) {
      _vips.add(new PersonData('Me'));

      _circles.add(new CircleData('Family', 0xeacb-1));
      _circles.add(new CircleData('Friends', 0xea51-1));
      _circles.add(new CircleData('Work', 0xeba1-1));
      _circles.add(new CircleData('Companies', 0xeb87-1));
      _circles.add(new CircleData('Other', 0xe91f-1));
    }

    return Scaffold(
      appBar: AOSContactsApp.appBar(context),
      body: _buildCircles(),
    );
  }

  Widget _buildCircles() {
    return ListView.builder(
        itemCount: (_vips.length + _circles.length) * 2 - 1,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = (i ~/ 2);
          if (index < _vips.length) {
            return _buildVIPRow(_vips[index]);
          } else if (index - _vips.length >= _circles.length) {
            return null;
          }
          return _buildRow(_circles[index - _vips.length]);
        });
  }

  Widget _buildVIPRow(PersonData person) {
    Widget leading;
    try {
      var imageProvider = new AssetImage('assets/images/acockroft.png');
      leading = CircleAvatar(
        backgroundImage: imageProvider
      );
    } catch (Exception) {
      leading = new Icon(Icons.person);
    }
    return ListTile(
      leading: leading,
      title: Text(
        person.name,
        style: _biggerFont,
      ),
      trailing: new Icon(
        Icons.edit,
      ),
      onTap: () {
        Navigator.of(context).push(
          new MaterialPageRoute<void>(
            builder: (BuildContext context) => new PersonWgt(),
          )
        );
      },
    );
  }

  Widget _buildRow(CircleData circle) {
    return ListTile(
      leading: Icon(IconData(circle.icon, fontFamily: 'aoscontacts')),
      title: Text(
        circle.name,
        style: _biggerFont,
      ),
      trailing: new Icon(
        Icons.chevron_right,
        // color: alreadySaved ? Colors.yellow[700] : null,
      ),
      onTap: () {
        Navigator.of(context).push(
          new MaterialPageRoute<void>(
            builder: (BuildContext context) => new CircleWgt(),
          )
        );
      },
      onLongPress: () {
        Navigator.of(context).push(
          new MaterialPageRoute<void>(
            builder: (BuildContext context) => new EditCircleWgt(circle, this),
          )
        );
      },
    );
  }
}

class CirclesWgt extends StatefulWidget {
  @override
  CirclesWgtState createState() => new CirclesWgtState();
}

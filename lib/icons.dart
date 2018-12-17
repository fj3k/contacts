import 'package:flutter/material.dart';

import 'main.dart';

class IconChooserWgtState extends State<IconChooserWgt> {
  final choice;
  State<dynamic> parent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AOSContactsApp.appBar(context),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    var orientation = Orientation.portrait;
    return GridView.builder(
        itemCount: 340,
        padding: const EdgeInsets.all(16.0),
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (orientation == Orientation.portrait) ? 4 : 8),
        itemBuilder: (context, i) {
          var dark = false;
          int code = 59648 + i * 2 + (dark ? 1 : 0);

          if (code > 60327) return null;
          return _buildCell(code);
        });
  }

  Widget _buildCell(int code) {
    final alreadySaved = choice.setting == code;
    int test = code + (alreadySaved ? 1 : 0);
    final icon = new IconData(test, fontFamily: 'aoscontacts');

    return ListTile(
      title: new Icon(
        icon,
        // color: alreadySaved ? Colors.blue : null,
      ),
      onTap: () {
        setState(() {
          parent.setState(() {
            if (alreadySaved) {
              // choice.setting = null;
            } else {
              choice.setting = code;
            }
          });
        });
      },
    );
  }

  IconChooserWgtState(this.choice, this.parent);
}

class IconChooserWgt extends StatefulWidget {
  final IconSetting setting;
  final State<dynamic> parent;

  @override
  IconChooserWgtState createState() => new IconChooserWgtState(setting, this.parent);
  IconChooserWgt(this.setting, this.parent);
}

class IconSetting {
  int setting;
  IconSetting(this.setting);
}

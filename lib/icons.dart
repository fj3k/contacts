import 'package:flutter/material.dart';

import 'main.dart';

class IconChooserWgtState extends State<IconChooserWgt> {
  final choice;
  State<dynamic> parent;

  @override
  Widget build(BuildContext context) {
    var buttonBar;
    var bottomButtons = <Widget>[];

    bottomButtons.add(
      IconButton(
        icon: Icon(IconData(choice.value, fontFamily: 'aoscontacts')),
        onPressed: () {}, // This is just there to show what is selected.
      )
    );

    buttonBar = BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: bottomButtons,
      ),
    );

    var saveButton = FloatingActionButton(
      child: const Icon(Icons.check),
      backgroundColor: Colors.green,
      onPressed: () {
        Navigator.pop(context);
      },
    );

    return Scaffold(
      appBar: AOSContactsApp.appBar(context),
      body: _buildSuggestions(),
      bottomNavigationBar: buttonBar,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: saveButton,
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
    final alreadySaved = choice.value == code;
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
              // choice.value = null;
            } else {
              choice.value = code;
            }
          });
        });
      },
    );
  }

  IconChooserWgtState(this.choice, this.parent);
}

class IconChooserWgt extends StatefulWidget {
  final setting;
  final State<dynamic> parent;

  @override
  IconChooserWgtState createState() => new IconChooserWgtState(setting, this.parent);
  IconChooserWgt(this.setting, this.parent);
}

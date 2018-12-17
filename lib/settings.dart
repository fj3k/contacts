import 'package:flutter/material.dart';
import 'data.dart';

class SettingsWgtState extends State<SettingsWgt> {
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _settings = new Settings();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //Don't use leading: if it's not there the back button will appear
        title: Text('AOS Contacts'), //Pravas
      ),
      body: _buildSettings(),
    );
  }

  Widget _buildSettings() {
    return ListView.builder(
        itemCount: 1,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          final keys = _settings.settings.keys;
          final key = keys.elementAt(index);
          return _buildRow(key);
        });
  }

  Widget _buildRow(String key) {
    return SwitchListTile(
        title: Text(
          _settings.settings[key].label,
          style: _biggerFont,
        ),
        value: _settings.settings[key].value == 'TRUE',
        onChanged: (bool value) {
          setState(() {
            debugPrint(value ? "T" : "F");
            _settings.settings[key].value = value ? 'TRUE' : 'FALSE';
          });
        }
    );
  }
}

class SettingsWgt extends StatefulWidget {
  @override
  SettingsWgtState createState() => new SettingsWgtState();
}

import 'package:flutter/material.dart';

import 'main.dart';
import 'data.dart';
import 'icons.dart';

class EditCircleWgtState extends State<EditCircleWgt> {
  CircleData circle;
  State<dynamic> parent;
  final _formKey = GlobalKey<FormState>();
  var iconSetting;

  @override
  Widget build(BuildContext context) {
    if (iconSetting == null) iconSetting = new IconSetting(circle.icon);
    return Scaffold(
      appBar: AOSContactsApp.appBar(context),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Circle name:'),
            TextFormField(
              initialValue: circle.name,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a name';
                }
                circle.name = value;
              },
            ),
            Row(
              children: <Widget>[
                Text('Icon:'),
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).push(new MaterialPageRoute<void>(
                      builder: (BuildContext context) => new IconChooserWgt(iconSetting, this),
                    ));
                  },
                  child: Icon(IconData(iconSetting.setting, fontFamily: 'aoscontacts')),
                ),
              ]
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    circle.icon = iconSetting.setting;
                    parent.setState(() {
                      Navigator.pop(context);
                    });
                  }
                },
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  EditCircleWgtState(this.circle, this.parent);
}

class EditCircleWgt extends StatefulWidget {
  final CircleData circle;
  final State<dynamic> parent;
  @override
  EditCircleWgtState createState() => new EditCircleWgtState(circle, this.parent);

  EditCircleWgt(this.circle, this.parent);
}

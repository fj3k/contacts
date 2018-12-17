import 'package:flutter/material.dart';

import 'main.dart';
import 'icons.dart';
import 'constants.dart';

class AutoForm {
  final fields = List<AutoFormField>();
  final context;
  final State<dynamic> parent;
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final saveFunction;

  AutoForm(this.context, this.parent, this.saveFunction);

  Widget build(_formKey) {
    List<Widget> children = <Widget> [];

    fields.forEach((field) {
      if (field.type & 8 == 8) {
        children.addAll(textField(field));
      } else if (field.type == FieldType.ICON) {
        children.addAll(iconChooserField(field));
      }
    });

    children.add(
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: RaisedButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              debugPrint("Save: ${fields[1].value}");
              saveFunction();
            }
          },
          child: Text('Save'),
        ),
      ),
    );

    return Scaffold(
      appBar: AOSContactsApp.appBar(context),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  List<Widget> textField(AutoFormField deets) {
    TextInputType kb = TextInputType.text;

    switch (deets.type) {
      case FieldType.RICH: kb = TextInputType.multiline; break;
      case FieldType.URL: kb = TextInputType.url; break;
      case FieldType.EMAIL: kb = TextInputType.emailAddress; break;
      case FieldType.PHONE:
      case FieldType.MOBILE:
      case FieldType.FAX:
      case FieldType.MODEM:
        kb = TextInputType.phone;
        break;
    }

    return <Widget> [
      Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
        child: Text('${deets.label}:', style: _biggerFont),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        child: TextFormField(
          initialValue: deets.value,
          keyboardType: kb,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter a value';
            }
            deets.value = value;
          },
        ),
      )
    ];
  }

  List<Widget> iconChooserField(AutoFormField deets) {
    return <Widget> [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Text('${deets.label}: ', style: _biggerFont),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: RaisedButton(
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute<void>(
                    builder: (BuildContext context) => new IconChooserWgt(deets, parent),
                  ));
                },
                child: Icon(IconData(deets.value, fontFamily: 'aoscontacts')),
              ),
            ),
          ]
        ),
      ),
    ];
  }
}

class AutoFormField {
  final label;
  final type;
  var value;

  AutoFormField(this.label, this.type, this.value);
}

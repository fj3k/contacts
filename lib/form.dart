import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import 'main.dart';
import 'icons.dart';
import 'constants.dart';

class AutoForm {
  static const NONE = 0;
  static const VIEW = 1;
  static const EDIT = 2;
  static const READONLY = 3;

  final fields = List<AutoFormField>();
  final context;
  final State<dynamic> parent;
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final saveFunction;
  final formMode;

  AutoForm(this.context, this.parent, this.saveFunction, this.formMode);

  Widget build(_formKey) {
    List<Widget> children = <Widget> [];

    fields.forEach((field) {
      if (field.type & 8 == 8) {
        children.addAll(textField(field));
      } else if (field.type == FieldType.ICON) {
        children.addAll(iconChooserField(field));
      }
    });

    if (saveFunction != null) {
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
    }

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
    var widgets = <Widget>[];

    widgets.add(
      Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
        child: Text('${deets.label}:', style: _biggerFont),
      ),
    );

    if (formMode == AutoForm.VIEW) {
      var actions = <Action>[];
      switch (deets.type) {
        case FieldType.URL:
          RegExp re = new RegExp(r"^(\w+):(//.+)$", caseSensitive: false);
          var m = re.firstMatch(deets.value);
          if (m != null) {
            actions.add(Action(m.group(1), m.group(2), Icons.open_in_browser));
          } else {
            actions.add(Action('http', "//${deets.value}", Icons.open_in_browser));
          }
          break;
        case FieldType.EMAIL:
          actions.add(Action('mailto', deets.value, Icons.email));
          break;
        case FieldType.PHONE:
        case FieldType.MOBILE:
        case FieldType.FAX:
        case FieldType.MODEM:
          actions.addAll([
            Action('tel', deets.value, Icons.phone),
            Action('sms', deets.value, Icons.sms)
          ]);
          break;
      }

      var rowWidgets = <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
          child: Text(deets.value, style: _biggerFont)
        ),
      ];

      if (actions.isNotEmpty) {
        var buttons = <Widget>[];
        actions.forEach((action) {
          buttons.add(
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: MaterialButton(
                height: 40.0,
                minWidth: 40.0,
                elevation: 0,
                color: Theme.of(context).buttonColor,
                onPressed: () {
                  UrlLauncher.launch("${action.intent}:${action.address}");
                },
                child: Icon(action.icon),
              )
            )
          );
        });
        rowWidgets.add(Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: buttons,
              mainAxisAlignment: MainAxisAlignment.end
            )
          )
        ));
      }
      widgets.add(
        Row(
          children: rowWidgets,
        )
      );
    } else {
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

      widgets.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          child: TextFormField(
            initialValue: deets.value,
            keyboardType: kb,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a value';
              }
              //TODO value validation
              deets.value = value;
            },
          ),
        )
      );
    }

    return widgets;
  }

  List<Widget> iconChooserField(AutoFormField deets) {
    Widget valueWgt;
    if (formMode == AutoForm.VIEW) {
      valueWgt = Icon(IconData(deets.value, fontFamily: 'aoscontacts'));
    } else {
      valueWgt = MaterialButton(
        height: 40.0,
        minWidth: 40.0,
        color: Theme.of(context).buttonColor,
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute<void>(
            builder: (BuildContext context) => new IconChooserWgt(deets, parent),
          ));
        },
        child: Icon(IconData(deets.value, fontFamily: 'aoscontacts')),
      );
    }

    return <Widget> [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Text('${deets.label}: ', style: _biggerFont),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: valueWgt,
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

class Action {
  final intent;
  final address;
  final icon;

  Action(this.intent, this.address, this.icon);
}

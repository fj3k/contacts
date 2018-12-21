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

    var first = true;
    fields.forEach((field) {
      if (first) {
        first = false;
      } else {
        children.add(Divider());
      }
      if (field.type & 8 == 8) {
        children.addAll(textField(field));
      } else if (field.type == FieldType.ICON) {
        children.addAll(iconChooserField(field));
      } else if (field.type == FieldType.IMAGE) {
        children.addAll(imageChooserField(field));
      }
    });

    var buttonBar;
    var saveButton;
    if (saveFunction != null) {
      var bottomButtons = <Widget>[];
      if (false) {
        bottomButtons.add(IconButton(
          icon: Icon(Icons.add),
          color: Colors.green,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              debugPrint("Save: ${fields[1].value}");
              saveFunction();
            }
          },
        ));
      } else {
        bottomButtons.add(Spacer());
      }

      bottomButtons.add(
        IconButton(
          icon: Icon(Icons.clear),
          color: Colors.red,
          onPressed: () {
            Navigator.pop(context);
          },
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

      saveButton = FloatingActionButton(
        child: const Icon(Icons.check),
        backgroundColor: Colors.green,
        onPressed: () {
          if (_formKey.currentState.validate()) {
            saveFunction();
          }
        },
      );
    }

    return Scaffold(
      appBar: AOSContactsApp.appBar(context),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          )
        ),
      ),
      bottomNavigationBar: buttonBar,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: saveButton,
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

    var val = deets.value == null ? '' : deets.value;

    if (formMode == AutoForm.VIEW) {
      var actions = <Action>[];
      switch (deets.type) {
        case FieldType.URL:
          RegExp re = new RegExp(r"^(\w+):(//.+)$", caseSensitive: false);
          var m = re.firstMatch(val);
          if (m != null) {
            actions.add(Action(m.group(1), m.group(2), Icons.open_in_browser));
          } else {
            actions.add(Action('http', "//$val", Icons.open_in_browser));
          }
          break;
        case FieldType.EMAIL:
          actions.add(Action('mailto', val, Icons.email));
          break;
        case FieldType.PHONE:
        case FieldType.MOBILE:
        case FieldType.FAX:
        case FieldType.MODEM:
          actions.addAll([
            Action('tel', val, Icons.phone),
            Action('sms', val, Icons.sms)
          ]);
          break;
      }

      var rowWidgets = <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
          child: Text(val, style: _biggerFont)
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

  List<Widget> imageChooserField(AutoFormField deets) {
    var img;
    if (deets.value == null || deets.value.length == 0) {
      img = CircleAvatar(
        backgroundColor: Colors.blueGrey,
        child: Text("Choose"),
      );
    } else {
      img = CircleAvatar(
        backgroundImage: MemoryImage(deets.value)
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
              child: img
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

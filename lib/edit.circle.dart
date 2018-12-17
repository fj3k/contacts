import 'package:flutter/material.dart';

import 'data.dart';
import 'form.dart';
import 'constants.dart';

class EditCircleWgtState extends State<EditCircleWgt> {
  CircleData circle;
  State<dynamic> parent;
  final _formKey = GlobalKey<FormState>();
  var form;

  @override
  Widget build(BuildContext context) {
    if (form == null) {
      form = new AutoForm(context, this, save);
      form.fields.addAll([
        AutoFormField('Circle name', FieldType.TEXT, circle.name),
        AutoFormField('Icon', FieldType.ICON, circle.icon),
      ]);
    }
    return form.build(_formKey);
  }

  void save() {
    circle.name = form.fields[0].value;
    circle.icon = form.fields[1].value;
    parent.setState(() {
      Navigator.pop(context);
    });
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

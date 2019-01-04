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
      form = new AutoForm(context, this, save, AutoForm.EDIT);
      form.fields.addAll([
        AutoFormField('Circle name', FieldType.TEXT, circle.name, 'C-Name'),
        AutoFormField('Icon', FieldType.ICON, circle.icon, 'C-Icon')
      ]);
    }
    return form.build(_formKey);
  }

  void save() {
    circle.name = form.fields['C-Name'].value;
    circle.icon = form.fields['C-Icon'].value;
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

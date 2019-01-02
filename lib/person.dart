import 'package:flutter/material.dart';

import 'data.dart';
import 'form.dart';
import 'constants.dart';

class PersonWgtState extends State<PersonWgt> {
  Person person;
  final _formKey = GlobalKey<FormState>();
  var form;
  State<dynamic> parent;
  final editMode;

  @override
  Widget build(BuildContext context) {
    // person = Person('Me');
    if (form == null) {
      form = new AutoForm(context, this, editMode ? save : null, editMode ? AutoForm.EDIT : AutoForm.VIEW);
      form.fields.addAll([
        AutoFormField('Name', FieldType.TEXT, person.core.name),
        AutoFormField('Avatar', FieldType.IMAGE, person.core.avatar),
      ]);
      person.additional.forEach((field) {
        form.fields.add(AutoFormField(field.label, field.type, field.value));
      });
    }
    return form.build(_formKey);
  }

  void save() {
    person.core.name = form.fields[0].value;
    person.core.avatar = form.fields[1].value;
    parent.setState(() {
      Navigator.pop(context);
    });
  }

  PersonWgtState(this.person, this.editMode, this.parent);
}

class PersonWgt extends StatefulWidget {
  final Person person;
  final editMode;
  final State<dynamic> parent;

  @override
  PersonWgtState createState() => new PersonWgtState(person, editMode, parent);

  PersonWgt(this.person, this.editMode, this.parent);
}

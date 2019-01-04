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
    if (form == null) {
      form = new AutoForm(context, this, editMode ? save : null, editMode ? AutoForm.EDIT : AutoForm.VIEW);
      form.addFields([
        AutoFormField('Name', FieldType.TEXT, person.core.name, 'C-Name'),
        AutoFormField('Avatar', FieldType.IMAGE, person.core.avatar, 'C-Avatar'),
      ]);
      person.additional.forEach((id, field) {
        form.addField(AutoFormField(field.label, field.type, field.value, id)); //This should specify the ID (4th parameter)
      });
    }
    return form.build(_formKey);
  }

  void save() {
    person.core.name = form.fields['C-Name'].value;
    person.core.avatar = form.fields['C-Avatar'].value;
    person.additional.forEach((id, field) {
      field.label = form.fields[id].label;
      field.value = form.fields[id].value;
    });
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

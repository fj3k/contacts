import 'package:flutter/material.dart';

import 'data.dart';
import 'form.dart';
import 'constants.dart';

class PersonWgtState extends State<PersonWgt> {
  final _formKey = GlobalKey<FormState>();
  var form;

  @override
  Widget build(BuildContext context) {
    Person person = Person('Me');
    if (form == null) {
      form = new AutoForm(context, this, null, AutoForm.VIEW);
      form.fields.addAll([
        AutoFormField('Circle name', FieldType.TEXT, person.core.name),
        AutoFormField('Phone', FieldType.PHONE, '+61405733764'),
        AutoFormField('Email', FieldType.EMAIL, 'andrew@fj3k.com'),
        AutoFormField('Website', FieldType.URL, 'https://fj3k.com/'),
      ]);
    }
    return form.build(_formKey);
  }
}

class PersonWgt extends StatefulWidget {
  @override
  PersonWgtState createState() => new PersonWgtState();
}

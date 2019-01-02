import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:simple_permissions/simple_permissions.dart';

import 'datastore.dart';
import 'constants.dart';

abstract class ObjectList {
  List<DataStorable> objects = [];
}

class Circles extends ObjectList {
  static final Circles _singleton = new Circles._internal();

  factory Circles() {
    return _singleton;
  }
  Circles._internal();
}

class People extends ObjectList {
  static final People _singleton = new People._internal();
  final List<Person> people = new List<Person>();

  Future<int> getContacts() async {
    var start = new DateTime.now().millisecondsSinceEpoch;
    if (!await SimplePermissions.checkPermission(Permission.ReadContacts)) {
      var res = await SimplePermissions.requestPermission(Permission.ReadContacts);
      if (res != PermissionStatus.authorized) return 0;
    }
    Iterable<Contact> contacts = await ContactsService.getContacts();
    var end = new DateTime.now().millisecondsSinceEpoch;
    debugPrint("contacts fetched in ${(end - start)} milliseconds");
    contacts.forEach((contact) {
      List<String> name = [];
      if (contact.prefix != null) name.add(contact.prefix);
      if (contact.givenName != null) name.add(contact.givenName);
      if (contact.middleName != null) name.add(contact.middleName);
      if (contact.familyName != null) name.add(contact.familyName);
      if (contact.suffix != null) name.add(contact.suffix);

      var person = new Person(name.join(" "), contact.avatar);

      contact.emails.forEach((email) {
        var label = email.label;
        if (label == null || label.length == 0) label = "Email";
        person.addField(label, FieldType.EMAIL, email.value);
      });

      contact.phones.forEach((phone) {
        var label = phone.label;
        if (label == null || label.length == 0) label = "Phone";
        person.addField(label, FieldType.PHONE, phone.value);
      });

      contact.postalAddresses.forEach((address) {
        var label = address.label;
        if (label == null || label.length == 0) label = "Address";
        person.addField(label, FieldType.ADDRESS, address.toString());
      });

      person.addField("Job title", FieldType.TEXT, contact.jobTitle);
      person.addField("Company", FieldType.TEXT, contact.company);

      if (name.length > 0) people.add(person);
    });
    people.sort((a, b) => a.core.name.compareTo(b.core.name));
    return contacts.length;
  }

  factory People() {
    return _singleton;
  }
  People._internal();
}

class Settings extends ObjectList {
  static final Settings _singleton = new Settings._internal();
  final settings = new Map<String, SettingsData>();

  factory Settings() {
    if (_singleton.settings.isEmpty) {
      _singleton.settings['DarkIcons'] = new SettingsData("Dark Icons", FieldType.BOOL, "TRUE");
    }
    return _singleton;
  }
  Settings._internal();
}

/// Abstract class for representing multi-table objects
abstract class ComplexDataStorable extends DataStorable {
  ComplexDataStorable();

  Map<String, dynamic> toMap() {
    return null;
  }
  fromMap(Map<String, dynamic> map) {
    return;
  }

  ComplexDataStorable.load({int id, DataStore dataStore});
  save({DataStore dataStore});
}

/// Represents a circle entry
class CircleData extends DataStorable {
  final DatabaseTable table = new CirclesTable();
  int id;
  String name;
  int icon;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      'Name': name,
      'Icon': icon
    };
    if (id != null) map['id'] = id;
    return map;
  }

  fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['Name'];
    icon = map['Icon'];
  }

  CircleData.load({int id, DataStore dataStore}) : super.load(id: id, dataStore: dataStore);
  CircleData(this.name, this.icon);
}

/// Represents a whole person
class Person extends ComplexDataStorable {
  PersonData core;
  List<DetailData> additional = <DetailData>[];
  List<RelationshipData> relationships = <RelationshipData>[];

  Person(name, [avatar]) {
    core = new PersonData(name, avatar);
  }
  Person.load({int id, DataStore dataStore}) {
    if (dataStore == null) dataStore = new DataStore();
    if (id != null) {
      core = new PersonData.load(id: id, dataStore: dataStore);
    }
  }

  addField(label, type, value) {
    var field = DetailData(label, type, value);
    if (field == null) return;
    additional.add(field);
  }

  save({DataStore dataStore}) {
    if (dataStore == null) dataStore = new DataStore();
    dataStore.save(this);
  }
  //TODO: Fetch a list of ids and create DetailsData and RelationshipData classes for each.
}

/// Represents a person entry
class PersonData extends DataStorable {
  final DatabaseTable table = new PeopleTable();
  int id;
  String name;
  var avatar;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      'Name': name,
      'Avatar': avatar
    };
    if (id != null) map['id'] = id;
    return map;
  }

  fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['Name'];
    avatar = map['Avatar'];
  }

  PersonData.load({int id, DataStore dataStore}) : super.load(id: id, dataStore: dataStore);
  PersonData(this.name, [this.avatar]);
}

/// Represents a person entry
class DetailData extends DataStorable {
  final DatabaseTable table = new DetailsTable();
  int id;
  String label;
  int type = FieldType.UNKNOWN;
  var value;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      'Label': label,
      'TypeID': type,
      'Value': value
    };
    if (id != null) map['id'] = id;
    return map;
  }

  fromMap(Map<String, dynamic> map) {
    id = map['id'];
    label = map['Label'];
  }

  DetailData.load({int id, DataStore dataStore}) : super.load(id: id, dataStore: dataStore);
  DetailData(this.label, this.type, [this.value]);
}

/// Represents an individual relationship entry
class RelationshipData extends DataStorable {
  final DatabaseTable table = new RelationshipsTable();
  int id;
  int person;
  int relatedPerson;
  int type;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      'PersonID': person,
      'RelatedPersonID': relatedPerson,
      'RelationshipTypeID': type,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  fromMap(Map<String, dynamic> map) {
    id = map['id'];
    person = map['PersonID'];
    relatedPerson = map['RelatedPersonID'];
    type = map['RelationshipTypeID'];
  }

  RelationshipData.load({int id, DataStore dataStore}) : super.load(id: id, dataStore: dataStore);
}

/// Represents a person entry
class SettingsData extends DataStorable {
  final DatabaseTable table = new SettingsTable();
  int id;
  String label;
  int type = FieldType.UNKNOWN;
  var value;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      'Label': label,
      'TypeID': type,
      'Value': value
    };
    if (id != null) map['id'] = id;
    return map;
  }

  fromMap(Map<String, dynamic> map) {
    id = map['id'];
    label = map['Label'];
  }

  SettingsData.load({int id, DataStore dataStore}) : super.load(id: id, dataStore: dataStore);
  SettingsData(this.label, this.type, this.value);
}

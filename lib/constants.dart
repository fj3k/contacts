// Type enums

class FieldType {
  static const UNKNOWN = 0;

  static const DATE = 1;
  static const TIME = 2;
  static const DATETIME = 3;

  static const BOOL = 4;
  static const CHECK = 5;
  static const OPT = 6;
  static const RADIO = 7;

  // type & 8 == 8 - render a textbox.
  static const TEXT = 8;
  static const RICH = 9;
  static const EMAIL = 10;
  static const URL = 11;

  // type & 12 == 12 - validate phone number.
  static const PHONE = 12;
  static const MOBILE = 13;
  static const FAX = 14;
  static const MODEM = 15;

  static const ADDRESS = 16;
  static const IMAGE = 17;
  static const ICON = 18;
}

class RelationshipType {
  static const UNKNOWN = 0;
  static const PARENT = 1;
  static const CHILD = 2;
  static const SIBLING = 4;
  static const PARTNER = 8;
  static const EXSPOUSE = 16;
  static const SPOUSE = 24;
}

//Database tables

abstract class DatabaseTable {
  final name = '';
  final idColumn = 'id';
  final columns = [];
}

class CirclesTable extends DatabaseTable {
  final name = 'circles';
  final columns = ['Name', 'Icon'];
}

class PeopleTable extends DatabaseTable {
  final name = 'people';
  final columns = ['Name', 'OnlineID'];
}

class DetailsTable extends DatabaseTable {
  final name = 'details';
  final columns = ['PersonID', 'Label', 'TypeID', 'Value'];
}

class MembershipsTable extends DatabaseTable {
  final name = 'memberships';
  final columns = ['PersonID', 'CircleID'];
}

class RelationshipsTable extends DatabaseTable {
  final name = 'relationships';
  final columns = ['PersonID', 'RelatedPersonID', 'RelationshipTypeID'];
}

class SettingsTable extends DatabaseTable {
  final name = 'settings';
  final columns = ['Key', 'TypeID', 'Value'];
}


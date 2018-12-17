-- Tables

CREATE TABLE circles (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	Name TEXT NOT NULL,
	Icon INTEGER,
	Rank INTEGER
);

CREATE TABLE people (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	OnlineID TEXT,
	PhoneID TEXT,
	Name TEXT NOT NULL,
	Avatar BLOB,
	TrustLevel SMALLINT
);

CREATE TABLE details (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	OnlineID TEXT,
	PersonID INTEGER NOT NULL,
	Label TEXT NOT NULL,
	TypeID INTEGER NOT NULL,
	Value TEXT,
	TrustLevel SMALLINT
);

CREATE TABLE memberships (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	PersonID INTEGER,
	CircleID INTEGER,
	Rank INTEGER
);

CREATE TABLE relationships (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	PersonID INTEGER,
	RelatedPersonID INTEGER,
	RelationshipTypeID INTEGER,
	TrustLevel SMALLINT
);

CREATE TABLE settings (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	Key TEXT NOT NULL,
	TypeID INTEGER NOT NULL,
	Value TEXT
);

CREATE TABLE defaultdetails (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	Label TEXT NOT NULL,
	TypeID INTEGER NOT NULL,
	Value TEXT,
	TrustLevel SMALLINT
);

-- Default data

INSERT INTO defaultdetails (id, Label, TypeID) VALUES
(1, 'Nickname', 4),
(2, 'Date of birth', 1),
(3, 'Address', 5),
(4, 'Home phone', 6),
(5, 'Mobile phone', 6),
(6, 'Work phone', 6),
(7, 'Email address', 7);

INSERT INTO people VALUES (0, 'Me', NULL, NULL);

INSERT INTO details (PersonID, Label, TypeID, Value, TrustLevel)
  SELECT 0 AS PersonID, dd.Label, dd.TypeID, dd.Value, dd.TrustLevel
    FROM defaultdetails dd;

INSERT INTO circles VALUES
(0, 'Family', 60107),
(1, 'Friends', 59985),
(2, 'Work', 60321),
(3, 'Organisations', 60295);

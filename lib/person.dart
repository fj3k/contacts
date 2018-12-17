import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:english_words/english_words.dart';

import 'main.dart';

class PersonWgtState extends State<PersonWgt> {
  final _suggestions = <WordPair>[];
  final _saved = new Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AOSContactsApp.appBar(context),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        // The itemBuilder callback is called once per suggested word pairing,
        // and places each suggestion into a ListTile row.
        // For even rows, the function adds a ListTile row for the word pairing.
        // For odd rows, the function adds a Divider widget to visually
        // separate the entries. Note that the divider may be difficult
        // to see on smaller devices.
        itemBuilder: (context, i) {
          // Add a one-pixel-high divider widget before each row in theListView.
          if (i.isOdd) return Divider();

          // The syntax "i ~/ 2" divides i by 2 and returns an integer result.
          // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
          // This calculates the actual number of word pairings in the ListView,
          // minus the divider widgets.
          final index = i ~/ 2;
          // If you've reached the end of the available word pairings...
          if (index >= _suggestions.length) {
            // ...then generate 10 more and add them to the suggestions list.
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blueGrey,
        child: Text(
            "${pair.first[0].toUpperCase()}${pair.second[0].toUpperCase()}"),
      ),
      // leading: CircleAvatar(
      //   backgroundImage: NetworkImage('https://devel.clients.lan.noggin.com.au/acockroft/contacts/pictures/acockroft.png')
      // ),
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.star : Icons.star_border,
        color: alreadySaved ? Colors.yellow[700] : null,
      ),
      onTap: () {
        UrlLauncher.launch("tel:+61405733764");
        // UrlLauncher.launch("sms:+61405733764");
      },
    );
  }
}

class PersonWgt extends StatefulWidget {
  @override
  PersonWgtState createState() => new PersonWgtState();
}

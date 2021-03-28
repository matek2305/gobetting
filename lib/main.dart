import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './model/IncomingMatch.dart';
import './model/MatchScore.dart';

void main() {
  runApp(GoBettingApp());
}

class GoBettingApp extends StatelessWidget {
  final List<IncomingMatch> _incomingMatches = [
    IncomingMatch(
      '1',
      'Chelsea',
      'Arsenal',
      DateTime.now().add(Duration(hours: 3)),
      null,
    ),
    IncomingMatch(
      '2',
      'Manchester United',
      'Manchester City',
      DateTime.now().add(Duration(hours: 12)),
      null,
    ),
    IncomingMatch(
      '3',
      'Polska',
      'Andora',
      DateTime.now().add(Duration(hours: 2)),
      MatchScore(4, 0),
    ),
  ];

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('GoBetting'),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListView.builder(
              itemBuilder: (_, index) =>
                  IncomingMatchWidget(_incomingMatches[index]),
              itemCount: _incomingMatches.length,
            ),
          ),
        ),
      ),
    );
  }
}

class IncomingMatchWidget extends StatelessWidget {
  final IncomingMatch _match;

  IncomingMatchWidget(this._match);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                IncomingMatchTeamWidget(_match.homeTeamName),
                IncomingMatchTeamWidget(_match.awayTeamName),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "?",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class IncomingMatchTeamWidget extends StatelessWidget {
  final String _name;

  IncomingMatchTeamWidget(this._name);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        _name,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

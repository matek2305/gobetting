import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './model/incoming_match.dart';
import './model/match_score.dart';

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
                  IncomingMatchCardWidget(_incomingMatches[index]),
              itemCount: _incomingMatches.length,
            ),
          ),
        ),
      ),
    );
  }
}

class IncomingMatchCardWidget extends StatelessWidget {
  final IncomingMatch _match;

  IncomingMatchCardWidget(this._match);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            IncomingMatchSideWidget(
              _match.homeTeamName,
              _match.bet?.homeTeam,
            ),
            Text(
              ':',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            IncomingMatchSideWidget(
              _match.awayTeamName,
              _match.bet?.awayTeam,
              true,
            ),
          ],
        ),
      ),
    );
  }
}

class IncomingMatchSideWidget extends StatelessWidget {
  final String _teamName;
  final int _teamGoals;
  final bool _reversed;

  IncomingMatchSideWidget(this._teamName, this._teamGoals,
      [this._reversed = false]);

  @override
  Widget build(BuildContext context) {
    var goalsCounterAfterTeamName = [
      Flexible(
        fit: FlexFit.tight,
        child: Text(
          _teamName,
          style: TextStyle(fontSize: 18),
          textAlign: _reversed ? TextAlign.left : TextAlign.right,
        ),
      ),
      GoalsCounterWidget(_teamGoals),
    ];

    return Expanded(
      child: Row(
        children: _reversed
            ? goalsCounterAfterTeamName.reversed.toList()
            : goalsCounterAfterTeamName,
      ),
    );
  }
}

class GoalsCounterWidget extends StatefulWidget {
  int _goals;

  GoalsCounterWidget(this._goals);

  @override
  _GoalsCounterWidgetState createState() => _GoalsCounterWidgetState();
}

class _GoalsCounterWidgetState extends State<GoalsCounterWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          padding: EdgeInsets.all(4),
          constraints: BoxConstraints(),
          icon: Icon(Icons.keyboard_arrow_up_rounded),
          onPressed: () => setState(() {
            widget._goals = widget._goals != null ? widget._goals + 1 : 0;
          }),
        ),
        Text(
          '${widget._goals ?? '?'}',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          padding: EdgeInsets.all(4),
          constraints: BoxConstraints(),
          icon: Icon(Icons.keyboard_arrow_down_rounded),
          onPressed: (widget._goals ?? 0) > 0
              ? () => setState(() => widget._goals -= 1)
              : null,
        ),
      ],
    );
  }
}

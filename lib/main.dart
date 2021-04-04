import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import './model/match.dart';
import 'model/state.dart';
import 'redux/actions.dart';
import 'redux/reducers.dart';

void main() => runApp(GoBettingApp());

final Store<GoBettingState> store = Store<GoBettingState>(
  goBettingStateReducer,
  initialState: GoBettingState.initial(),
);

class GoBettingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreProvider<GoBettingState>(
      store: store,
      child: CupertinoApp(
        home: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text('GoBetting'),
          ),
          child: SafeArea(
            child: Column(
              children: [
                StoreConnector<GoBettingState, List<IncomingMatch>>(
                  converter: (store) => store.state.incomingMatches,
                  builder: (_, matches) {
                    return Expanded(
                      child: ListView.builder(
                        itemBuilder: (_, index) =>
                            IncomingMatchCardWidget(matches[index]),
                        itemCount: matches.length,
                      ),
                    );
                  },
                ),
                StoreConnector<GoBettingState, bool>(
                  converter: (store) => store.state.unsavedBets.isNotEmpty,
                  builder: (_, hasUnsavedBets) {
                    return hasUnsavedBets
                        ? Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CupertinoButton(
                                      child: Text('Cancel'),
                                      onPressed: () {},
                                    ),
                                  ),
                                  Expanded(
                                    child: CupertinoButton.filled(
                                      child: Text('Save'),
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SizedBox.shrink();
                  },
                ),
              ],
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
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 8,
        child: Row(
          children: [
            TeamNameWidget(
              _match.homeTeamName,
              TextAlign.right,
            ),
            MatchScoreCounter(
              _match.bet,
              onChange: (score) =>
                  store.dispatch(ChangeBetAction(_match.matchId, score)),
            ),
            TeamNameWidget(_match.awayTeamName),
          ],
        ),
      ),
    );
  }
}

class TeamNameWidget extends StatelessWidget {
  final String _teamName;
  final TextAlign _textAlign;

  TeamNameWidget(this._teamName, [this._textAlign = TextAlign.left]);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Text(
              _teamName,
              style: TextStyle(fontSize: 18),
              textAlign: _textAlign,
            ),
          ),
        ],
      ),
    );
  }
}

class MatchScoreCounter extends StatelessWidget {
  MatchScore? _score;
  int? _homeTeamScore;
  int? _awayTeamScore;
  ValueSetter<MatchScore> _onChange;

  MatchScoreCounter(this._score,
      {ValueSetter<MatchScore> onChange = _onChangeNoop})
      : this._onChange = onChange,
        this._homeTeamScore = _score?.homeTeam,
        this._awayTeamScore = _score?.awayTeam;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GoalsCounterWidget(
          _score?.homeTeam,
          onChange: (score) {
            this._homeTeamScore = score;
            _notifyOnChangeListener();
          },
        ),
        Text(
          ':',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        GoalsCounterWidget(
          _score?.awayTeam,
          onChange: (score) {
            this._awayTeamScore = score;
            _notifyOnChangeListener();
          },
        ),
      ],
    );
  }

  void _notifyOnChangeListener() {
    if (_homeTeamScore != null && _awayTeamScore != null) {
      _onChange(MatchScore(_homeTeamScore!, _awayTeamScore!));
    }
  }

  static _onChangeNoop(MatchScore _) {}
}

class GoalsCounterWidget extends StatefulWidget {
  int? _goals;
  ValueSetter<int> _onChange;

  GoalsCounterWidget(this._goals, {ValueSetter<int> onChange = _onChangeNoop})
      : this._onChange = onChange;

  @override
  _GoalsCounterWidgetState createState() => _GoalsCounterWidgetState();

  static _onChangeNoop(int _) {}
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
          onPressed: () {
            setState(() =>
                widget._goals = widget._goals != null ? widget._goals! + 1 : 0);
            widget._onChange(widget._goals!);
          },
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
              ? () {
                  setState(() => widget._goals = widget._goals! - 1);
                  widget._onChange(widget._goals!);
                }
              : null,
        ),
      ],
    );
  }
}

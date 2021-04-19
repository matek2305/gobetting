import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../bets/actions.dart';
import '../matches/actions.dart';
import '../matches/model.dart';
import '../redux.dart';

class IncomingMatchesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('GoBetting'),
      ),
      child: SafeArea(
        child: StoreConnector<GoBettingState, _IncomingMatchesView>(
          onInit: (store) => store.dispatch(fetchIncomingMatches()),
          converter: (store) => _IncomingMatchesView.create(store),
          builder: (_, view) => Column(
            children: [
              if (view.hasError)
                Text(
                  view.error,
                  style: TextStyle(color: Colors.red),
                ),
              if (view.isFetching && view.matches.isEmpty) Text("loading ..."),
              if (view.noMatchesAvailable)
                Text("Currently there are no incoming matches"),
              if (view.matches.isNotEmpty)
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      CupertinoSliverRefreshControl(
                        onRefresh: () => Future.value(view.onRefresh()),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, index) {
                            final match = view.matches[index];
                            return IncomingMatchCardWidget(
                              match,
                              view.betFor(match.matchId),
                              view.unsavedBets.containsKey(match.matchId),
                              onScoreChange: (score) =>
                                  view.onBetChange(match.matchId, score),
                              onScoreReset: () =>
                                  view.onResetBet(match.matchId),
                            );
                          },
                          childCount: view.matches.length,
                        ),
                      )
                    ],
                  ),
                ),
              if (view.unsavedBets.isNotEmpty)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: CupertinoButton(
                            child: Text('Cancel'),
                            onPressed:
                                view.isSavingBets ? null : view.onResetBets,
                          ),
                        ),
                        Expanded(
                          child: CupertinoButton.filled(
                            child:
                                Text(view.isSavingBets ? 'Saving ...' : 'Save'),
                            onPressed:
                                view.isSavingBets ? null : view.onSaveBets,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class IncomingMatchCardWidget extends StatelessWidget {
  final IncomingMatch _match;
  final MatchScore? _bet;
  final bool _changed;
  final Function(MatchScore) _onScoreChange;
  final Function() _onScoreReset;

  IncomingMatchCardWidget(
    this._match,
    this._bet,
    this._changed, {
    onScoreReset = _onScoreResetNoop,
    onScoreChange = _onScoreChangeNoop,
  })  : this._onScoreChange = onScoreChange,
        this._onScoreReset = onScoreReset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Card(
        color: _changed ? Colors.yellow : Colors.white,
        elevation: 8,
        child: Row(
          children: [
            TeamNameWidget(
              _match.homeTeamName,
              TextAlign.right,
            ),
            MatchScoreCounter(_bet, onChange: (score) {
              if (score == _match.bet) {
                _onScoreReset();
              } else {
                _onScoreChange(score);
              }
            }),
            TeamNameWidget(_match.awayTeamName),
          ],
        ),
      ),
    );
  }

  static _onScoreResetNoop() {}

  static _onScoreChangeNoop(MatchScore _) {}
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
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                _teamName,
                style: TextStyle(fontSize: 18),
                textAlign: _textAlign,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MatchScoreCounter extends StatelessWidget {
  final MatchScore? _score;
  final ValueSetter<MatchScore> _onChange;

  int? _homeTeamScore;
  int? _awayTeamScore;

  MatchScoreCounter(
    this._score, {
    ValueSetter<MatchScore> onChange = _onChangeNoop,
  })  : this._onChange = onChange,
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
  final ValueSetter<int> _onChange;
  int? _goals;

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

class _IncomingMatchesView {
  final List<IncomingMatch> matches;
  final Map<String, MatchScore> unsavedBets;
  final Function(String, MatchScore) onBetChange;
  final Function() onSaveBets;
  final Function(String) onResetBet;
  final Function() onResetBets;
  final Function() onRefresh;
  final bool isFetching;
  final bool isSavingBets;
  final dynamic error;

  bool get hasError => error != null;

  bool get noMatchesAvailable => matches.isEmpty && !isFetching;

  Map<String, IncomingMatch> get _matchesById {
    return Map.fromIterable(matches, key: (match) => match.matchId);
  }

  _IncomingMatchesView({
    required this.matches,
    required this.unsavedBets,
    required this.onBetChange,
    required this.onSaveBets,
    required this.onResetBet,
    required this.onResetBets,
    required this.onRefresh,
    required this.isFetching,
    required this.isSavingBets,
    required this.error,
  });

  MatchScore? betFor(String matchId) {
    return unsavedBets[matchId] ?? _matchesById[matchId]?.bet;
  }

  factory _IncomingMatchesView.create(Store<GoBettingState> store) {
    _onBetChange(String matchId, MatchScore bet) {
      store.dispatch(ChangeBetAction(matchId, bet));
    }

    _onSaveBets() {
      store.dispatch(saveBets());
    }

    _onResetBet(String matchId) {
      store.dispatch(ResetBetAction(matchId));
    }

    _onResetBets() {
      store.dispatch(ResetBetsAction());
    }

    _onRefresh() {
      store.dispatch(fetchIncomingMatches());
    }

    return _IncomingMatchesView(
      matches: store.state.incomingMatches.data,
      unsavedBets: store.state.unsavedBets.data,
      onBetChange: _onBetChange,
      onSaveBets: _onSaveBets,
      onResetBet: _onResetBet,
      onResetBets: _onResetBets,
      onRefresh: _onRefresh,
      isFetching: store.state.incomingMatches.loading,
      isSavingBets: store.state.unsavedBets.saving,
      error: store.state.incomingMatches.error ?? store.state.unsavedBets.error,
    );
  }
}

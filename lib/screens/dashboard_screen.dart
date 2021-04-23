import 'package:flutter/cupertino.dart';

import 'incoming_matches_screen.dart';

class DashboardScreen extends StatelessWidget {
  static const _BET_TAB = 0;
  static const _POINTS_TAB = 1;
  static const _LEADERS_TAB = 2;

  static final Map<int, Widget Function()> _contentMap = {
    _BET_TAB: () => IncomingMatchesScreen(),
    _POINTS_TAB: () => Text("Points"),
    _LEADERS_TAB: () => Text("Leaders"),
  };

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(items: [
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.sportscourt_fill),
          label: 'Bet',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.checkmark_alt),
          label: 'Points',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.chart_bar_alt_fill),
          label: 'Leaders',
        ),
      ]),
      tabBuilder: (_, index) {
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text('GoBetting'),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 8.0,
              ),
              child: _contentMap[index]!(),
            ),
          ),
        );
      },
    );
  }
}

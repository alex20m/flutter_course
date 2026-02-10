import 'package:flutter/material.dart';

enum AppDestination {
  dashboard('/', 'Overview', Icons.dashboard_outlined),
  transactions('/transactions', 'Transactions', Icons.list_alt_outlined),
  stats('/stats', 'Statistics', Icons.insights_outlined);

  const AppDestination(this.path, this.label, this.icon);

  final String path;
  final String label;
  final IconData icon;
}

class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({
    required this.destination,
    required this.child,
    super.key,
  });

  final AppDestination destination;
  final Widget child;

  int get _selectedIndex => AppDestination.values.indexOf(destination);

  void _onDestinationSelected(BuildContext context, int index) {
    final AppDestination dest = AppDestination.values[index];
    if (ModalRoute.of(context)?.settings.name == dest.path) {
      return;
    }
    Navigator.of(context).pushReplacementNamed(dest.path);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool useRail = constraints.maxWidth >= 700;

        final Widget centeredBody = Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ),
        );

        if (useRail) {
          return Scaffold(
            body: Row(
              children: <Widget>[
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) =>
                      _onDestinationSelected(context, index),
                  labelType: NavigationRailLabelType.all,
                  destinations: AppDestination.values
                      .map<NavigationRailDestination>(
                        (AppDestination dest) => NavigationRailDestination(
                          icon: Icon(dest.icon),
                          label: Text(dest.label),
                        ),
                      )
                      .toList(),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: centeredBody),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Personal Finance Tracker'),
          ),
          body: centeredBody,
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) =>
                _onDestinationSelected(context, index),
            destinations: AppDestination.values
                .map<NavigationDestination>(
                  (AppDestination dest) => NavigationDestination(
                    icon: Icon(dest.icon),
                    label: dest.label,
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}


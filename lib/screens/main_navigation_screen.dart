import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import 'live_view_screen.dart';
import 'on_deck_screen.dart';
import 'facilities_screen.dart';
import 'players_screen.dart';
import 'sessions_screen.dart';
import 'walkthrough/walkthrough_coordinator.dart';
import 'settings_screen.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const LiveViewScreen(),
    const OnDeckScreen(),
    const FacilitiesScreen(),
    const PlayersScreen(),
    const SessionsScreen(),
  ];

  final List<NavigationDestination> _destinations = [
    const NavigationDestination(
      icon: Icon(Icons.live_tv),
      selectedIcon: Icon(Icons.live_tv),
      label: 'Live View',
      tooltip: 'Current session activity',
    ),
    const NavigationDestination(
      icon: Icon(Icons.queue),
      selectedIcon: Icon(Icons.queue),
      label: 'Queue',
      tooltip: 'Player queue and live matches',
    ),
    const NavigationDestination(
      icon: Icon(Icons.business),
      selectedIcon: Icon(Icons.business),
      label: 'Facilities',
      tooltip: 'Manage facilities and courts',
    ),
    const NavigationDestination(
      icon: Icon(Icons.people),
      selectedIcon: Icon(Icons.people),
      label: 'Players',
      tooltip: 'Player database',
    ),
    const NavigationDestination(
      icon: Icon(Icons.history),
      selectedIcon: Icon(Icons.history),
      label: 'Sessions',
      tooltip: 'Historical data',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Get Started button for new users
          IconButton(
            icon: const Icon(Icons.rocket_launch),
            tooltip: l10n.getStartedTooltip,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const WalkthroughCoordinator(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: l10n.language,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: _destinations,
        elevation: 8,
        height: 80,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }
}
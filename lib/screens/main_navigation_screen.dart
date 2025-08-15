import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/enhanced_providers.dart';
import '../l10n/app_localizations.dart';
import '../widgets/common/global_message_widget.dart';
import 'live_view_screen.dart';
import 'on_deck_screen.dart';
import 'facilities_screen.dart';
import 'players_screen.dart';
import 'sessions_screen.dart';
import 'progressive_walkthrough_screen.dart';
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
    final facilities = ref.watch(facilitiesProvider);
    final players = ref.watch(enhancedPlayersProvider);
    final currentSession = ref.watch(currentSessionProvider);
    
    // Check if we need to show walkthrough
    final needsWalkthrough = facilities.isEmpty ||
                           players.length < 2 ||
                           currentSession == null;
    
    if (needsWalkthrough) {
      return const ProgressiveWalkthroughScreen();
    }
    
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings),
            tooltip: l10n.settings,
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'settings',
                child: Row(
                  children: [
                    const Icon(Icons.language),
                    const SizedBox(width: 12),
                    Text(l10n.settings),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          const GlobalMessageWidget(),
        ],
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
import 'package:flutter/material.dart';

// Import your pages:
import 'package:urbaneat/screens/menu.dart';
import 'package:urbaneat/leaderboards/leaderboard_page.dart';

// Create placeholders for the other pages if they don't exist yet
class ForYouPage extends StatelessWidget {
  const ForYouPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('For You Page')),
    );
  }
}

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Account Page')),
    );
  }
}

class RootWidget extends StatefulWidget {
  const RootWidget({Key? key}) : super(key: key);

  @override
  State<RootWidget> createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  // This keeps track of which tab is selected
  int _selectedIndex = 0;

  // Here are the pages in the order you want them in the bottom nav
  final List<Widget> _pages = [
    const MyHomePage(),         // Your existing homepage
    const LeaderboardPage(),    // Leaderboard page
    const ForYouPage(),
    const AccountPage(),
  ];

  // This function is called when a user taps on a bottom-nav item
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Show whichever page is currently selected
      body: _pages[_selectedIndex],

      // The bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,    // Customize colors to your liking
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thumb_up),
            label: 'For You',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

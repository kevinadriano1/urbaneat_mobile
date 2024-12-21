import 'package:flutter/material.dart';
import 'package:urbaneat/restaurant/screens/list_foodentry.dart';
import 'package:urbaneat/screens/menu.dart';
import '../add_edit_resto/services/user_role_service.dart';
import 'package:urbaneat/leaderboards/leaderboard_page.dart';
import 'package:urbaneat/leaderboards/recommendations_page.dart';
import '../add_edit_resto/screens/add_resto.dart';
import 'package:urbaneat/user_roles/profile.dart';

class LeftDrawer extends StatefulWidget {
  const LeftDrawer({super.key});

  @override
  _LeftDrawerState createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _fetchUserRole(); // Fetch the user role when the drawer is initialized
  }

  // Fetch the user role from UserRoleService
  Future<void> _fetchUserRole() async {
    String userRole = await UserRoleService.fetchUserRole();
    setState(() {
      _userRole = userRole;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Column(
              children: [
                Text(
                  'URBANEATS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(8)),
                Text(
                  "Search The Most Scrumptious Restaurants Here!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home Page'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(),
                  ));
            },
          ),
          // Only show "Add Restaurant" if the user role is Restaurant_Manager
          if (_userRole == 'Restaurant_Manager')
            ListTile(
              leading: const Icon(Icons.mood),
              title: const Text('Add Restaurant'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddRestaurantForm(),
                  ),
                );
              },
            ),
          ListTile(
            leading: const Icon(Icons.add_reaction_rounded),
            title: const Text('Restaurant List'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FoodEntryPage(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.leaderboard),
            title: const Text('Leaderboard'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LeaderboardPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.recommend),
            title: const Text('Your Recommendations'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RecommendationsPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserRoles(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

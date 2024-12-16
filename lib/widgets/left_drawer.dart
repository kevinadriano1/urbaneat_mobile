import 'package:flutter/material.dart';
import 'package:urbaneat/restaurant/screens/list_foodentry.dart';
import 'package:urbaneat/screens/menu.dart';
import 'package:urbaneat/screens/moodentry_form.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

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
                  textAlign: TextAlign.center, // Center alignment
                  style: TextStyle(
                    fontSize: 15.0, // Font size 15
                    color: Colors.white, // White color
                    fontWeight: FontWeight.normal, // Normal weight
                  ),
                ),
              ],
            ),
          ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home Page'),
              // Redirection part to MyHomePage
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.mood),
              title: const Text('Add Mood'),
              // Redirection part to MoodEntryFormPage
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MoodEntryFormPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_reaction_rounded),
              title: const Text('Mood List'),
              onTap: () {
                  // Route to the mood page
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FoodEntryPage()),
                  );
              },
          ),
        ],
      ),
    );
  }
}
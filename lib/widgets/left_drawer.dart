import 'package:flutter/material.dart';
import 'package:urbaneat/screens/list_foodentry.dart';
import 'package:urbaneat/screens/menu.dart';
import 'package:urbaneat/screens/moodentry_form.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              children: [
                Text(
                  'Mental Health Tracker',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(8)),
                Text(
                  "Track your mental health every day here!",
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
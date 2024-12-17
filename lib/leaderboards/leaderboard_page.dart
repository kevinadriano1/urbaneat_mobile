import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'leaderboard_service.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  late LeaderboardService service;
  Map<String, dynamic> leaderboard = {};

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    service = LeaderboardService(request);
    fetchLeaderboardData();
  }

  void fetchLeaderboardData() async {
    final data = await service.fetchLeaderboard();
    setState(() {
      leaderboard = data['leaderboard'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: leaderboard.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: leaderboard.keys.map((foodType) {
                return ExpansionTile(
                  title: Text(foodType),
                  children: (leaderboard[foodType] as List).map((restaurant) {
                    return ListTile(
                      title: Text(restaurant['name']),
                      subtitle: Text(
                          "Rating: ${restaurant['avg_rating']} | Location: ${restaurant['location']}"),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
    );
  }
}

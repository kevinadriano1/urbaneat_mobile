import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'leaderboard_service.dart';

class RecommendationsPage extends StatefulWidget {
  const RecommendationsPage({super.key});

  @override
  State<RecommendationsPage> createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage> {
  late LeaderboardService service;
  List recommendations = [];

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    service = LeaderboardService(request);
    fetchRecommendations();
  }

  void fetchRecommendations() async {
    final data = await service.fetchUserRecommendations();
    setState(() {
      recommendations = data['recommendations'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Recommendations')),
      body: recommendations.isEmpty
          ? const Center(child: Text("No recommendations available."))
          : ListView.builder(
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                final restaurant = recommendations[index];
                return ListTile(
                  title: Text(restaurant['name']),
                  subtitle: Text(
                      "Rating: ${restaurant['avg_rating']} | Food Type: ${restaurant['food_type']}"),
                );
              },
            ),
    );
  }
}

import 'package:pbp_django_auth/pbp_django_auth.dart';

class LeaderboardService {
  final CookieRequest request;

  LeaderboardService(this.request);

  Future<Map<String, dynamic>> fetchLeaderboard() async {
    final response = await request.get(
      'https://kevin-adriano-urbaneat2.pbp.cs.ui.ac.id', // Replace with API URL
    );
    return response;
  }

  Future<Map<String, dynamic>> fetchUserRecommendations() async {
    final response = await request.get(
      'https://kevin-adriano-urbaneat2.pbp.cs.ui.ac.id',
    );
    return response;
  }
}

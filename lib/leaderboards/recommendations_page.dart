import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'leaderboard_service.dart';
import 'package:urbaneat/restaurant/screens/restaurantdetail.dart'; // Import the RestaurantDetailPage

class RecommendationsPage extends StatefulWidget {
  const RecommendationsPage({super.key});

  @override
  State<RecommendationsPage> createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage> {
  late LeaderboardService service;
  List recommendations = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize the service once dependencies are available
    final request = Provider.of<CookieRequest>(context, listen: false);
    service = LeaderboardService(request);
    fetchRecommendations();
  }

  Future<void> fetchRecommendations() async {
    try {
      final data = await service.fetchUserRecommendations();
      setState(() {
        recommendations = data['recommendations'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
      // Optionally, log the error or show a snackbar
      // For example:
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Failed to load recommendations')),
      // );
      debugPrint('Error fetching recommendations: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define a white and black theme
    final ThemeData theme = ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 2,
      ),
      cardColor: Colors.white,
      shadowColor: Colors.grey,
      textTheme: const TextTheme(
        headlineSmall: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        bodyMedium: TextStyle(color: Colors.black87, fontSize: 16),
      ),
      iconTheme: const IconThemeData(color: Colors.black54),
      // Optionally, define other theme properties here
    );

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your Recommendations'),
          centerTitle: true,
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            : hasError
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "An error occurred while fetching recommendations.",
                        style: TextStyle(fontSize: 18, color: Colors.redAccent),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : recommendations.isEmpty
                    ? const Center(
                        child: Text(
                          "No recommendations available.",
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: recommendations.length,
                          itemBuilder: (context, index) {
                            final restaurant = recommendations[index];
                            String restaurantId = '';
                            if (restaurant.containsKey('id')) {
                              restaurantId = restaurant['id'].toString();
                            } else if (restaurant.containsKey('restaurant_id')) {
                              restaurantId = restaurant['restaurant_id'].toString();
                            }

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 4.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Make the restaurant name tappable
                                    InkWell(
                                      onTap: restaurantId.isNotEmpty
                                          ? () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => RestaurantDetailPage(
                                                      restaurantId: restaurantId),
                                                ),
                                              ).then((value) {
                                                if (value == true) {
                                                  _refreshDetails();
                                                }
                                              });
                                            }
                                          : null,
                                      child: Text(
                                        restaurant['name'],
                                        style: theme.textTheme.headlineSmall?.copyWith(
                                          color: restaurantId.isNotEmpty
                                              ? Colors.black
                                              : Colors.grey,
                                          decoration: restaurantId.isNotEmpty
                                              ? TextDecoration.underline
                                              : TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.star, size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          "${restaurant['avg_rating']}",
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                        const SizedBox(width: 16),
                                        const Icon(Icons.fastfood, size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          restaurant['food_type'],
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Location: ${restaurant['location']}",
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                    // Optionally, add more details or actions here
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
      ),
    );
  }

  // Optional: Refresh recommendations when returning from detail page
  void _refreshDetails() {
    setState(() {
      fetchRecommendations();
    });
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'leaderboard_service.dart';
import 'package:urbaneat/restaurant/screens/restaurantdetail.dart'; // Import the RestaurantDetailPage

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  late LeaderboardService service;
  Map<String, dynamic> leaderboard = {};
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    service = LeaderboardService(request);
    fetchLeaderboardData();
  }

  Future<void> fetchLeaderboardData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final data = await service.fetchLeaderboard();
      setState(() {
        leaderboard = data['leaderboard'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load leaderboard. Please try again.';
        isLoading = false;
      });
    }
  }

  // Widget to display star ratings
  Widget buildStarRating(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    for (int i = 0; i < 5; i++) {
      if (i < fullStars) {
        stars.add(const Icon(Icons.star, color: Colors.grey, size: 20));
      } else if (i == fullStars && hasHalfStar) {
        stars.add(const Icon(Icons.star_half, color: Colors.grey, size: 20));
      } else {
        stars.add(const Icon(Icons.star_border, color: Colors.grey, size: 20));
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: stars,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define custom TextStyles with monochrome colors
    const titleStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    const subtitleStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.grey,
    );

    const bodyStyle = TextStyle(
      fontSize: 14,
      color: Colors.black54,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        centerTitle: true,
        backgroundColor: Colors.black, // Changed to black
        iconTheme: const IconThemeData(color: Colors.white), // Icon color white
        titleTextStyle: const TextStyle(
          color: Colors.white, // Title text color white
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchLeaderboardData,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : leaderboard.isEmpty
                    ? const Center(
                        child: Text(
                          'No data available.',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: leaderboard.keys.length,
                        itemBuilder: (context, index) {
                          String foodType = leaderboard.keys.elementAt(index);
                          List<dynamic> restaurants = leaderboard[foodType];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Card(
                              color: Colors.white, // Card background white
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.grey.shade300),
                              ),
                              child: ExpansionTile(
                                leading: const Icon(
                                  Icons.restaurant,
                                  color: Colors.black, // Icon color black
                                  size: 30,
                                ),
                                title: Text(
                                  foodType,
                                  style: titleStyle,
                                ),
                                children: restaurants.map((restaurant) {
                                  // Safely parse avg_rating
                                  double rating = 0.0;
                                  var avgRating = restaurant['avg_rating'];
                                  if (avgRating is num) {
                                    rating = avgRating.toDouble();
                                  } else if (avgRating is String) {
                                    rating = double.tryParse(avgRating) ?? 0.0;
                                  }

                                  // Retrieve restaurantId
                                  String restaurantId = '';
                                  if (restaurant.containsKey('id')) {
                                    restaurantId = restaurant['id'].toString();
                                  } else if (restaurant.containsKey('restaurant_id')) {
                                    restaurantId = restaurant['restaurant_id'].toString();
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: Card(
                                      color: Colors.grey.shade100, // Light gray background
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(color: Colors.grey.shade300),
                                      ),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.grey.shade300,
                                          child: const Icon(
                                            Icons.location_city,
                                            color: Colors.black,
                                          ),
                                        ),
                                        title: InkWell(
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
                                            style: subtitleStyle.copyWith(
                                              color: restaurantId.isNotEmpty
                                                  ? Colors.black
                                                  : Colors.grey,
                                              decoration: restaurantId.isNotEmpty
                                                  ? TextDecoration.underline
                                                  : TextDecoration.none,
                                            ),
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Rating: ${rating.toStringAsFixed(1)}",
                                                  style: bodyStyle,
                                                ),
                                                const Spacer(),
                                                buildStarRating(rating),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "Location: ${restaurant['location']}",
                                              style: bodyStyle,
                                            ),
                                          ],
                                        ),
                                        isThreeLine: true,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchLeaderboardData,
        tooltip: 'Refresh',
        backgroundColor: Colors.black, // Changed to black
        child: const Icon(Icons.refresh, color: Colors.white), // Icon color white
      ),
    );
  }

  void _refreshDetails() {
    setState(() {
      fetchLeaderboardData();
    });
  }
}

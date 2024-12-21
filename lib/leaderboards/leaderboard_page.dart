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
        stars.add(const Icon(Icons.star, color: Colors.amber, size: 20));
      } else if (i == fullStars && hasHalfStar) {
        stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 20));
      } else {
        stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 20));
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: stars,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define custom TextStyles
    const titleStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );

    const subtitleStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black54,
    );

    const bodyStyle = TextStyle(
      fontSize: 14,
      color: Colors.black54,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
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
                        style: TextStyle(
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
                          style: TextStyle(fontSize: 18),
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
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ExpansionTile(
                                leading: Icon(
                                  Icons.restaurant,
                                  color: Colors.blueGrey,
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
                                  // Adjust the key based on your data structure
                                  String restaurantId = '';
                                  if (restaurant.containsKey('id')) {
                                    restaurantId = restaurant['id'].toString();
                                  } else if (restaurant.containsKey('restaurant_id')) {
                                    restaurantId = restaurant['restaurant_id'].toString();
                                  } else {
                                    // Handle cases where the ID field is missing
                                    // You can choose to skip this restaurant or assign a default value
                                    // For this example, we'll skip navigation if ID is missing
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: Card(
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.blueGrey.shade100,
                                          child: Icon(
                                            Icons.location_city,
                                            color: Colors.blueGrey,
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
                                                  ? Colors.blue
                                                  : Colors.black54,
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
                                        // Removed the trailing star icon as it's now redundant
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
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void _refreshDetails() {
    setState(() {
      fetchLeaderboardData();
    });
  }
}

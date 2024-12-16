import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:urbaneat/restaurant/services/api_service.dart';
import 'package:urbaneat/restaurant/screens/addreviewpage.dart';
import 'package:urbaneat/widgets/left_drawer.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetailPage({super.key, required this.restaurantId});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  late ApiService apiService;
  late Future<Map<String, dynamic>> _restaurantDetails;

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    apiService = ApiService(request);
    _restaurantDetails = apiService.fetchRestaurantDetails(widget.restaurantId);
  }

  void _refreshDetails() {
    setState(() {
      _restaurantDetails = apiService.fetchRestaurantDetails(widget.restaurantId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Details'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: _restaurantDetails,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text('No details available.'),
            );
          } else {
            final restaurant = snapshot.data;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant['name'],
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text("Address: ${restaurant['street_address']}"),
                  const SizedBox(height: 8),
                  Text("Location: ${restaurant['location']}"),
                  const SizedBox(height: 8),
                  Text("Food Type: ${restaurant['food_type']}"),
                  const SizedBox(height: 8),
                  restaurant['image_url'] != 'N/A'
                      ? Image.network(
                          restaurant['image_url'],
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : const Text('No image available'),
                  const SizedBox(height: 16),
                  Text(
                    "Contact Number: ${restaurant['contact_number']}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      final url = restaurant['trip_advisor_url'];
                      if (url != null && url.isNotEmpty) {
                        // Launch the TripAdvisor URL using url_launcher package
                      }
                    },
                    child: Text(
                      "TripAdvisor: ${restaurant['trip_advisor_url']}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Menu: ${restaurant['menu_info']}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Reviews",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ...restaurant['reviews'].map<Widget>((review) {
                    return ListTile(
                      title: Text(review['comment']),
                      subtitle: Text("Rating: ${review['rating']}"),
                      trailing: Text("By: ${review['user__username']}"),
                    );
                  }).toList(),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddReviewPage(restaurantId: widget.restaurantId),
                        ),
                      ).then((value) {
                        if (value == true) {
                          _refreshDetails();
                        }
                      });
                    },
                    child: const Text('Add Review'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

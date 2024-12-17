import 'package:flutter/material.dart';
import 'package:urbaneat/add_edit_resto/screens/edit_resto.dart';
import 'package:urbaneat/restaurant/services/api_service.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:urbaneat/restaurant/screens/restaurantdetail.dart';
import 'package:urbaneat/widgets/left_drawer.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FoodEntryPage extends StatefulWidget {
  const FoodEntryPage({super.key});

  @override
  State<FoodEntryPage> createState() => _FoodEntryPageState();
}

class _FoodEntryPageState extends State<FoodEntryPage> {
  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    apiService = ApiService(request);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Entry List'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: apiService.fetchFoodEntries(),
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
          } else if (!snapshot.hasData || snapshot.data.isEmpty) {
            return const Center(
              child: Text(
                'No food entries available.',
                style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (_, index) {
                final food = snapshot.data[index];
                return FoodCard(
                  food: food,
                  apiService: apiService,
                );
              },
            );
          }
        },
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  const FoodCard({
    super.key,
    required this.food,
    required this.apiService,
  });

  final dynamic food;
  final ApiService apiService;

  // Function to delete the restaurant
  Future<void> _deleteRestaurant(BuildContext context) async {
    try {
      final response = await apiService.deleteRestaurant(food.pk);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete restaurant: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RestaurantDetailPage(
                    restaurantId: food.pk,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.fields.name,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("Address: ${food.fields.streetAddress}"),
                  const SizedBox(height: 8),
                  Text("Location: ${food.fields.location}"),
                  const SizedBox(height: 8),
                  Text("Food Type: ${food.fields.foodType}"),
                  const SizedBox(height: 8),
                  Text(
                    "Average Rating: ${food.fields.avgRating}",
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  food.fields.imageUrl.isNotEmpty
                      ? Image.network(
                          food.fields.imageUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : const Text('No image available'),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  tooltip: 'Edit Restaurant',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditRestaurantForm(id: food.pk),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Delete Restaurant',
                  onPressed: () async {
                    await _deleteRestaurant(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

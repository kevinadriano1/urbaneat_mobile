import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:urbaneat/restaurant/models/food_entry.dart';

class ApiService {
  final CookieRequest request;
  final String _baseUrl = 'https://kevin-adriano-urbaneat2.pbp.cs.ui.ac.id';
  

  ApiService(this.request);

  // Fetch list of food entries
  Future<List<FoodEntry>> fetchFoodEntries() async {
    try {
      final response = await request.get('$_baseUrl/json/');
      var data = response;

      List<FoodEntry> listFood = [];
      for (var d in data) {
        if (d != null) {
          listFood.add(FoodEntry.fromJson(d));
        }
      }
      return listFood;
    } catch (e) {
      throw Exception('Failed to load food entries: $e');
    }
  }

  // Fetch restaurant details by ID
  Future<Map<String, dynamic>> fetchRestaurantDetails(String restaurantId) async {
    try {
      final response = await request.get('$_baseUrl/reviews/restaurant/$restaurantId/');
      return response;
    } catch (e) {
      throw Exception('Failed to fetch restaurant details: $e');
    }
  }

  // Add a review to a restaurant
  Future<Map<String, dynamic>> addReview(
      String restaurantId, double rating, String comment) async {
    try {
      final response = await request.postJson(
        "$_baseUrl/reviews/restaurant/$restaurantId/add_review_flutter/",
        jsonEncode(<String, dynamic>{
          'rating': rating.toString(),
          'comment': comment,
        }),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to add review: $e');
    }
  }
}

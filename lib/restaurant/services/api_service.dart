import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:urbaneat/restaurant/models/food_entry.dart';
import 'package:urbaneat/env.dart';

class ApiService {
  final CookieRequest request;
  //final String _baseUrl = 'https://kevin-adriano-urbaneat2.pbp.cs.ui.ac.id';
  final String _baseUrl = Env.backendUrl;


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
  Future<Map<String, dynamic>> fetchRestaurantDetails(
      String restaurantId) async {
    try {
      final response =
          await request.get('$_baseUrl/reviews/restaurant/$restaurantId/');
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

  // Function to create a new restaurant
  Future<Map<String, dynamic>> createRestaurant(
      Map<String, dynamic> restaurantData) async {
    try {
      final response = await request.postJson(
        "$_baseUrl/admin_role/create_resto_api/",
        jsonEncode(restaurantData),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to create restaurant: $e');
    }
  }

  // Fetch restaurant details for editing
  Future<Map<String, dynamic>> getEditRestaurantDetails(String id) async {
    try {
      final response =
          await request.get('$_baseUrl/admin_role/edit_resto_api/$id/');
      return response;
    } catch (e) {
      throw Exception('Failed to fetch restaurant for editing: $e');
    }
  }

  // Submit updated restaurant data
  Future<Map<String, dynamic>> updateRestaurant(
      String id, Map<String, dynamic> restaurantData) async {
    try {
      final response = await request.postJson(
        '$_baseUrl/admin_role/edit_resto_api/$id/',
        jsonEncode(restaurantData),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to update restaurant: $e');
    }
  }

  Future<String> deleteRestaurant(String restaurantId) async {
    final url = Uri.parse('$_baseUrl/admin_role/delete_resto_api/$restaurantId/');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        return 'Restaurant deleted successfully'; // Success message
      } else {
        return 'Failed to delete restaurant. Please try again.'; // Failure message
      }
    } catch (e) {
      return 'An error occurred while deleting the restaurant.'; // Error message
    }
  }
}

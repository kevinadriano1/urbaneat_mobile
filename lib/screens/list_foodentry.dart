import 'package:flutter/material.dart';
import 'package:urbaneat/models/food_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:urbaneat/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class FoodEntryPage extends StatefulWidget {
  const FoodEntryPage({super.key});

  @override
  State<FoodEntryPage> createState() => _FoodEntryPageState();
}

class _FoodEntryPageState extends State<FoodEntryPage> {
  Future<List<FoodEntry>> fetchFoodEntries(CookieRequest request) async {
    // Fetch data from the endpoint (ensure the trailing slash is present!)
    final response = await request.get('http://localhost:8000/json/');

    // Decode the response into JSON
    var data = response;

    // Convert JSON data into a list of FoodEntry objects
    List<FoodEntry> listFood = [];
    for (var d in data) {
      if (d != null) {
        listFood.add(FoodEntry.fromJson(d));
      }
    }
    return listFood;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Entry List'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchFoodEntries(request),
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
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(20.0),
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
                      // Display the image
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
                );
              },
            );
          }
        },
      ),
    );
  }
}

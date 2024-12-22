import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbaneat/add_edit_resto/screens/edit_resto.dart';
import 'package:urbaneat/restaurant/services/api_service.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:urbaneat/restaurant/screens/restaurantdetail.dart';
import 'package:urbaneat/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

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

class FoodCard extends StatefulWidget {
  const FoodCard({
    super.key,
    required this.food,
    required this.apiService,
  });

  final dynamic food;
  final ApiService apiService;

  @override
  FoodCardState createState() => FoodCardState();
}

class FoodCardState extends State<FoodCard> {
  String? _userRole;

  Future<void> _fetchUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userRole = prefs.getString('userRole') ?? 'User';
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
  }

  Future<void> _deleteRestaurant(BuildContext context) async {
    try {
      final response = await widget.apiService.deleteRestaurant(widget.food.pk);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete restaurant: $e')),
      );
    }
  }

  List<Widget> _buildGenreStickers(String foodType) {
    final genres = foodType.split(',').map((genre) => genre.trim()).take(3);
    final colors = [Colors.orange, Colors.yellow, Colors.blue];
    return genres.map((genre) {
      final color = colors[genres.toList().indexOf(genre) % colors.length];
      return Container(
        margin: const EdgeInsets.only(right: 4.0, bottom: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Text(
          genre,
          style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.w600),
        ),
      );
    }).toList();
  }

 @override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RestaurantDetailPage(
            restaurantId: widget.food.pk,
          ),
        ),
      );
    },
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image on the left
                Container(
                  width: MediaQuery.of(context).size.width / 6,
                  height: double.infinity,
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                    ),
                  ),
                  child: widget.food.fields.imageUrl.isNotEmpty
                      ? Image.network(
                          widget.food.fields.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/placeholder.png', // Path to your placeholder image
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Text(
                              'No image',
                              style: TextStyle(fontSize: 10.0),
                            ),
                          ),
                        ),
                ),

                // Content on the right
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0), // Reduced padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.food.fields.name,
                          style: const TextStyle(
                            fontSize: 14, // Smaller font size
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1, // Limit to 1 line
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${widget.food.fields.streetAddress}, ${widget.food.fields.location}",
                          style: const TextStyle(fontSize: 12),
                          maxLines: 2, // Limit to 2 lines
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 4, // Reduce spacing between genres
                          children: _buildGenreStickers(widget.food.fields.foodType),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.yellow, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              "${widget.food.fields.avgRating} ",
                              style: const TextStyle(
                                fontSize: 12, // Smaller font size
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const Text(
                              "rating",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_userRole == 'Restaurant_Manager')
            Positioned(
              top: 0, // Reduced spacing
              right: 0,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue, size: 12), // Smaller icons
                    tooltip: 'Edit Restaurant',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditRestaurantForm(id: widget.food.pk),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 12), // Smaller icons
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
    ),
  );
}
}

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
        margin: const EdgeInsets.only(right: 8.0, bottom: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Text(
          genre,
          style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
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
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // image on the left
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
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ),
                          ),
                  ),

                  // content on the right
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.food.fields.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "${widget.food.fields.streetAddress}, ",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                TextSpan(
                                  text: widget.food.fields.location,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            children: _buildGenreStickers(
                                widget.food.fields.foodType),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.yellow, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                "${widget.food.fields.avgRating} ",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const Text(
                                "rating",
                                style: TextStyle(
                                  fontSize: 16,
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
                            builder: (_) =>
                                EditRestaurantForm(id: widget.food.pk),
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
      ),
    );
  }
}

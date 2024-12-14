import 'package:flutter/material.dart';
import 'package:urbaneat/widgets/left_drawer.dart';
import 'package:urbaneat/screens/list_foodentry.dart';
import 'package:urbaneat/screens/moodentry_form.dart';
import 'package:urbaneat/models/food_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:urbaneat/screens/restaurantdetail.dart';
import 'package:provider/provider.dart';

class ItemHomepage {
  final String name;
  final IconData icon;

  ItemHomepage(this.name, this.icon);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String npm = '5000000000'; // NPM
  final String name = 'Gedagedi Gedagedago'; // Name
  final String className = 'PBP S'; // Class

  final List<ItemHomepage> items = [
    ItemHomepage("View Restaurant", Icons.mood),
    ItemHomepage("Add Restaurant", Icons.add),
    ItemHomepage("Logout", Icons.logout),
  ];

  final TextEditingController searchController = TextEditingController();
  final List<String> filters = [
    "Asian", "Italian", "American", "Seafood", "Vegan", "Chinese", "Japanese", "Mexican", "American", "Indian", "Thai", "French", "Spanish", "Korean", "Mediterranean"
  ];
  String selectedFilter = "";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'URBANEATS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, Paul',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Where to go?',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 24.0,
                    backgroundImage: AssetImage('assets/profile_pic.jpg'), // Replace with your image
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Wrap(
                        children: filters.map((filter) {
                          return ListTile(
                            title: Text(filter),
                            onTap: () {
                              setState(() {
                                selectedFilter = filter;
                              });
                              Navigator.pop(context);
                            },
                          );
                        }).toList(),
                      );
                    },
                  );
                },
                child: const Text("Filter"),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Top 3 on Leaderboards',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                height: 150.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ItemCard(items[index]),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'All Restaurants',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              FutureBuilder(
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
                    List filteredData = snapshot.data.where((food) {
                      final matchesSearch = searchController.text.isEmpty ||
                          food.fields.name.toLowerCase().contains(searchController.text.toLowerCase()) ||
                          food.fields.foodType.toLowerCase().contains(searchController.text.toLowerCase()) ||
                          [
                            "asian", "italian", "american", "seafood", "vegan", "chinese", "japanese", "mexican", "american", "indian", "thai", "french", "spanish", "korean", "mediterranean"
                          ].any((keyword) =>
                              keyword.contains(searchController.text.toLowerCase()));
                      final matchesFilter = selectedFilter.isEmpty ||
                          food.fields.foodType.toLowerCase().contains(selectedFilter.toLowerCase());
                      return matchesSearch && matchesFilter;
                    }).toList();

                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filteredData.length,
                      itemBuilder: (_, index) {
                        final food = filteredData[index];
                        return InkWell(
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
                          child: Container(
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
                                Text(
                                  "Average Rating: ${food.fields.avgRating}",
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Color.fromARGB(255, 0, 0, 0),
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
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<FoodEntry>> fetchFoodEntries(CookieRequest request) async {
    final response = await request.get('http://localhost:8000/json/');
    var data = response;

    List<FoodEntry> listFood = [];
    for (var d in data) {
      if (d != null) {
        listFood.add(FoodEntry.fromJson(d));
      }
    }
    return listFood;
  }
}

class FilterChipWidget extends StatelessWidget {
  final String label;

  const FilterChipWidget({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: false,
      onSelected: (bool selected) {},
      backgroundColor: Colors.grey[200],
      selectedColor: Theme.of(context).colorScheme.primary,
    );
  }
}

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text("You pressed the ${item.name} button!")));

          if (item.name == "Add Restaurant") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MoodEntryFormPage()),
            );
          } else if (item.name == "View Restaurant") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FoodEntryPage()),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(
            minWidth: 100.0, // Ensures a minimum width
            maxWidth: 120.0, // Prevents overflow in horizontal ListView
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

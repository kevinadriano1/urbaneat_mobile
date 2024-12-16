import 'package:flutter/material.dart';
import 'package:urbaneat/widgets/left_drawer.dart';
import 'package:urbaneat/restaurant/screens/list_foodentry.dart';
import 'package:urbaneat/screens/moodentry_form.dart';
import 'package:urbaneat/restaurant/models/food_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:urbaneat/restaurant/screens/restaurantdetail.dart';
import 'package:provider/provider.dart';

import '../add_edit_resto/screens/add_resto.dart';

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

  // FAQs mapping
  final Map<String, String> faqAnswers = {
    "Hello": "Hi!, How can I help?",
    "How to use the filter?": "To use the filter, click the 'Filter' button, select a category, and view the filtered results.",
    "How to search for restaurants?": "Type the restaurant name or type in the search bar at the top.",
    "How to add a restaurant?": "Click on the 'Add Restaurant' button on the main page.",
    "What is this app about?": "This app helps you find restaurants, view details, and add your favorite spots.",
    "How do I log out?": "Click on the 'Logout' button in the menu.",
    "Can I view restaurant details?": "Yes, click on any restaurant to view its details.",
    "What is the leaderboard?": "The leaderboard shows the top 3 popular restaurants based on user ratings.",
    "Can I search by cuisine type?": "Yes, you can type the cuisine type in the search bar.",
    "Is there a way to reset filters?": "Yes, clear the selected filter to reset it.",
    "How do I change my profile picture?": "This feature is not currently available.",
    "How do I update my profile?": "This feature is not currently available.",
    "What are the accepted cuisines?": "We accept cuisines like Asian, Italian, American, and more.",
    "Can I rate a restaurant?": "This feature is not currently available.",
    "How to delete a restaurant entry?": "This feature is not currently available.",
    "How do I contact support?": "You can use the chatbot for basic questions.",
    "Can I view restaurant ratings?": "Yes, ratings are displayed in the restaurant details.",
    "How do I view all restaurants?": "Scroll down to see the list of all restaurants.",
    "Can I sort restaurants?": "This feature is not currently available.",
    "How do I edit a restaurant entry?": "This feature is not currently available.",
    "How do I view nearby restaurants?": "This feature is not currently available.",
    "What information is available for restaurants?": "You can view the name, address, location, food type, and average rating.",
    "How do I add a review?": "This feature is not currently available.",
    "What happens if there are no results?": "A message will indicate that no restaurants match your search or filter.",
    "How do I navigate back to the homepage?": "Use the back button or click on the app title.",
    "Can I save favorite restaurants?": "This feature is not currently available.",
    "How do I update the app?": "Updates are managed through the app store or developer.",
    "How secure is my data?": "We prioritize user privacy and data security.",
    "Can I share restaurant details?": "This feature is not currently available.",
    "How do I clear the search bar?": "Use the clear button on your keyboard.",
    "Can I add multiple restaurants?": "Yes, you can add as many restaurants as you like.",
    "Is there a tutorial for new users?": "This feature is not currently available.",
    "What if I encounter a bug?": "Report it through the chatbot or contact support.",
    "How do I report incorrect restaurant information?": "This feature is not currently available.",
    "What devices support this app?": "The app supports most smartphones and tablets.",
    "How do I customize my experience?": "This feature is not currently available.",
    "How do I access advanced search options?": "Use the filter and search bar for advanced options.",
    "Can I upload restaurant images?": "This feature is not currently available.",
    "How do I delete my account?": "This feature is not currently available.",
    "How do I leave feedback for the app?": "This feature is not currently available.",
    "What languages does the app support?": "Currently, the app supports English.",
    "Can I use the app offline?": "An internet connection is required to fetch data.",
    "How do I view top-rated restaurants?": "Check the leaderboard section on the homepage.",
    "Can I view restaurant menus?": "This feature is not currently available.",
    "How do I change the app theme?": "This feature is not currently available.",
    "Is the app free to use?": "Yes, the app is free to use.",
    "How do I view restaurants by location?": "Use the filter or search bar to specify a location.",
    "How do I provide suggestions for the app?": "Use the chatbot or contact support to provide suggestions.",
    "Can I use this app for business purposes?": "This app is designed for personal use only.",
  };

String _findClosestResponse(String query) {
  // Normalize query: convert to lowercase, trim, and replace multiple spaces with a single space
  query = query.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');

  // Handle generic keywords like "restaurant" or duplicates
  if (query.contains("restaurant")) {
    return 'There are multiple topics related to "restaurants." Please specify what you need help with, such as "view restaurant details," "how to add a restaurant," or "restaurant ratings."';
  }

  // Handle exact matches
  if (faqAnswers.containsKey(query)) {
    return faqAnswers[query]!;
  }

  // Keyword match
  for (var key in faqAnswers.keys) {
    final normalizedKey = key.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    if (query.contains(normalizedKey) || normalizedKey.contains(query)) {
      return faqAnswers[key]!;
    }
  }

  // Fallback for no matches
  return 'Sorry, I couldn\'t find an answer for that. Please contact support.';
}



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
        child: Stack(
          children: [
            SingleChildScrollView(
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
                          return SingleChildScrollView(
                            child: Column(
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
                            ),
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
                              food.fields.foodType.toLowerCase().contains(searchController.text.toLowerCase());
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
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'How can I help you?',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            const Text(
                              'Ask me anything about how to use this app or troubleshoot issues!',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16.0),
                            TextField(
                              decoration: InputDecoration(
                                hintText: 'Type your question here...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              onSubmitted: (value) {
                                String answer = _findClosestResponse(value);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Answer'),
                                      content: Text(answer),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 16.0),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: const Icon(Icons.chat),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<FoodEntry>> fetchFoodEntries(CookieRequest request) async {
    final response = await request.get('https://kevin-adriano-urbaneat2.pbp.cs.ui.ac.id/json/');
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
              MaterialPageRoute(builder: (context) => AddRestaurantForm()),
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
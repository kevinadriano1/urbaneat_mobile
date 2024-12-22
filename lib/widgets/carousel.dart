import 'package:flutter/material.dart';
import 'package:urbaneat/add_edit_resto/screens/add_resto.dart';
import '../add_edit_resto/services/user_role_service.dart';
import '../leaderboards/leaderboard_page.dart';
import '../leaderboards/recommendations_page.dart';

class CarouselExample extends StatefulWidget {
  const CarouselExample({super.key});

  @override
  State<CarouselExample> createState() => _CarouselExampleState();
}

class _CarouselExampleState extends State<CarouselExample> {
  final List<String> imageUrls = [
    'assets/images/leaderboards_carousel.jpg',
    'assets/images/recommend_carousel.jpg',
    'assets/images/add_resto_carousel.jpg',
  ];
  String? _userRole;
  late List<String> _filteredImageUrls;

  @override
  void initState() {
    super.initState();
    _filteredImageUrls = List.from(imageUrls);  
    _fetchUserRole(); 
  }

  Future<void> _fetchUserRole() async {
    String userRole = await UserRoleService.fetchUserRole();
    setState(() {
      _userRole = userRole;
      if (_userRole != 'Restaurant_Manager') {
        _filteredImageUrls.removeAt(2); 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_userRole == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 200),
        child: CarouselView(
          itemExtent: 400,
          shrinkExtent: 200,
          onTap: (int index) {
            // Handle the tap based on the index
            if (_filteredImageUrls[index] == imageUrls[0] && _userRole == 'Restaurant_Manager') {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const LeaderboardPage(),
              ));
            } else if (index == 1) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const RecommendationsPage(),
              ));
            } else if (index == 2) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddRestaurantForm(),
              ));
            }
          },
          children: List<Widget>.generate(_filteredImageUrls.length, (int index) {
            return UncontainedLayoutCard(
              index: index,
              label: 'Item $index',
              imageUrl: _filteredImageUrls[index], 
            );
          }),
        ),
      ),
    );
  }
}
class UncontainedLayoutCard extends StatelessWidget {
  const UncontainedLayoutCard({
    super.key,
    required this.index,
    required this.label,
    required this.imageUrl, 
  });

  final int index;
  final String label;
  final String imageUrl; 

  @override
  Widget build(BuildContext context) {
    String? cardText;
    if (index == 0) {
      cardText = 'Leaderboards';
    } else if (index == 1) {
      cardText = 'Your Reviews';
    }
    else if (index == 2) {
      cardText = 'Add Resto';
    }
    else if (index == 3) {
      cardText = 'Cart';
    }
    
    return Stack(
        children: [
          ClipRect(
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          if (cardText != null) 
            Center(
              child: Text(
                cardText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 6.0,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
  }
}

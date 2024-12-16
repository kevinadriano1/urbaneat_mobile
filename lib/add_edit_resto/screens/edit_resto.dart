import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: EditRestaurantForm(),
    debugShowCheckedModeBanner: false,
  ));
}

class EditRestaurantForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image at the top
            SizedBox(
              width: double.infinity,
              height: 200,
              child: Image.network(
                'https://via.placeholder.com/400x200', // Replace with your image URL
                fit: BoxFit.cover,
              ),
            ),
            // Form container
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Center(
                      child: Text(
                        'Edit Restaurant',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Input fields
                    buildInputField('Name', 'Username'),
                    buildInputField('Street Address', 'Password'),
                    buildInputField('Location', 'Username'),
                    buildInputField('Food type', 'Password'),
                    buildInputField('Description', 'Username', maxLines: 3),
                    buildInputField('Contact Number', 'Username'),
                    buildInputField('Restaurant URL', 'Password'),
                    buildInputField('Menu Info', 'Username', maxLines: 3),
                    buildInputField('Image URL', 'Password'),
                    const SizedBox(height: 20),

                    // Save Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Add save functionality here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
        currentIndex: 0, // Active tab
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard), label: 'Leaderboards'),
          BottomNavigationBarItem(icon: Icon(Icons.thumb_up), label: 'For you'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Account'),
        ],
      ),
    );
  }

  // Helper function to create labeled text fields
  Widget buildInputField(String label, String hint, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          TextField(
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

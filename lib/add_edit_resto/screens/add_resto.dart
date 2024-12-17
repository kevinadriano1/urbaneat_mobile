import 'package:flutter/material.dart';
import 'package:urbaneat/restaurant/services/api_service.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart'; // For CookieRequest

class AddRestaurantForm extends StatefulWidget {
  @override
  _AddRestaurantFormState createState() => _AddRestaurantFormState();
}

class _AddRestaurantFormState extends State<AddRestaurantForm> {
  final _formKey = GlobalKey<FormState>();
  late ApiService apiService;

  // Controllers for the input fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController streetAddressController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController foodTypeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController restaurantUrlController = TextEditingController();
  final TextEditingController menuInfoController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final CookieRequest request = CookieRequest();
    apiService = ApiService(request);
  }

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final Map<String, dynamic> requestData = {
      "name": nameController.text,
      "street_address": streetAddressController.text,
      "location": locationController.text,
      "food_type": foodTypeController.text,
      "comments": descriptionController.text,
      "contact_number": contactNumberController.text,
      "trip_advisor_url": restaurantUrlController.text,
      "menu_info": menuInfoController.text,
      "image_url": imageUrlController.text,
    };

    try {
      final response = await apiService.createRestaurant(requestData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Restaurant created successfully!')),
      );

      _formKey.currentState!.reset(); // Clear the form
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Restaurant'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildInputField('Name', nameController),
                buildInputField('Street Address', streetAddressController),
                buildInputField('Location', locationController),
                buildInputField('Food Type', foodTypeController),
                buildInputField('Description', descriptionController, maxLines: 3),
                buildInputField('Contact Number', contactNumberController),
                buildInputField('Restaurant URL', restaurantUrlController),
                buildInputField('Menu Info', menuInfoController, maxLines: 3),
                buildInputField('Image URL', imageUrlController),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController controller, {int maxLines = 1}) {
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
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}

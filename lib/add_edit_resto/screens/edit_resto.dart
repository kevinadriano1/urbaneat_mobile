import 'package:flutter/material.dart';
import 'dart:convert'; 
import 'package:http/http.dart' as http;

class EditRestaurantForm extends StatefulWidget {
  final String id; // Restaurant ID to be edited
  const EditRestaurantForm({required this.id});

  @override
  _EditRestaurantFormState createState() => _EditRestaurantFormState();
}

class _EditRestaurantFormState extends State<EditRestaurantForm> {
  final _formKey = GlobalKey<FormState>();

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
    fetchRestaurantDetails(); // Load existing restaurant data
  }

  Future<void> fetchRestaurantDetails() async {
    final apiUrl = 'http://localhost:8000/admin_role/edit_resto_api/${widget.id}/'; // Example API endpoint
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          nameController.text = data['name'];
          streetAddressController.text = data['street_address'];
          locationController.text = data['location'];
          foodTypeController.text = data['food_type'];
          descriptionController.text = data['comments'];
          contactNumberController.text = data['contact_number'];
          restaurantUrlController.text = data['trip_advisor_url'];
          menuInfoController.text = data['menu_info'];
          imageUrlController.text = data['image_url'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch restaurant details.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final apiUrl = 'http://localhost:8000/admin_role/edit_resto_api/${widget.id}/';
    final Map<String, dynamic> requestData = {
      'name': nameController.text,
      'street_address': streetAddressController.text,
      'location': locationController.text,
      'food_type': foodTypeController.text,
      'comments': descriptionController.text,
      'contact_number': contactNumberController.text,
      'trip_advisor_url': restaurantUrlController.text,
      'menu_info': menuInfoController.text,
      'image_url': imageUrlController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      final xxx= response.body;
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
      } else {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${responseData['error']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Restaurant'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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

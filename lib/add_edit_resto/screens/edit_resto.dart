import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:urbaneat/restaurant/services/api_service.dart';

class EditRestaurantForm extends StatefulWidget {
  final String id; 
  const EditRestaurantForm({required this.id});

  @override
  _EditRestaurantFormState createState() => _EditRestaurantFormState();
}

class _EditRestaurantFormState extends State<EditRestaurantForm> {
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
    apiService = ApiService(CookieRequest()); 
    fetchRestaurantDetails(); // load existing restaurant data
  }

  Future<void> fetchRestaurantDetails() async {
    try {
      final data = await apiService.getEditRestaurantDetails(widget.id);
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) return;

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
      final response = await apiService.updateRestaurant(widget.id, requestData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Restaurant updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.33, 
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  imageUrlController.text.isNotEmpty
                      ? imageUrlController.text
                      : 'https://via.placeholder.com/150', 
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: SingleChildScrollView(
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

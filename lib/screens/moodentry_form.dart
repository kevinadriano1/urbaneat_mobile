import 'package:flutter/material.dart';
import 'package:urbaneat/widgets/left_drawer.dart';

class MoodEntryFormPage extends StatefulWidget {
  const MoodEntryFormPage({super.key});

  @override
  State<MoodEntryFormPage> createState() => _MoodEntryFormPageState();
}

class _MoodEntryFormPageState extends State<MoodEntryFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Fields for the form
  String _name = "";
  String _streetAddress = "";
  String _location = "";
  String _type = "";
  double _reviews = 0.0;
  int _noOfReviews = 0;
  String _comments = "";
  String _contactNumber = "";
  String _tripAdvisorUrl = "";
  String _menu = "";
  String _imageUrl = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Add Your Mood Today',
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField("Name", (value) => _name = value),
              _buildTextField("Street Address", (value) => _streetAddress = value),
              _buildTextField("Location", (value) => _location = value),
              _buildTextField("Type", (value) => _type = value),
              _buildNumberField("Reviews", (value) => _reviews = double.tryParse(value) ?? 0.0),
              _buildNumberField("Number of Reviews", (value) => _noOfReviews = int.tryParse(value) ?? 0),
              _buildTextField("Comments", (value) => _comments = value),
              _buildTextField("Contact Number", (value) => _contactNumber = value),
              _buildTextField("Trip Advisor URL", (value) => _tripAdvisorUrl = value),
              _buildTextField("Menu", (value) => _menu = value),
              _buildTextField("Image URL", (value) => _imageUrl = value),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Details successfully saved'),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Name: $_name'),
                                    Text('Street Address: $_streetAddress'),
                                    Text('Location: $_location'),
                                    Text('Type: $_type'),
                                    Text('Reviews: $_reviews'),
                                    Text('Number of Reviews: $_noOfReviews'),
                                    Text('Comments: $_comments'),
                                    Text('Contact Number: $_contactNumber'),
                                    Text('Trip Advisor URL: $_tripAdvisorUrl'),
                                    Text('Menu: $_menu'),
                                    Text('Image URL: $_imageUrl'),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _formKey.currentState!.reset();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to build a text input field
  Widget _buildTextField(String label, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: label,
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        onChanged: onChanged,
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return "$label cannot be empty!";
          }
          return null;
        },
      ),
    );
  }

  // Helper to build a number input field
  Widget _buildNumberField(String label, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: label,
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return "$label cannot be empty!";
          }
          if (label == "Reviews" && double.tryParse(value) == null) {
            return "$label must be a number!";
          }
          if (label != "Reviews" && int.tryParse(value) == null) {
            return "$label must be a number!";
          }
          return null;
        },
      ),
    );
  }
}

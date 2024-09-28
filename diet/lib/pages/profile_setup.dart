// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet/home/homepage.dart';
import 'package:diet/pages/call/gemini_call.dart';
import 'package:diet/pages/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class UserProfileSetup extends StatefulWidget {
  const UserProfileSetup({super.key});

  @override
  _UserProfileSetupState createState() => _UserProfileSetupState();
}

class _UserProfileSetupState extends State<UserProfileSetup> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _healthConditionsController =
      TextEditingController();

  String _gender = 'Male';
  String _dietaryPreference = 'None';
  String _healthGoal = 'Weight Loss';
  String _activityLevel = 'Sedentary';

  final String _weightUnit = 'kg'; // Fixed weight unit
  final String _heightUnit = 'cm'; // Fixed height unit

  List<String> dietaryPreferences = [
    'None',
    'Vegetarian',
    'Vegan',
    'Paleo',
    'Keto'
  ];
  List<String> healthGoals = ['Weight Loss', 'Muscle Gain', 'Maintenance'];
  List<String> activityLevels = ['Sedentary', 'Active', 'Very Active'];

  bool _isLoading = false; // Track loading state

  Future<void> _saveProfile() async {
    // Check if all fields are filled
    if (_nameController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _gender.isEmpty ||
        _weightController.text.isEmpty ||
        _heightController.text.isEmpty ||
        _dietaryPreference.isEmpty) {
      _showErrorDialog('Please fill in all required fields.');
      return; // Exit the method if validation fails
    }

    // Start loading
    setState(() {
      _isLoading = true;
    });

    // Prepare user data
    final userProfileData = {
      'name': _nameController.text,
      'age': int.parse(_ageController.text),
      'gender': _gender,
      'weight': double.parse(_weightController.text),
      'height': double.parse(_heightController.text),
      'dietaryPreference': _dietaryPreference,
      'healthGoal': _healthGoal,
      'dailyProteinGoal': 100, // Retrieve from inputs if available
      'dailyCarbGoal': 200, // Retrieve from inputs if available
      'dailyFatGoal': 70, // Retrieve from inputs if available
    };

    try {
      // Store data in Firestore
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(userProfileData);

        // Optionally, store in Hive if needed
        var box = await Hive.openBox('app');
        await box.put('profile', userProfileData);
        // profileBox.get('isProfileComplete', defaultValue: false);
        box.put('isProfileComplete', true);

        // Log the age type for debugging
        print(userProfileData['age'].runtimeType);

        final age = userProfileData['age'];
        final gender = userProfileData['gender'];
        final weight = userProfileData['weight'];
        final height = userProfileData['height'];
        final dietaryPreferences = userProfileData['dietaryPreference'];
        final healthGoal = userProfileData['healthGoal'];
        final dailyProteinGoal = userProfileData['dailyProteinGoal'];
        final dailyCarbGoal = userProfileData['dailyCarbGoal'];
        final dailyFatGoal = userProfileData['dailyFatGoal'];

        // Generate Meal Plan
        MealPlanGenerator generator = MealPlanGenerator();
        Map<String, dynamic>? mealPlan = await generator.generateMealPlan("""
      Generate a personalized meal plan for a user with the following profile:

      Age: $age
      Gender: $gender
      Weight: $weight kg
      Height: $height cm
      Dietary Preferences: $dietaryPreferences
      Health Goals: $healthGoal
      Daily Protein Goal: ${dailyProteinGoal}g
      Daily Carb Goal: ${dailyCarbGoal}g
      Daily Fat Goal: ${dailyFatGoal}g

      Please provide the meal plan in the following JSON format:

      {
        "meals": [
          {
            "mealType": "Breakfast",
            "foodItems": ["Oatmeal", "Banana", "Almonds"],
            "calories": 350,
            "protein": 10,
            "carbs": 60,
            "fats": 8
          },
          {
            "mealType": "Lunch",
            "foodItems": ["Grilled Chicken", "Quinoa", "Broccoli"],
            "calories": 500,
            "protein": 40,
            "carbs": 45,
            "fats": 15
          }
          // Add more meals as needed
        ]
      }
      """);

        await saveDailyGoals(
          user.uid,
          dailyProteinGoal,
          dailyCarbGoal,
          dailyFatGoal,
          2000, // Set your daily calorie goal or retrieve from inputs
        );

        if (mealPlan != null) {
          print("Generated Meal Plan: $mealPlan");
          await generator.saveMealPlan(user.uid, mealPlan);
          await generator.saveMealPlanLocally(mealPlan);
        } else {
          print("Failed to generate meal plan");
        }

        // Navigate to the dashboard or next screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        _showErrorDialog('User not found. Please log in again.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      // Stop loading
      setState(() {
        _isLoading = false;
      });
    }
  }

// Function to store the meal plan data
  Future<void> _storeMealPlan(Map<String, dynamic> mealPlanData) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'mealPlan': mealPlanData, // Update user document with meal plan
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBF2FF), // Light blue background
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ListView(
          children: [
            const SizedBox(height: 40),
            const Text(
              'Complete Your Profile',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF33373B), // Darker blue text
              ),
            ),
            const SizedBox(height: 18),

            // Name Field (Card style)
            _buildCardField(
              controller: _nameController,
              hint: 'Name',
            ),
            const SizedBox(height: 18),

            // Age Field
            _buildCardField(
              controller: _ageController,
              hint: 'Age',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 18),

            // Gender Dropdown
            _buildDropdownField(
              label: 'Gender',
              value: _gender,
              items: ['Male', 'Female', 'Other'],
              onChanged: (String? newValue) {
                setState(() {
                  _gender = newValue!;
                });
              },
            ),
            const SizedBox(height: 18),

            // Weight Field with fixed unit 'kg'
            _buildWeightHeightField(
              controller: _weightController,
              unit: _weightUnit,
              hint: 'Weight',
            ),
            const SizedBox(height: 18),

            // Height Field with fixed unit 'cm'
            _buildWeightHeightField(
              controller: _heightController,
              unit: _heightUnit,
              hint: 'Height',
            ),
            const SizedBox(height: 18),

            // Dietary Preference Dropdown
            _buildDropdownField(
              label: 'Dietary Preference',
              value: _dietaryPreference,
              items: dietaryPreferences,
              onChanged: (String? newValue) {
                setState(() {
                  _dietaryPreference = newValue!;
                });
              },
            ),
            const SizedBox(height: 18),

            // Health Goal Dropdown
            _buildDropdownField(
              label: 'Health Goal',
              value: _healthGoal,
              items: healthGoals,
              onChanged: (String? newValue) {
                setState(() {
                  _healthGoal = newValue!;
                });
              },
            ),
            const SizedBox(height: 18),

            // Health Conditions Field
            _buildCardField(
              controller: _healthConditionsController,
              hint: 'Health Conditions (Optional)',
            ),
            const SizedBox(height: 18),

            // Activity Level Dropdown
            _buildDropdownField(
              label: 'Activity Level',
              value: _activityLevel,
              items: activityLevels,
              onChanged: (String? newValue) {
                setState(() {
                  _activityLevel = newValue!;
                });
              },
            ),
            const SizedBox(height: 18),

            // Save Button
            _isLoading // Show loading button if loading is true
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF33373B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                    ),
                    onPressed: _saveProfile,
                    child: const Text('Save Profile'),
                  ),
          ],
        ),
      ),
    );
  }

  // Method to build text fields with card styling
  Widget _buildCardField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  // Method to build dropdown fields
  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  // Method to build weight/height fields with fixed unit
  Widget _buildWeightHeightField({
    required TextEditingController controller,
    required String unit,
    required String hint,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildCardField(controller: controller, hint: hint),
        ),
        const SizedBox(width: 10),
        Text(
          unit, // Fixed unit display (kg or cm)
          style: const TextStyle(fontSize: 16, color: Color(0xFF33373B)),
        ),
      ],
    );
  }
}

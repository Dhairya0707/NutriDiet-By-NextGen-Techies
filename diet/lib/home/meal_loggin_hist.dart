// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MealIntakeHistory extends StatefulWidget {
  const MealIntakeHistory({super.key});

  @override
  _MealIntakeHistoryState createState() => _MealIntakeHistoryState();
}

class _MealIntakeHistoryState extends State<MealIntakeHistory> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  late Future<QuerySnapshot> _mealIntakeFuture;

  @override
  void initState() {
    super.initState();
    // Fetch the meal intake data (Assuming stored in 'dailyIntakes' collection with 'date' field)
    _mealIntakeFuture = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection(
            'dailyIntakes') // You might need to adjust this collection path based on your structure
        .orderBy('date', descending: true) // Order by date (newest first)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Intake History'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _mealIntakeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          //   // print();
          //   return const Center(child: Text('No meal intakes found.'));
          // }

          // Map meal intake data from Firestore
          var mealIntakes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: mealIntakes.length,
            itemBuilder: (context, index) {
              var mealIntakeData =
                  mealIntakes[index].data() as Map<String, dynamic>;
              return _buildMealIntakeCard(mealIntakeData);
            },
          );
        },
      ),
    );
  }

  // Helper method to build meal intake card
  Widget _buildMealIntakeCard(Map<String, dynamic> mealIntakeData) {
    String date = mealIntakeData['date'] ??
        'Unknown Date'; // Expecting the date field in dailyIntakes collection
    int protein = mealIntakeData['proteinIntake'] ?? 0;
    int carbs = mealIntakeData['carbIntake'] ?? 0;
    int fats = mealIntakeData['fatIntake'] ?? 0;

    // Optional: Calculate total calories based on macronutrient values (1g protein/carbs = 4kcal, 1g fat = 9kcal)
    int totalCalories = (protein * 4) + (carbs * 4) + (fats * 9);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: $date',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Total Calories: $totalCalories kcal',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 5),
            Text('Protein: $protein g', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 5),
            Text('Carbs: $carbs g', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 5),
            Text('Fats: $fats g', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

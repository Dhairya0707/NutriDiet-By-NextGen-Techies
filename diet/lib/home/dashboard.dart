// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
// import 'tip_recommendation_widget.dart'; // Import the TipRecommendationWidget

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final String id = FirebaseAuth.instance.currentUser!.uid;
  bool isLoading = true;
  Map<String, dynamic>? userProfile;

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data when the page initializes
  }

  // Fetch user data from Firebase Firestore
  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').doc(id).get();
      setState(() {
        userProfile = snapshot.data() as Map<String, dynamic>;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userProfile == null) {
      return const Center(child: Text('User not found.'));
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Dashboard'),
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome text
              Text(
                'Welcome, ${userProfile!['name']}',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Daily Goals Section
              const Text(
                'Daily Goals:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              _buildGoalCard('Daily Calorie Goal',
                  userProfile!['dailyCalorieGoal'] ?? "", 'kcal'),
              _buildGoalCard(
                  'Daily Carb Goal', userProfile!['dailyCarbGoal'] ?? "", 'g'),
              _buildGoalCard(
                  'Daily Fat Goal', userProfile!['dailyFatGoal'] ?? "", 'g'),
              _buildGoalCard('Daily Protein Goal',
                  userProfile!['dailyProteinGoal'] ?? "", 'g'),
              const SizedBox(height: 20),

              // Bar Chart to show daily intake goals
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    titlesData: const FlTitlesData(show: true),
                    borderData: FlBorderData(show: true),
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [
                        BarChartRodData(
                          fromY: userProfile!['dailyProteinGoal'].toDouble()4,
                          color: Colors.green,
                          toY: 0,
                        )
                      ]),
                      BarChartGroupData(x: 1, barRods: [
                        BarChartRodData(
                          fromY: userProfile!['dailyCarbGoal'].toDouble(),
                          color: Colors.blue,
                          toY: 0,
                        )
                      ]),
                      BarChartGroupData(x: 2, barRods: [
                        BarChartRodData(
                          fromY: userProfile!['dailyFatGoal'].toDouble(),
                          color: Colors.red,
                          toY: 0,
                        )
                      ]),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Tip Recommendation Widget
              // TipRecommendationWidget(),
              const SizedBox(height: 20),

              // Buttons for BMI and Chatbot
              ElevatedButton(
                onPressed: () {
                  // Navigate to BMI Calculator
                },
                child: const Text('Calculate BMI'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to Chatbot
                },
                child: const Text('Chatbot'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build goal cards dynamically
  Widget _buildGoalCard(dynamic title, dynamic value, dynamic unit) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              '$value $unit',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// class Dashboard extends StatefulWidget {
//   @override
//   _DashboardState createState() => _DashboardState();
// }

// class _DashboardState extends State<Dashboard> {
//   final String userId = FirebaseAuth.instance.currentUser!.uid;
//   late Future<DocumentSnapshot> _userFuture;

//   @override
//   void initState() {
//     super.initState();
//     _userFuture =
//         FirebaseFirestore.instance.collection('users').doc(userId).get();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<DocumentSnapshot>(
//       future: _userFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }

//         if (!snapshot.hasData || !snapshot.data!.exists) {
//           return const Center(child: Text('User not found.'));
//         }

//         var userProfile = snapshot.data!.data() as Map<String, dynamic>;
//         print(userProfile);
//         int proteinGoal = userProfile['dailyProteinGoal'];
//         int carbGoal = userProfile['dailyCarbGoal'];
//         int fatGoal = userProfile['dailyFatGoal'];

//         print(proteinGoal);
//         print(carbGoal);
//         print(fatGoal);
//         print(userProfile);

//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('Dashboard'),
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Text('Welcome, ${userProfile['name']}',
//                     style: const TextStyle(fontSize: 24)),
//                 const SizedBox(height: 20),

//                 // Progress Bar Section for Daily Goals
//                 // _buildProgressBar("Protein", userProfile['proteinIntake'],
//                 //     proteinGoal, Colors.green),
//                 const SizedBox(height: 10),
//                 // _buildProgressBar("Carbohydrates", userProfile['carbIntake'],
//                 //     carbGoal, Colors.blue),
//                 const SizedBox(height: 10),
//                 // _buildProgressBar(
//                 //     "Fats", userProfile['fatIntake'], fatGoal, Colors.red),
//                 const SizedBox(height: 20),

//                 // Tip Recommendation Widget
//                 _buildTipRecommendationWidget(),
//                 const SizedBox(height: 20),

//                 // Bar Chart for Macro Goals (Optional visualization)
//                 // _buildMacroChart(proteinGoal, carbGoal, fatGoal),

//                 const SizedBox(height: 20),

//                 // Navigation buttons
//                 ElevatedButton(
//                   onPressed: () {
//                     // Navigate to BMI Calculator or other feature
//                   },
//                   child: const Text('Calculate BMI'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Navigate to Chatbot
//                   },
//                   child: const Text('Chatbot'),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // Widget for the progress bars
//   Widget _buildProgressBar(
//       dynamic label, int currentValue, int goalValue, dynamic color) {
//     double progress = (currentValue / goalValue).clamp(0.0, 1.0);

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("$label: $currentValue / $goalValue g"),
//         const SizedBox(height: 5),
//         LinearProgressIndicator(
//           value: progress,
//           backgroundColor: color.withOpacity(0.3),
//           color: color,
//           minHeight: 8,
//         ),
//       ],
//     );
//   }

//   // Widget for Tip Recommendation as a card
//   Widget _buildTipRecommendationWidget() {
//     return Card(
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             const Text("Tip of the Day",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             FutureBuilder<String>(
//               future: getTipRecommendation(), // Implement this to get tips
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const CircularProgressIndicator();
//                 }
//                 if (snapshot.hasError) {
//                   return const Text("Error fetching tip.");
//                 }
//                 return Text(snapshot.data ?? "Stay healthy and hydrated!");
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Macro Bar Chart for Protein, Carbs, and Fats
//   Widget _buildMacroChart(int proteinGoal, int carbGoal, int fatGoal) {
//     return Container(
//       height: 200,
//       child: BarChart(
//         BarChartData(
//           titlesData: const FlTitlesData(show: true),
//           borderData: FlBorderData(show: true),
//           barGroups: [
//             BarChartGroupData(x: 0, barRods: [
//               BarChartRodData(toY: proteinGoal.toDouble(), color: Colors.green),
//             ]),
//             BarChartGroupData(x: 1, barRods: [
//               BarChartRodData(toY: carbGoal.toDouble(), color: Colors.blue),
//             ]),
//             BarChartGroupData(x: 2, barRods: [
//               BarChartRodData(toY: fatGoal.toDouble(), color: Colors.red),
//             ]),
//           ],
//         ),
//       ),
//     );
//   }

//   // Function to get a Tip Recommendation
//   Future<String> getTipRecommendation() async {
//     // Here you can fetch tips from Firebase or generate one
//     await Future.delayed(const Duration(seconds: 1)); // Simulate loading
//     return "Make sure to include healthy fats in your diet!";
//   }
// }

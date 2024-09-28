// // ignore_for_file: library_private_types_in_public_api, avoid_print

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:diet/pages/call/gemini_call.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// // dashboard.dart

// class Dashboard extends StatefulWidget {
//   const Dashboard({super.key});

//   @override
//   _DashboardState createState() => _DashboardState();
// }

// class _DashboardState extends State<Dashboard> {
//   double dailyProteinIntake = 0.0;
//   double dailyCarbIntake = 0.0;
//   double dailyFatIntake = 0.0;
//   Map<String, dynamic>? mealPlan;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchUserData();
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       refreshDailyGoals(user);
//     }
//   }

//   Future<void> fetchUserData() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       // Fetch user profile data
//       DocumentSnapshot userProfile = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .get();

//       setState(() {
//         // Convert int to double
//         dailyProteinIntake = userProfile['dailyProteinGoal']?.toDouble() ?? 0.0;
//         dailyCarbIntake = userProfile['dailyCarbGoal']?.toDouble() ?? 0.0;
//         dailyFatIntake = userProfile['dailyFatGoal']?.toDouble() ?? 0.0;
//         _isLoading = false; // Stop loading when data is fetched
//       });

//       // Fetch today's meal plan
//       DocumentSnapshot mealPlanDoc = await FirebaseFirestore.instance
//           .collection('mealPlans')
//           .doc(user.uid) // Assuming the document ID matches the user ID
//           .get();

//       if (mealPlanDoc.exists && mealPlanDoc.data() != null) {
//         setState(() {
//           mealPlan = mealPlanDoc.data() as Map<String, dynamic>;
//           print(mealPlanDoc);
//         });
//       } else {
//         setState(() {
//           mealPlan = null; // Handle case where no meal plan is found
//         });
//       }
//     } else {
//       setState(() {
//         _isLoading = false; // Stop loading if user is null
//       });
//       // Handle user not found
//       _showErrorDialog('User not found. Please log in again.');
//     }
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Error'),
//           content: Text(message),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Dashboard'),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Daily intake progress
//                     Text(
//                       'Daily Nutritional Intake',
//                       style: Theme.of(context).textTheme.titleLarge,
//                     ),
//                     const SizedBox(height: 16.0),
//                     LinearProgressIndicator(
//                       value: dailyProteinIntake / 100, // Example max goal
//                       backgroundColor: Colors.grey[300],
//                       color: Colors.blue,
//                     ),
//                     Text('Protein: ${dailyProteinIntake.toStringAsFixed(1)} g'),
//                     LinearProgressIndicator(
//                       value: dailyCarbIntake / 200, // Example max goal
//                       backgroundColor: Colors.grey[300],
//                       color: Colors.green,
//                     ),
//                     Text('Carbs: ${dailyCarbIntake.toStringAsFixed(1)} g'),
//                     LinearProgressIndicator(
//                       value: dailyFatIntake / 70, // Example max goal
//                       backgroundColor: Colors.grey[300],
//                       color: Colors.red,
//                     ),
//                     Text('Fats: ${dailyFatIntake.toStringAsFixed(1)} g'),
//                     const SizedBox(height: 20),

//                     // Meal plan display
//                     Text(
//                       'Today\'s Meal Plan',
//                       style: Theme.of(context).textTheme.titleLarge,
//                     ),
//                     const SizedBox(height: 16.0),
//                     mealPlan != null
//                         ? Column(
//                             children: mealPlan!['meals'].map<Widget>((meal) {
//                               return Card(
//                                 margin:
//                                     const EdgeInsets.symmetric(vertical: 8.0),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(16.0),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         meal['mealType'],
//                                         style: const TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       Text(
//                                           'Food Items: ${meal['foodItems'].join(', ')}'),
//                                       Text('Calories: ${meal['calories']}'),
//                                       Text('Protein: ${meal['protein']} g'),
//                                       Text('Carbs: ${meal['carbs']} g'),
//                                       Text('Fats: ${meal['fats']} g'),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           )
//                         : const Text('No meal plan available for today.'),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }

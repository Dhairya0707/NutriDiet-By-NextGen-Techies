// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet/home/dashboard.dart';
import 'package:diet/home/logmeal.dart';
import 'package:diet/home/meal_loggin_hist.dart';
// import 'package:diet/home/logmeal.dart';
import 'package:diet/pages/call/gemini_call.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Dashboard(),
    SearchPage(),
    MealPlansPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition App'),
        actions: [
          IconButton(
              onPressed: () {
                Hive.box('app').put('isProfileComplete', false);
                setState(() {});
                FirebaseAuth.instance.signOut();
                setState(() {});
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        tooltip: "Log Meal",
        child: const Icon(Icons.add),
        onPressed: () {
          // void _showLogMealDialog(BuildContext context) {
          // showDialog(
          //   context: context,
          //   builder: (BuildContext context) {
          //     return const LogMealDialog();
          //   },
          //   // showTips(context);
          // );

          Navigator.push(
            context,
            // MaterialPageRoute(builder: (context) => const LogMealPage()),
            MaterialPageRoute(builder: (context) => const MealIntakeHistory()),
          );
          // }
        },
      ),
      bottomNavigationBar: NavigationBar(
        // height: provider.bottombar(context),

        onDestinationSelected: (int index) {
          _selectedIndex = index;
          setState(() {});
        },
        selectedIndex: _selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.fastfood),
            selectedIcon: Icon(Icons.fastfood),
            label: 'Meal Plans',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// class Dashboard extends StatelessWidget {
//   final String id = FirebaseAuth.instance.currentUser!.uid;

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<DocumentSnapshot>(
//       future: FirebaseFirestore.instance
//           .collection('users')
//           .doc(id)
//           .get(), // Replace with actual user ID
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

//         return Column(
//           children: [
//             Text('Welcome, ${userProfile['name']}',
//                 style: const TextStyle(fontSize: 24)),
//             const SizedBox(height: 20),
//             Container(
//               height: 200,
//               child: BarChart(
//                 BarChartData(
//                   titlesData: const FlTitlesData(show: true),
//                   borderData: FlBorderData(show: true),
//                   barGroups: [
//                     BarChartGroupData(x: 0, barRods: [
//                       BarChartRodData(
//                           fromY: userProfile['dailyProteinGoal'].toDouble(),
//                           color: Colors.green,
//                           toY: 0)
//                     ]),
//                     BarChartGroupData(x: 1, barRods: [
//                       BarChartRodData(
//                           fromY: userProfile['dailyCarbGoal'].toDouble(),
//                           color: Colors.blue,
//                           toY: 0)
//                     ]),
//                     BarChartGroupData(x: 2, barRods: [
//                       BarChartRodData(
//                           fromY: userProfile['dailyFatGoal'].toDouble(),
//                           color: Colors.red,
//                           toY: 0)
//                     ]),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             //  TipRecommendationWidget(),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Navigate to another page or functionality
//               },
//               child: const Text('Calculate BMI'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 // Navigate to Chatbot
//               },
//               child: const Text('Chatbot'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          decoration: const InputDecoration(
            labelText: 'Search...',
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.search),
          ),
          onSubmitted: (value) {
            // Implement search functionality
          },
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final String id = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .get(), // Replace with actual user ID
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('User not found.'));
        }

        var userProfile = snapshot.data!.data() as Map<String, dynamic>;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${userProfile['name']}',
                  style: const TextStyle(fontSize: 20)),
              Text('Age: ${userProfile['age']}',
                  style: const TextStyle(fontSize: 20)),
              Text('Gender: ${userProfile['gender']}',
                  style: const TextStyle(fontSize: 20)),
              Text('Weight: ${userProfile['weight']} kg',
                  style: const TextStyle(fontSize: 20)),
              Text('Height: ${userProfile['height']} cm',
                  style: const TextStyle(fontSize: 20)),
              Text('Dietary Preference: ${userProfile['dietaryPreference']}',
                  style: const TextStyle(fontSize: 20)),
              Text('Health Goal: ${userProfile['healthGoal']}',
                  style: const TextStyle(fontSize: 20)),
            ],
          ),
        );
      },
    );
  }
}

// class MealPlansPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<QuerySnapshot>(
//         future: FirebaseFirestore.instance
//             .collection('users')
//             .doc(FirebaseAuth.instance.currentUser!.uid)
//             .collection('mealPlans')
//             .get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('No meal plans found.'));
//           }

//           var mealPlans = snapshot.data!.docs;
//           // print(mealPlans[0]['meals']);

//           return ListView.builder(
//             itemCount: mealPlans[0]['meals'].length,
//             itemBuilder: (context, index) {
//               var mealPlan = mealPlans[0].data() as Map<String, dynamic>;
//               print(mealPlans[0]['meals'].length);
//               // print(mealPlan['meals'].length);
//               // print(mealPlan['meals');

//               return Card(
//                 margin: const EdgeInsets.all(8.0),
//                 elevation: 4,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         mealPlan['meals'][index]['mealType'].toString() ??
//                             "No Meal Type",
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8.0),
//                       Text(
//                         'Food Items: ${mealPlan['meals'][index]['foodItems']?.join(", ") ?? "No Food Items"}',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                       const SizedBox(height: 8.0),
//                       Text(
//                         'Calories: ${mealPlan['meals'][index]['calories'] ?? "N/A"}',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                       const SizedBox(height: 8.0),
//                       if (mealPlan['meals'][index]['protein'] != null)
//                         Text(
//                           'Protein: ${mealPlan['meals'][index]['protein']}g',
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                       if (mealPlan['carbs'] != null)
//                         Text(
//                           'Carbs: ${mealPlan['meals'][index]['carbs']}g',
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                       if (mealPlan['meals'][index]['fats'] != null)
//                         Text(
//                           'Fats: ${mealPlan['meals'][index]['fats']}g',
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

class MealPlansPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Meal Plans'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await _refreshMealPlan(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('mealPlans')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No meal plans found.'));
          }

          var mealPlans = snapshot.data!.docs;

          return ListView.builder(
            itemCount: mealPlans[0]['meals'].length,
            itemBuilder: (context, index) {
              var mealPlan = mealPlans[0].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mealPlan['meals'][index]['mealType'].toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Food Items: ${mealPlan['meals'][index]['foodItems']?.join(", ") ?? "No Food Items"}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Calories: ${mealPlan['meals'][index]['calories'] ?? "N/A"}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8.0),
                      if (mealPlan['meals'][index]['protein'] != null)
                        Text(
                          'Protein: ${mealPlan['meals'][index]['protein']}g',
                          style: const TextStyle(fontSize: 16),
                        ),
                      if (mealPlan['meals'][index]['carbs'] != null)
                        Text(
                          'Carbs: ${mealPlan['meals'][index]['carbs']}g',
                          style: const TextStyle(fontSize: 16),
                        ),
                      if (mealPlan['meals'][index]['fats'] != null)
                        Text(
                          'Fats: ${mealPlan['meals'][index]['fats']}g',
                          style: const TextStyle(fontSize: 16),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _refreshMealPlan(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      // Fetch the last refresh timestamp
      DocumentSnapshot lastRefreshDoc =
          await userDoc.collection('settings').doc('mealPlanSettings').get();
      DateTime? lastRefresh;

      if (lastRefreshDoc.exists) {
        lastRefresh =
            (lastRefreshDoc.data() as Map<String, dynamic>)['lastRefresh']
                ?.toDate();
      }

      // Check if 24 hours have passed since the last refresh
      if (lastRefresh == null ||
          DateTime.now().isAfter(lastRefresh.add(const Duration(hours: 24)))) {
        // Fetch user profile information
        DocumentSnapshot userProfileDoc = await userDoc.get();

        if (userProfileDoc.exists) {
          var userProfile = userProfileDoc.data() as Map<String, dynamic>;

          // Generate new meal plan using the user's profile
          MealPlanGenerator generator = MealPlanGenerator();
          Map<String, dynamic>? mealPlan = await generator.generateMealPlan("""
            Generate a personalized meal plan for a user with the following profile:

            Age: ${userProfile['age']}
            Gender: ${userProfile['gender']}
            Weight: ${userProfile['weight']} kg
            Height: ${userProfile['height']} cm
            Dietary Preferences: ${userProfile['dietaryPreference']}
            Health Goals: ${userProfile['healthGoal']}
            Daily Protein Goal: ${userProfile['dailyProteinGoal']}g
            Daily Carb Goal: ${userProfile['dailyCarbGoal']}g
            Daily Fat Goal: ${userProfile['dailyFatGoal']}g

            Please provide a diverse meal plan with the following format:

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
                },
                {
                  "mealType": "Dinner",
                  "foodItems": ["Salmon", "Sweet Potatoes", "Spinach"],
                  "calories": 600,
                  "protein": 35,
                  "carbs": 45,
                  "fats": 25
                },
                {
                  "mealType": "Snack",
                  "foodItems": ["Greek Yogurt", "Honey", "Berries"],
                  "calories": 200,
                  "protein": 10,
                  "carbs": 30,
                  "fats": 5
                }
              ]
            }
          """);

          if (mealPlan != null) {
            // Save the new meal plan in Firestore
            await userDoc
                .collection('mealPlans')
                .add(mealPlan); // Save it as a new document

            // Update the last refresh timestamp
            await userDoc.collection('settings').doc('mealPlanSettings').set({
              'lastRefresh': FieldValue.serverTimestamp(),
            });

            ScaffoldMessenger.of(context).showSnackBar(
              // ignore: unnecessary_const
              const SnackBar(content: const Text('Meal plan refreshed!')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to generate meal plan.')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User profile not found.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('You can refresh your meal plan after 24 hours.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in.')),
      );
    }
  }
}

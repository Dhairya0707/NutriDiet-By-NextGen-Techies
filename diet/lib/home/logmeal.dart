// import 'package:diet/pages/call/gemini_call.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class FoodItem {
//   final String name;
//   final int protein;
//   final int carbs;
//   final int fats;

//   FoodItem({
//     required this.name,
//     required this.protein,
//     required this.carbs,
//     required this.fats,
//   });
// }

// // Sample predefined meals
// final List<FoodItem> predefinedMeals = [
//   FoodItem(name: "Oatmeal", protein: 10, carbs: 30, fats: 5),
//   FoodItem(name: "Grilled Chicken", protein: 40, carbs: 0, fats: 5),
//   FoodItem(name: "Brown Rice", protein: 5, carbs: 45, fats: 1),
//   FoodItem(name: "Broccoli", protein: 3, carbs: 6, fats: 0),
//   FoodItem(name: "Almonds", protein: 6, carbs: 6, fats: 14),
//   FoodItem(name: "Banana", protein: 1, carbs: 27, fats: 0),
//   FoodItem(name: "Salmon", protein: 25, carbs: 0, fats: 14),
//   FoodItem(name: "Eggs", protein: 6, carbs: 1, fats: 5),
//   FoodItem(name: "Greek Yogurt", protein: 10, carbs: 5, fats: 4),
//   FoodItem(name: "Quinoa", protein: 8, carbs: 39, fats: 4),
//   FoodItem(name: "Spinach", protein: 3, carbs: 1, fats: 0),
//   FoodItem(name: "Chickpeas", protein: 15, carbs: 45, fats: 4),
//   FoodItem(name: "Sweet Potato", protein: 2, carbs: 20, fats: 0),
//   FoodItem(name: "Cauliflower", protein: 2, carbs: 5, fats: 0),
//   FoodItem(name: "Cottage Cheese", protein: 11, carbs: 4, fats: 5),
//   FoodItem(name: "Peanut Butter", protein: 8, carbs: 6, fats: 16),
//   FoodItem(name: "Mushrooms", protein: 3, carbs: 4, fats: 0),
// ];

// class LogMealDialog extends StatefulWidget {
//   const LogMealDialog({super.key});

//   @override
//   _LogMealDialogState createState() => _LogMealDialogState();
// }

// class _LogMealDialogState extends State<LogMealDialog> {
//   FoodItem? selectedFoodItem;
//   int proteinIntake = 0;
//   int carbIntake = 0;
//   int fatIntake = 0;

//   void _updateIntake(FoodItem? newItem) {
//     setState(() {
//       selectedFoodItem = newItem;
//       if (newItem != null) {
//         proteinIntake = newItem.protein;
//         carbIntake = newItem.carbs;
//         fatIntake = newItem.fats;
//       } else {
//         proteinIntake = 0;
//         carbIntake = 0;
//         fatIntake = 0;
//       }
//     });
//   }

//   void _logMeal() {
//     // Call your logging function here
//     String userId = FirebaseAuth.instance.currentUser!.uid;

//     saveDailyIntake(userId, proteinIntake, carbIntake, fatIntake, [
//       {
//         'mealType': selectedFoodItem?.name ?? "Unknown",
//         'protein': proteinIntake,
//         'carbs': carbIntake,
//         'fats': fatIntake,
//       }
//     ]);

//     // Optionally, show a confirmation snack bar or message
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Meal logged successfully!')),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       title: const Text(
//         "Log Your Meal",
//         style: TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 20,
//         ),
//       ),
//       content: Form(
//         key: GlobalKey<FormState>(),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             DropdownButtonFormField<FoodItem>(
//               value: selectedFoodItem,
//               items: predefinedMeals.map((FoodItem item) {
//                 return DropdownMenuItem<FoodItem>(
//                   value: item,
//                   child: Text(item.name),
//                 );
//               }).toList(),
//               onChanged: (FoodItem? newValue) => _updateIntake(newValue),
//               decoration: InputDecoration(
//                 labelText: "Select Food Item",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: const BorderSide(color: Colors.blue),
//                 ),
//                 filled: true,
//                 fillColor: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextFormField(
//               readOnly: true,
//               decoration: InputDecoration(
//                 labelText: "Protein Intake (g)",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: const BorderSide(color: Colors.grey),
//                 ),
//                 filled: true,
//                 fillColor: Colors.white,
//               ),
//               initialValue:
//                   selectedFoodItem != null ? proteinIntake.toString() : '',
//             ),
//             const SizedBox(height: 10),
//             TextFormField(
//               readOnly: true,
//               decoration: InputDecoration(
//                 labelText: "Carb Intake (g)",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: const BorderSide(color: Colors.grey),
//                 ),
//                 filled: true,
//                 fillColor: Colors.white,
//               ),
//               initialValue:
//                   selectedFoodItem != null ? carbIntake.toString() : '',
//             ),
//             const SizedBox(height: 10),
//             TextFormField(
//               readOnly: true,
//               decoration: InputDecoration(
//                 labelText: "Fat Intake (g)",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: const BorderSide(color: Colors.grey),
//                 ),
//                 filled: true,
//                 fillColor: Colors.white,
//               ),
//               initialValue:
//                   selectedFoodItem != null ? fatIntake.toString() : '',
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           style: TextButton.styleFrom(
//             backgroundColor: Colors.blue,
//             foregroundColor: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//           onPressed: () {
//             if (Form.of(context).validate()) {
//               _logMeal();
//               Navigator.of(context).pop();
//             }
//           },
//           child: const Text("Log Meal"),
//         ),
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: const Text("Cancel"),
//         ),
//       ],
//     );
//   }
// }
import 'package:diet/pages/call/gemini_call.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FoodItem {
  final String name;
  final int protein;
  final int carbs;
  final int fats;

  FoodItem({
    required this.name,
    required this.protein,
    required this.carbs,
    required this.fats,
  });
}

final List<FoodItem> predefinedMeals = [
  FoodItem(name: "Oatmeal", protein: 10, carbs: 30, fats: 5),
  FoodItem(name: "Grilled Chicken", protein: 40, carbs: 0, fats: 5),
  FoodItem(name: "Brown Rice", protein: 5, carbs: 45, fats: 1),
  FoodItem(name: "Broccoli", protein: 3, carbs: 6, fats: 0),
  FoodItem(name: "Almonds", protein: 6, carbs: 6, fats: 14),
  FoodItem(name: "Banana", protein: 1, carbs: 27, fats: 0),
  FoodItem(name: "Salmon", protein: 25, carbs: 0, fats: 14),
  FoodItem(name: "Eggs", protein: 6, carbs: 1, fats: 5),
  FoodItem(name: "Greek Yogurt", protein: 10, carbs: 5, fats: 4),
  FoodItem(name: "Quinoa", protein: 8, carbs: 39, fats: 4),
  FoodItem(name: "Spinach", protein: 3, carbs: 1, fats: 0),
  FoodItem(name: "Chickpeas", protein: 15, carbs: 45, fats: 4),
  FoodItem(name: "Sweet Potato", protein: 2, carbs: 20, fats: 0),
  FoodItem(name: "Cauliflower", protein: 2, carbs: 5, fats: 0),
  FoodItem(name: "Cottage Cheese", protein: 11, carbs: 4, fats: 5),
  FoodItem(name: "Peanut Butter", protein: 8, carbs: 6, fats: 16),
  FoodItem(name: "Mushrooms", protein: 3, carbs: 4, fats: 0),
];

class LogMealPage extends StatefulWidget {
  const LogMealPage({Key? key}) : super(key: key);

  @override
  _LogMealPageState createState() => _LogMealPageState();
}

class _LogMealPageState extends State<LogMealPage> {
  FoodItem? selectedFoodItem;
  int proteinIntake = 0;
  int carbIntake = 0;
  int fatIntake = 0;

  void _updateIntake(FoodItem? newItem) {
    setState(() {
      selectedFoodItem = newItem;
      if (newItem != null) {
        proteinIntake = newItem.protein;
        carbIntake = newItem.carbs;
        fatIntake = newItem.fats;
      } else {
        proteinIntake = 0;
        carbIntake = 0;
        fatIntake = 0;
      }
    });
  }

  void _logMeal() {
    if (selectedFoodItem == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a food item')),
      );
      return;
    }

    String userId = FirebaseAuth.instance.currentUser!.uid;

    saveDailyIntake(userId, proteinIntake, carbIntake, fatIntake, {
      'mealType': selectedFoodItem!.name,
      'protein': proteinIntake,
      'carbs': carbIntake,
      'fats': fatIntake,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Meal logged successfully!')),
    );

    // Optionally, you can clear the selection after logging
    setState(() {
      selectedFoodItem = null;
      proteinIntake = 0;
      carbIntake = 0;
      fatIntake = 0;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Your Meal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<FoodItem>(
              value: selectedFoodItem,
              items: predefinedMeals.map((FoodItem item) {
                return DropdownMenuItem<FoodItem>(
                  value: item,
                  child: Text(item.name),
                );
              }).toList(),
              onChanged: (FoodItem? newValue) => _updateIntake(newValue),
              decoration: InputDecoration(
                labelText: "Select Food Item",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Nutritional Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            _buildNutritionInfoCard('Protein', proteinIntake),
            const SizedBox(height: 10),
            _buildNutritionInfoCard('Carbs', carbIntake),
            const SizedBox(height: 10),
            _buildNutritionInfoCard('Fats', fatIntake),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logMeal,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Log Meal'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionInfoCard(String label, int value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 16)),
            Text('$value g',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

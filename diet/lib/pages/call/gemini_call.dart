import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive/hive.dart';

class MealPlanGenerator {
  final String apiKey = "AIzaSyCKLL1KxCeuLKh3qsYWWpWYZlryKs422I4";

  Future<Map<String, dynamic>?> generateMealPlan(String prompt) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
      generationConfig: GenerationConfig(responseMimeType: "application/json"),
    );

    final content = [Content.text(prompt)];

    try {
      // Call the Gemini API
      final response = await model.generateContent(content);

      // Check if the response is valid
      if (response.text != null) {
        final String jsonData = response.text!;
        final Map<String, dynamic> mealPlan = jsonDecode(jsonData);
        return mealPlan;
      } else {
        throw Exception("Failed to generate meal plan");
      }
    } catch (e) {
      print("Error occurred: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchUserProfile(String userId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      print("Error fetching user profile: $e");
      return null;
    }
  }

  Future<void> saveMealPlan(
      String userId, Map<String, dynamic> mealPlan) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('mealPlans') // Create a subcollection for meal plans
          .add(mealPlan);
    } catch (e) {
      print("Error saving meal plan: $e");
    }
  }

  Future<void> saveMealPlanLocally(Map<String, dynamic> mealPlan) async {
    var box = await Hive.openBox('mealPlansBox');
    await box.put('lastMealPlan', mealPlan); // Store the meal plan with a key
  }

// Usage Example
  void getMealPlan(String userId) async {
    MealPlanGenerator generator = MealPlanGenerator();

    // Fetch user profile
    Map<String, dynamic>? userProfileData =
        await generator.fetchUserProfile(userId);

    if (userProfileData != null) {
      String prompt = generatePrompt(
        userProfileData['age'],
        userProfileData['gender'],
        userProfileData['weight'],
        userProfileData['height'],
        userProfileData['dietaryPreference'], // Assuming this is a list
        userProfileData['healthGoal'], // Assuming this is a list
        userProfileData[
            'dailyProteinGoal'], // Adjust according to your data structure
        userProfileData[
            'dailyCarbGoal'], // Adjust according to your data structure
        userProfileData[
            'dailyFatGoal'], // Adjust according to your data structure
      );

      Map<String, dynamic>? mealPlan = await generator.generateMealPlan(prompt);

      if (mealPlan != null) {
        print("Generated Meal Plan: $mealPlan");
        // Handle the meal plan (e.g., display in UI, store in Firestore, etc.)
      } else {
        print("Failed to generate meal plan");
      }
    } else {
      print("Failed to fetch user profile");
    }
  }

  String generatePrompt(
      int age,
      String gender,
      double weight,
      double height,
      List<String> dietaryPreferences,
      List<String> healthGoals,
      int proteinGoal,
      int carbGoal,
      int fatGoal) {
    return """
  Generate a personalized meal plan for a user with the following profile:

  Age: $age

  Gender: $gender

  Weight: $weight kg

  Height: $height cm

  Dietary Preferences: ${dietaryPreferences.join(', ')}

  Health Goals: ${healthGoals.join(', ')}

  Daily Protein Goal: ${proteinGoal}g

  Daily Carb Goal: ${carbGoal}g

  Daily Fat Goal: ${fatGoal}g

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
  """;
  }
}

Future<void> refreshDailyGoals(User user) async {
  String today = DateTime.now().toIso8601String().split('T')[0];
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('dailyGoals')
      .doc(user.uid)
      .get();

  if (doc.exists) {
    Map<String, dynamic> goalsData = doc.data() as Map<String, dynamic>;
    String lastResetDate = goalsData['lastResetDate'];

    if (lastResetDate != today) {
      // Reset goals logic
      await doc.reference.set({
        'dailyProteinGoal': 0,
        'dailyCarbGoal': 0,
        'dailyFatGoal': 0,
        'dailyCalorieGoal': 0,
        'lastResetDate': today, // Update the last reset date
      });
    }
  } else {
    // Initialize daily goals for the first time
    await FirebaseFirestore.instance
        .collection('dailyGoals')
        .doc(user.uid)
        .set({
      'dailyProteinGoal': 0,
      'dailyCarbGoal': 0,
      'dailyFatGoal': 0,
      'dailyCalorieGoal': 0,
      'lastResetDate': today,
    });
  }
}

Future<void> saveDailyIntake(String userId, int protein, int carbs, int fats,
    Map<String, dynamic> meal) async {
  String date = DateTime.now()
      .toIso8601String()
      .split('T')[0]; // Current date in YYYY-MM-DD format

  // Get the document reference for the current day's intake
  DocumentReference dailyIntakeRef = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('dailyIntakes')
      .doc(date);

  // Perform an atomic update to add the new meal to the meal entries array
  await dailyIntakeRef.set({
    'proteinIntake': FieldValue.increment(protein), // Increment protein intake
    'carbIntake': FieldValue.increment(carbs), // Increment carb intake
    'fatIntake': FieldValue.increment(fats), // Increment fat intake
    'mealEntries': FieldValue.arrayUnion([meal]), // Add the new meal entry
  }, SetOptions(merge: true)); // Merge with the existing document
}

Future<void> saveDailyGoals(dynamic userId, dynamic proteinGoal,
    dynamic carbGoal, dynamic fatGoal, dynamic calorieGoal) async {
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('dailyGoals')
        .doc(userId)
        .set({
      'dailyProteinGoal': proteinGoal,
      'dailyCarbGoal': carbGoal,
      'dailyFatGoal': fatGoal,
      'dailyCalorieGoal': calorieGoal,
    });
  } catch (e) {
    print('Error saving daily goals: $e');
  }
}

Future<Map<String, dynamic>?> fetchDailyGoals(String userId) async {
  try {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('dailyGoals')
        .doc(userId)
        .get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>?;
    }
  } catch (e) {
    print('Error fetching daily goals: $e');
  }
  return null; // Return null if no goals found
}

void compareIntakeWithGoals(
    Map<String, dynamic> dailyIntake, Map<String, dynamic> dailyGoals) {
  double proteinPercentage =
      (dailyIntake['totalProtein'] / dailyGoals['dailyProteinGoal']) * 100;
  double carbPercentage =
      (dailyIntake['totalCarbs'] / dailyGoals['dailyCarbGoal']) * 100;
  double fatPercentage =
      (dailyIntake['totalFats'] / dailyGoals['dailyFatGoal']) * 100;
  double caloriePercentage =
      (dailyIntake['totalCalories'] / dailyGoals['dailyCalorieGoal']) * 100;

  print('Protein Goal Met: $proteinPercentage%');
  print('Carb Goal Met: $carbPercentage%');
  print('Fat Goal Met: $fatPercentage%');
  print('Calorie Goal Met: $caloriePercentage%');
}

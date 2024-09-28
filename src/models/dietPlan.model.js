import mongoose from 'mongoose'

const mealSchema = new mongoose.Schema({
  mealType: { type: String, required: true }, // e.g., "Lunch", "Dinner"
  name: { type: String, required: true }, // e.g., "Chicken and Veggie Stir-Fry"
  ingredients: { type: String, required: true }, // e.g., "Chicken breast, broccoli, carrots..."
  calories: { type: Number, required: true } // e.g., 500
});

const macronutrientSchema = new mongoose.Schema({
  protein: { type: Number, required: true }, // e.g., 150
  carbohydrates: { type: Number, required: true }, // e.g., 300
  fats: { type: Number, required: true } // e.g., 80
});

const generalTipsSchema = new mongoose.Schema({
  tip1: { type: String, required: true }, // e.g., "Focus on whole, unprocessed foods."
  tip2: { type: String, required: true }, // e.g., "Stay hydrated by drinking plenty of water..."
  tip3: { type: String, required: true }  // e.g., "Listen to your body and adjust your portion sizes..."
});

const dietPlanSchema = new mongoose.Schema({
    email:{
        type: String,
        required:true,
        unique:true
    },
  dailyCalorieTarget: { type: Number, required: true }, // e.g., 2500
  macronutrientBreakdown: {
    type: macronutrientSchema,
    required: true
  },
  mealPlan: {
    lunch: {
      type: mealSchema,
      required: true
    },
    dinner: {
      type: mealSchema,
      required: true
    }
  },
  generalTips: {
    type: generalTipsSchema,
    required: true
  }
}, { timestamps: true });

export const DietPlan = mongoose.model('DietPlan', dietPlanSchema);

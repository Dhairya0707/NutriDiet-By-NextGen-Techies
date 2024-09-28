import { asyncHandler } from "../utils/asyncHandler.js";
import { ApiResponse } from "../utils/ApiResponse.js";
import { DietPlan } from "../models/dietPlan.model.js";
import { Profile } from "../models/profile.model.js";
import { Goal } from "../models/goal.model.js";
import nodemailer from "nodemailer";

// POST: Create a new user profile
 const createProfile = asyncHandler(async (req, res) => {
  try {
    const { email, Name, Gender, Age, Height, Weight, Allergies, Food_Prefrence, Activity_Level } = req.body;

    // Check if a profile already exists for the user
    const existingProfile = await Profile.findOne({ email });
    if (existingProfile) {
      return res.status(400).json(
        new ApiResponse(400,null,"Profile already exists for this email.")
      );
    }

    // Create a new profile
    const newProfile = new Profile({
      email,
      Name,
      Gender,
      Age,
      Height,
      Weight,
      Allergies,
      Food_Prefrence,
      Activity_Level
    });

    // Save the profile to the database
    await newProfile.save();

    return res.status(201).json(
      new ApiResponse(200,newProfile,"Profile created successfully")
    );
  } catch (error) {
    return res.status(500).json(
      new ApiResponse(500,error.message,"Error creating profile")
    );
  }
});




// POST: Create a new goal for the user
 const createGoal = asyncHandler(async (req, res) => {
  try {
    const { email, Goal: goal, Target_Weight, Weekly_weight, Diet_Type, Additional_Goal } = req.body;

    // Check if a goal already exists for the user
    const existingGoal = await Goal.findOne({ email });
    if (existingGoal) {
      return res.status(400).json(
        new ApiResponse(400,null, "Goal already exists for this user. Please update it instead.")
      );
    }

    // Create a new goal
    const newGoal = new Goal({
      email,
      Goal: goal,
      Target_Weight,
      Weekly_weight,
      Diet_Type,
      Additional_Goal
    });

    // Save the goal to the database
   const savedgoal = await newGoal.save();
// console.log(savedgoal);

    const mailData = {
      email,
     goal:savedgoal, 
    };

    // Call the SendEmail function to send the email
    await SendEmail(mailData);

    return res.status(201).json(
      new ApiResponse(201,newGoal,"Goal created successfully")
    );
    
  } catch (error) {
    return res.status(500).json(
      new ApiResponse(500,null,"Error creating goal")
    );
  }
  
});

//Email For User

const transporter = nodemailer.createTransport({
  host: "smtp.gmail.com",
  port: 587,
  secure: false, 
  // service: 'gmail',
  auth: {
    user: process.env.USER,
    pass: process.env.PASS
  }
});



// Refactor SendEmail to be a standalone function
const SendEmail = async ({ email, goal }) => {
  console.log(goal);
  
  const mailOptions = {
    from: 'gamikrutik1234@gmail.com',
    to: email,
    subject: `<b>🏆 Your Goal Update: ${goal.Goal}</b>`,
    html: `<div>
    <p><strong>🎯 Goal:</strong> ${goal.Goal}</p>
    <p><strong>📉 Target Weight:</strong> ${goal.Target_Weight} kg</p>
    <p><strong>📆 Weekly Weight Change:</strong> ${goal.Weekly_weight} kg</p>
    <p><strong>🥗 Diet Type:</strong> ${goal.Diet_Type}</p>
    <p><strong>📌 Additional Goal:</strong> ${goal.Additional_Goal || null}</p>
    <p>Keep pushing towards your goals! 💪✨</p>
  </div>`

  };

  return new Promise((resolve, reject) => {
    transporter.sendMail(mailOptions, (error, info) => {
      if (error) {
        return reject(new Error("Error sending email: " + error.toString()));
      }
      resolve(info);
    });
  });
};
//Update Goal

// PATCH: Update a user's goal by email
 const updateGoal = asyncHandler(async (req, res) => {
  try {
    const { email, ...updates } = req.body; // Extract email and the fields to update from the request body

    if (!email) {
      return res.status(400).json(
        new ApiResponse(400,null, "Email is required to update goal.")
      );
    }

    // Find the goal by email and update the document
    const updatedGoal = await Goal.findOneAndUpdate({ email }, updates, {
      new: true,            // Return the updated document
      runValidators: true   // Ensure the updates adhere to schema validation rules
    });

    if (!updatedGoal) {
      return res.status(404).json(
        new ApiResponse(404,null, "Goal not found for this email.")
      );
    }

    const mailData = {
      email,
     goal:updatedGoal, 
    };

    // Call the SendEmail function to send the email
    await SendEmail(mailData);

    return res.status(200).json(
      new ApiResponse(200,updatedGoal, "Goal updated successfully")
    );
  } catch (error) {
    return res.status(500).json(
      new ApiResponse(500,null, "Error updating goal")
    );
  }
});








// POST: Create or overwrite a diet plan by emailId
 const createDietPlan = asyncHandler( async (req, res) =>{
  try {
    const { email, dailyCalorieTarget, macronutrientBreakdown, mealPlan, generalTips } = req.body;

    // Check if a diet plan with this emailId already exists
    const existingPlan = await DietPlan.findOne({ email });

    if (existingPlan) {
      return res.status(400).json(
        new ApiResponse(400,null,"Diet plan already exists for this email.")
      );
    }

    // Create a new diet plan
    const newDietPlan = new DietPlan({
      email,
      dailyCalorieTarget,
      macronutrientBreakdown,
      mealPlan,
      generalTips
    });

    // Save the new diet plan
    await newDietPlan.save();

    return res.status(201).json(
        new ApiResponse(201,newDietPlan,"Diet plan created successfully")
      );

  } catch (error) {
    return res.status(500).json(
      new ApiResponse(500,null,"Error creating diet plan")
    );
  }
});

// PATCH: Update an existing diet plan by emailId
const updateDietPlan = async (req, res) => {
    try {
      const { email, ...updates } = req.body; // Extract emailId and the rest of the update fields from the request body
  
      if (!email) {
        return res.status(400).json(
          new ApiResponse(400,null,"Email is required to update diet plan.")
        );
      }
  
      // Find the diet plan by emailId and update it
      const updatedDietPlan = await DietPlan.findOneAndUpdate({ email }, updates, {
        new: true, // Return the updated document
        runValidators: true // Ensure the updates are valid according to the schema
      });
  
      if (!updatedDietPlan) {
        return res.status(404).json(
          new ApiResponse(404,null,"Diet plan not found for this email.")
        );
      }
  
      return res.status(201).json(
        new ApiResponse(200,updatedDietPlan,"Diet plan updated successfully")
      );
      
    } catch (error) {
      return res.status(500).json(
        new ApiResponse(500,null,"Error updating diet plan")
      );
    }
  };
  

export  {
 createProfile,
  createDietPlan,
  updateDietPlan,
  createGoal,
  updateGoal,
  SendEmail
};

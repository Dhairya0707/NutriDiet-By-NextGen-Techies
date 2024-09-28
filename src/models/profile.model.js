import mongoose from "mongoose";
// import bcrypt from "bcrypt";

const profileSchema = new mongoose.Schema(
{
    email:{
        type: String,
        required:true,
        unique:true
    },
    Name:{
        type: String,
        required: true,
    },
    Gender:{
        type: String,
        required: true,
    },
    Age:{
        type: Number,
        required: true,
    },
    Height:{
        type: Number,
        required: true,
    },
    Weight:{
        type: Number,
        required: true,
    },
    Allergies:{
        type: String,
    },
    Food_Prefrence:{
        type: String,
        default:"No Preference"
    },
    Activity_Level:{
        type: String,
    },
},
{timestamps: true}
);

export const Profile = mongoose.model("Profile",profileSchema);
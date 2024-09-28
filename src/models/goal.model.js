import mongoose from "mongoose";
// import bcrypt from "bcrypt";

const goalSchema = new mongoose.Schema(
{
    email:{
        type: String,
        required:true,
        unique:true
    },
    Goal:{
        type: String,
        required: true,
    },
    Target_Weight:{
        type: Number,
        required: true,
    },
    Weekly_weight:{
        type: Number,
        required: true,
    },
    Diet_Type:{
        type: String,
        required: true,
    },
    Additional_Goal:{
        type: String,
    },
},
{timestamps: true}
);

export const Goal = mongoose.model("Goal",goalSchema);

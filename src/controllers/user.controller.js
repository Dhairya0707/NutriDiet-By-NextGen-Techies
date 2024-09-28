import { asyncHandler } from "../utils/asyncHandler.js";
import { ApiResponse } from "../utils/ApiResponse.js";
import { User } from "../models/user.model.js";

const registerUser = asyncHandler(async (req,res)=>{
    const {email,password,confirmPassword} = req.body;

    if(!email || !password || !confirmPassword){
        return res.status(400)
    .json(
        new ApiResponse(400,null,"All fields are required.")
    )
    }

    const existedUser = await User.findOne({email});

    if(existedUser){
        return res.status(401)
    .json(
         new ApiResponse(401,null,"User already exists.")
    )
    }

    if(password !== confirmPassword){
        return res.status(401)
    .json(
         new ApiResponse(401,null,"ConfirmPassword do not match.")
    )
    }

   const user =  await User.create({
        email,
        password,
        confirmPassword
    })

   const createdUser =  await User.findById(user._id).select("-password -confirmPassword");

   if(!createdUser){
    return res.status(400)
    .json(
     new ApiResponse(400,null,"Something went wrong while registering the user.")
    )
   }

   return res
   .status(200)
   .json(
    new ApiResponse(200,createdUser,"User register Successfully")
   )
})

const loginUser = asyncHandler(async (req,res)=>{
    const {email,password} = req.body;

    if(!email || !password){
        return res.status(400)
    .json(
         new ApiResponse(400,null,"All fields are required.")
    )
    }

   const user =  await User.findOne({email});

   if(!user){
    return res.status(404)
    .json(
        new ApiResponse(404,null,"User not found.")
    )
   }

    const isPasswordvalid = await user.isPasswordCorrect(password);

    if(!isPasswordvalid){
        return res.status(401)
    .json(
         new ApiResponse(401,null,"Invalid user credentials.")
    )
    }

    const loggedInUser = await User.findById(user._id).select("-password -confirmPassword");

    if(!loggedInUser){
        return res.status(401)
    .json(
         new ApiResponse(401,null,"Something went wrong while login the user.")
    )
    }

    return res
    .status(200)
    .json(
        new ApiResponse(
            200,
            {
                user: loggedInUser,
            },
            "User logged in successfully."
        )
    )
})

export {
    registerUser,
    loginUser
}
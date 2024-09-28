import mongoose from "mongoose";
import { ApiError } from "../utils/ApiError.js";
const connectDB = async () => {
try {
    const connectionInstance = await mongoose.connect(`${process.env.MONGO_DB_URI}/${process.env.DATABASE_NAME}`);
    console.log("MongoDB connected successfully!!",connectionInstance.connection.host);
} catch (error) {
    throw new ApiError(400, "MongoDB connection error",error);
}
}
export {connectDB};
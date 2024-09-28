import cookieParser from "cookie-parser";
import express from "express";
import cors from "cors";
import dotenv from "dotenv"
import userRouter from "./routes/user.routes.js"

dotenv.config({
    path: "./.env"
});

const app =express();

app.use(express.json({limit: "20kb"}));
app.use(express.urlencoded({extended: true, limit: "16kb"}));
app.use(express.static("./public"));
app.use(cookieParser());
app.use(cors({
    origin: process.env.CORS,
    credentials: true
}))

app.use("/api/v1/users",userRouter);
export {app};
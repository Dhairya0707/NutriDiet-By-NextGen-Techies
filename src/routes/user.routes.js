import  {Router}  from "express";
import {registerUser,loginUser} from "../controllers/user.controller.js";
import {createProfile,createDietPlan,updateDietPlan,createGoal,updateGoal,SendEmail} from "../controllers/diet.controller.js";

const router = Router();

router.route("/register").post(registerUser);
router.route("/login").post(loginUser);

router.route("/profile").post(createProfile);

router.route("/diet-plans").post(createDietPlan);
router.route("/diet-plans").patch(updateDietPlan);


router.route("/goal").post(createGoal);
router.route("/goal").patch(updateGoal);

router.route("/send-email").post(SendEmail);

export default router;
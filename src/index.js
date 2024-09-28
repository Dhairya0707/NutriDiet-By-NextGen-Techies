import {app} from "./app.js";
import {connectDB} from "./db/db.js";

connectDB().then(()=>
app.listen(3000,()=>{
    console.log("Server running on port 3000");
})
)
.catch((error)=>console.log(error))
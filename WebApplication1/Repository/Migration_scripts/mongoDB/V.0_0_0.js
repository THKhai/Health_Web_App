db.createUser({
    user:"khai_TR",
    pwd:"09122002",
    roles:[
        {
            role:"readWrite",
            db:"HealthWebApplication"
        }
    ]
})

use("HealthWebApplication");
db.createCollection("Users");
// in createUser.js module:
exports.addUUID = function(loginUser,username,uuid,response)
{
   "use strict";
    Parse.Cloud.useMasterKey();
    var query = new Parse.Query("Employee_UUID");
    query.equalTo("Employee", username);
    query.find().then(function(error) {
                      var empUUIDClass = Parse.Object.extend("Employee_UUID");
                      var newRecord = new empUUIDClass();
                      newRecord.set ("Employee",username);
                      newRecord.set ("UUID",uuid);
                      newRecord.save(null, {
                        success: function(anotherUser) {
                            //The user was saved successfully.
                            response.success("Successfully assignUUID");
                        },
                        error: function(gameScore, error) {
                            //The save failed.
                            response.error("Could not save changes to user.");
                        }
                        });
                      }
                      })
};
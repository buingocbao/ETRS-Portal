exports.resetUser = function(username,beaconInfo,device,response)
{
   "use strict";
    Parse.Cloud.useMasterKey();
    var query = new Parse.Query(Parse.User);
    query.equalTo("username", username);
    query.first({
        success: function(object) {
        if (beaconInfo != "No") {
            object.set("Beacon", beaconInfo);
        }
        if (device == "None") {
            object.set("Device", "None");
        }
        object.save(null, {
            success: function() {
                    //The user was saved successfully.
                    response.success("Successful reset user");
            },
            error: function(error) {
                    //The save failed.
                    response.error("Error: " + error.code + " " + error.message);
            }
        });
    },
    error: function(error) {
        response.error("Error: " + error.code + " " + error.message);
    }
    });
};
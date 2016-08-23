exports.changeSupervisor = function(username,supervisorId,response)
{
   "use strict";
    Parse.Cloud.useMasterKey();
    var query = new Parse.Query(Parse.User);
    query.equalTo("username", username);
    query.first({
        success: function(object) {
        var User = Parse.Object.extend("User");
        var supervisor = new User();
        supervisor.id = supervisorId;
        supervisor.fetch().then(function() {
            object.set ("Supervisor", supervisor);
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
        });
    },
    error: function(error) {
        response.error("Error: " + error.code + " " + error.message);
    }
    });
};
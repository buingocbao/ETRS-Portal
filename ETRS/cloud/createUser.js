// in createUser.js module:
exports.createUser = function(creatingUser,email,tempPass,firstName,lastName,group,supervisorId,beacon,response)
{
  "use strict";
    var user = new Parse.User();
    user.set ("username", email);
    user.set ("password", tempPass);
    user.set ("email", email);
    user.set ("FirstName", firstName);
	user.set ("LastName", lastName);
	user.set ("Group", group);
	user.set ("Device", "None");
    user.set ("Beacon", beacon);

    user.signUp(null, {
  	success: function(user) {
    		// Hooray! Let them use the app now.
		Parse.Cloud.useMasterKey();
		var acl = new Parse.ACL(user);
		acl.setPublicReadAccess(false);
		acl.setPublicWriteAccess(false);
		acl.setRoleReadAccess("Admin",  true);
		acl.setRoleReadAccess("Manager",  true);
		user.setACL(acl);

		var User = Parse.Object.extend("User");
		var supervisor = new User();
		supervisor.id = supervisorId;
		supervisor.fetch().then(function() {
			user.set ("Supervisor", supervisor);
			user.save(null, {
        		success: function(anotherUser) {
           			//The user was saved successfully.
          			response.success("Successful sign up user");
        		},
        		error: function(gameScore, error) {
           			//The save failed.
          			response.error("Could not save changes to user.");
        		}
            });
		});
		//response.success();
  	},
  	error: function(user, error) {
    		// Show the error message somewhere and let the user try again.
    		response.error("Error: " + error.code + " " + error.message);
  	}
    });
};
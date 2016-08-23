
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.define("createUser", function(request, response)
{  
  var creatingUser = request.user; 
  var email = request.params.email; // string required
	var tempPass = request.params.password; // string
	var firstName = request.params.firstName;
	var lastName = request.params.lastName;
	var group = request.params.group;
	var supervisorId = request.params.supervisorId;
    var beacon = request.params.beacon;

    var createjs = require("cloud/createUser.js");
    createjs.createUser(creatingUser,email,tempPass,firstName,lastName,group,supervisorId,beacon,response);
});

Parse.Cloud.define("addUUID", function(request, response)
{
                   var loginUser = request.user;
                   var username = request.params.username;
                   var uuid = request.params.uuid;
                   var addUUIDjs = require("cloud/addUUID.js");
                   addUUIDjs.addUUID(loginUser,username,uuid,response);
});

Parse.Cloud.define("resetUser", function(request,response)
{
    var loginUser = request.user;
    var username = request.params.username;
    var beaconInfo = request.params.beaconInfo;
    var device = request.params.device;
    var resetUser = require("cloud/resetUser.js");
    resetUser.resetUser(username,beaconInfo,device,response);
});

Parse.Cloud.define("changeSupervisor",function(request,response)
{
    var loginUser = request.user;
    var username = request.params.username;
    var supervisorId = request.params.supervisorId;
    var changeSpvs = require("cloud/changeSupervisor.js");
    changeSpvs.changeSupervisor(username,supervisorId,response);
});

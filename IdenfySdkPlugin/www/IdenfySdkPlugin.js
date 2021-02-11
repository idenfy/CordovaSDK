var exec = require('cordova/exec');

function IdenfySdkPlugin() {
    console.log("IdenfySdk: is created");
}

exports.startIdentification = function (token, success, error) {
    exec(success, error, "IdenfySdkPlugin", "idenfyInitialize", [token]);
};

IdenfySdkPlugin.prototype.startIdentification = function (token, successCallback, errorCallback) {
    console.log("IdenfySdk: startIdentification");

    exec(function (success) {
            successCallback(success);
        },
        function (error) {
            errorCallback(error);
        },
        "IdenfySdkPlugin", "idenfyInitialize", [token]);
}

var idenfySdkPlugin = new IdenfySdkPlugin();
module.exports = idenfySdkPlugin;

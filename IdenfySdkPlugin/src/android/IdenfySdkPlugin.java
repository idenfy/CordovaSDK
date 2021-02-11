package com.idenfy.idenfysdkcordovaplugin;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.idenfy.idenfySdk.CoreSdkInitialization.IdenfyController;
import com.idenfy.idenfySdk.api.initialization.IdenfySettingsV2;
import com.idenfy.idenfySdk.api.response.IdenfyIdentificationResult;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class IdenfySdkPlugin extends CordovaPlugin {

    private static final String CORDOVA_LOG = "idenfy_log";
    private static final String IDENFY = "idenfyInitialize";
    private CallbackContext callbackContext;

    public IdenfySdkPlugin() {
    }

    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
    }

    public boolean execute(final String action, JSONArray args,
                           CallbackContext callbackContext) throws JSONException {

        this.callbackContext = callbackContext;

        final CordovaPlugin that = this;

        if (action.equals(IDENFY)) {
            cordova.setActivityResultCallback(this);


            cordova.getActivity().runOnUiThread(new Runnable() {
                public void run() {
                    if (args.length() > 0) {
                        try {
                            final Activity activity = cordova.getActivity();
                            final Context context = cordova.getActivity().getApplicationContext();

                            //Parsing an authToken.
                            String authToken = args.getString(0);

                            //Setting settings for idenfySDK.
                            IdenfySettingsV2 idenfySettingsV2 = new IdenfySettingsV2.IdenfyBuilderV2()
                                    .withAuthToken(authToken)
                                    .build();

                            //Presenting idenfySDK.
                            IdenfyController.getInstance().initializeIdenfySDKV2WithManual(activity, IdenfyController.IDENFY_REQUEST_CODE, idenfySettingsV2);
                        } catch (JSONException e) {
                            Log.d(CORDOVA_LOG, e.toString());
                        }
                    } else {
                        Log.d(CORDOVA_LOG, "array is empty");
                    }

                }
            });

        }

        return true;

    }

    public void onRestoreStateForActivityResult(Bundle state, CallbackContext callbackContext) {
        Log.d(CORDOVA_LOG, "onRestoreStateForActivityResult");
        this.callbackContext = callbackContext;
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        Log.d(CORDOVA_LOG, "onActivityResult");


        if (this.callbackContext != null) {
            Log.d(CORDOVA_LOG, "callBackContextIsNotNull");

            if (requestCode == IdenfyController.IDENFY_REQUEST_CODE) {

                if (resultCode == IdenfyController.IDENFY_IDENTIFICATION_RESULT_CODE) {
                    IdenfyIdentificationResult idenfyIdentificationResult = data.getParcelableExtra(IdenfyController.IDENFY_IDENTIFICATION_RESULT);
                    if (idenfyIdentificationResult != null) {
                        switch (idenfyIdentificationResult.getManualIdentificationStatus()) {
                            case APPROVED:
                                //The user completed an identification flow, was verified manually and the identification status, provided by a manual reviewer, is APPROVED.
                                break;
                            case FAILED:
                                //The user completed an identification flow, was verified manually and the identification status, provided by a manual reviewer, is FAILED.
                                break;
                            case WAITING:
                                //The user was only verified by an automated platform, not by a manual reviewer.
                                break;
                            case INACTIVE:
                                //The user was only verified by an automated platform and still waiting for manual reviewing.
                                break;
                        }
                        switch (idenfyIdentificationResult.getAutoIdentificationStatus()) {

                            case APPROVED:
                                //The user completed an identification flow and the identification status, provided by an automated platform, is APPROVED.
                                break;
                            case FAILED:
                                //The user completed an identification flow and the identification status, provided by an automated platform, is FAILED.
                                break;
                            case UNVERIFIED:
                                //The user did not complete an identification flow and the identification status, provided by an automated platform, is UNVERIFIED.
                                break;
                        }
                    }
                    Gson gson = new GsonBuilder().setLenient().create();
                    JsonElement element = gson.toJsonTree(idenfyIdentificationResult);
                    JsonObject object = element.getAsJsonObject();
                    try {
                        JSONObject response = new JSONObject(object.toString());
                        Log.d(CORDOVA_LOG, "idenfyIdentificationResult" + response.toString());
                        //Returning a result as JSON.
                        callbackContext.success(response.toString());
                    } catch (JSONException e) {

                        Log.d(CORDOVA_LOG, e.toString());
                    }
                }

            }
        } else {
            Log.d(CORDOVA_LOG, "callBackContextIsNull");
        }
        super.onActivityResult(requestCode, resultCode, data);

    }
}

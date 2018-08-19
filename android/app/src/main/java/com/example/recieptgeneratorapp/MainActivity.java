package com.example.recieptgeneratorapp;

import android.os.Bundle;
import android.telephony.SmsManager;
import android.util.Log;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import android.content.pm.PackageManager;
import android.os.Build;
import android.Manifest;
import android.app.PendingIntent;
import android.content.Intent;
import android.content.BroadcastReceiver;
import android.content.IntentFilter;
import android.content.Context;
import android.app.Activity;
import android.support.v4.content.ContextCompat;
import 	android.support.v4.app.ActivityCompat;
import android.support.annotation.NonNull;


import com.example.recieptgeneratorapp.MarshMallowPermission;
import com.example.recieptgeneratorapp.PermissionInterface;

public class MainActivity extends FlutterActivity   {
  private static final String CHANNEL = "sendSms";
  private static final int PERMISSION_REQUEST = 100;
    
  private MethodChannel.Result callResult;

  String phoneNo,msg;
  MarshMallowPermission marshMallowPermission;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    marshMallowPermission = new MarshMallowPermission(this,MainActivity.this);

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                if(call.method.equals("send")){
                   String num = call.argument("phone");
                   String msg = call.argument("msg");
                   sendSMS(num,msg,result);
                }else{
                  result.notImplemented();
                }
              }
            });
  }

  
  private void sendSMS(String phoneNo, String msg,MethodChannel.Result result) {

    this.phoneNo = phoneNo;
    this.msg = msg;

    if(!marshMallowPermission.checkPermissionForPhoneState()){
        marshMallowPermission.requestPermissionForPhoneState();
    }else{
        if(!marshMallowPermission.checkPermissionForSendSMS()){
          marshMallowPermission.requestPermissionForSendSMS();
        }else{

          try {
            PendingIntent sentPI, deliveredPI;
            String SENT = "SMS_SENT";
            String SMS_DELIVERED = "SMS_DELIVERED";


            sentPI = PendingIntent.getBroadcast(this, 0,new Intent(SENT), 0);

            deliveredPI = PendingIntent.getBroadcast(this, 0,new Intent(SMS_DELIVERED), 0);

            SmsManager smsManager = SmsManager.getDefault();
            registerReceiver(new BroadcastReceiver() {
              @Override
              public void onReceive(Context context, Intent intent) {
                System.out.println("SENT :"+getResultCode());
              
                  switch (getResultCode()) {
                      case SmsManager.RESULT_ERROR_GENERIC_FAILURE:
                          System.out.println("Generic failure cause");
                         
                          break;
                      case SmsManager.RESULT_ERROR_NO_SERVICE:
                          System.out.println("Service is currently unavailable");
                          break;
                      case SmsManager.RESULT_ERROR_NULL_PDU:
                          System.out.println("No pdu provided");
                          break;
                      case SmsManager.RESULT_ERROR_RADIO_OFF:
                          System.out.println("Radio was explicitly turned off");
                          break;
                      case Activity.RESULT_OK :
                          System.out.println("sdsdsdsdsdsd"); 
                  }
              }
          }, new IntentFilter(SENT));

          // For when the SMS has been delivered
          registerReceiver(new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
              System.out.println("DELEIVERD :"+getResultCode());
                switch (getResultCode()) {
                    case Activity.RESULT_OK:
                         System.out.println("SMS delivered"); 
                        break;
                    case Activity.RESULT_CANCELED:
                        System.out.println("SMS not delivered"); 
                        break;
                      
                }
            }
          }, new IntentFilter(SMS_DELIVERED));
          smsManager.sendTextMessage("+919595903117", null, "Akshay", sentPI, deliveredPI);
            
          result.success("SMS sent successfully");
       
          
        } catch (Exception ex) {
            ex.printStackTrace();
            result.error("Err","Sms Not Sent","");
        }
        }
    }


      }
    
}
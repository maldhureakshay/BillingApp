package com.example.recieptgeneratorapp;

public interface PermissionInterface {

    public void onRecievedSendSMSPermission(boolean isGranted);
    public void onRecievedReadPhoneStatePermission(boolean isGranted);
    
}
//
//  PermissionsResponse.swift
//  MidPoint
//
//  Created by Joao Sisanoski on 7/8/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary

class PermissionsResponse: NSObject {
    class func checkCameraPermission(){
        if AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) ==  AVAuthorizationStatus.Authorized
        {
            NSLog("autorizado")
        }
        else
        {
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { (granted :Bool) -> Void in
                if granted == true
                {
                    NSLog("autorizou")
                }
                else
                {
                    NSLog("recusou")

                }
            });
        }
    }
    class func checkRollCameraPermission(){
        let status : ALAuthorizationStatus = ALAssetsLibrary.authorizationStatus()
        if status != ALAuthorizationStatus.Authorized{
            NSLog("Não autorizado acessar a galeria")
        }
    }
    class func openSettings(){
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
    }
}

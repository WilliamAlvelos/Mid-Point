//
//  PushResponse.swift
//  MidPoint
//
//  Created by William Alvelos on 29/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation
import Parse
class PushResponse {
    class func sendPushToUser(users: Array<User>, message : String){
        var array = Array<String>()
        for var x = 0; x < users.count ; x++ {
            array.append("\(users[x].id!)")
        }
        let pushQuery = PFInstallation.query()
        
        pushQuery?.whereKey(ParseGlobalConstants.Logged, equalTo: true)
        pushQuery?.whereKey(ParseGlobalConstants.Id, containedIn: array)
        let push = PFPush()
        push.setQuery(pushQuery) // Set our Installation query
        push.setMessage(message)
        push.sendPushInBackground()
    }
    class func pushActived()->Bool{
        let data = NSUserDefaults.standardUserDefaults().objectForKey("deviceToken") as? NSData
        if data == nil {
            return false
        }
        return true
    }
    class func createNewDeviceToPush(user: User){
        let data = NSUserDefaults.standardUserDefaults().objectForKey("deviceToken") as? NSData
        if data == nil {
            return
        }

        let installation = PFInstallation.currentInstallation()
        installation[ParseGlobalConstants.Id] = "\(user.id!)"
        installation[ParseGlobalConstants.Logged] = true
        installation.setDeviceTokenFromData(data)
        installation.saveInBackground()

    }
    class func removeDeviceToPush(user: User){
        let installation = PFInstallation.currentInstallation()
        installation[ParseGlobalConstants.Logged] = false
        installation.saveInBackground()
    }
}
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
        
        pushQuery?.whereKey(ParseGlobalConstants.Id, containedIn: array)
        let push = PFPush()
        push.setQuery(pushQuery) // Set our Installation query
        push.setMessage(message)
        push.sendPushInBackground()
    }
    class func sendPushToGroup(event: Event, message: String){
        let user = UserDAODefault.getLoggedUser()
        let pushQuery = PFInstallation.query()
        
        pushQuery?.whereKey("\(ParseGlobalConstants.Event_Id)_\(event.id!)", equalTo: true)
        pushQuery?.whereKey(ParseGlobalConstants.Id, notEqualTo: "\(user.id!)")
        let push = PFPush()
        push.setQuery(pushQuery)
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
    class func registerDeviceFromEvent(events: Array<Event>){
        let userdefaults = NSUserDefaults.standardUserDefaults()
        if ( (userdefaults.objectForKey(UserGlobalConstants.LoggedNow) as! Bool) == false) {
            return
        }
        userdefaults.setBool(true, forKey: UserGlobalConstants.LoggedNow)
        let data = userdefaults.objectForKey("deviceToken") as? NSData
        
        if data == nil {
            return
        }
        for event in events {
            let installation = PFInstallation.currentInstallation()
            installation["\(ParseGlobalConstants.Event_Id)_\(event.id!)"] = true
            //installation.setDeviceTokenFromData(data)
            installation.saveInBackground()
        }
        
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
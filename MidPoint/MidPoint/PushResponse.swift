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
       
        pushQuery?.whereKey("id", containedIn: array)
        let push = PFPush()
        push.setQuery(pushQuery) // Set our Installation query
        push.setMessage(message)
        push.sendPushInBackground()
    }
}
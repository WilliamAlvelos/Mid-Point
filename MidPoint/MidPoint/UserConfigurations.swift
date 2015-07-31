//
//  UserConfigurations.swift
//  MidPoint
//
//  Created by Danilo Mative on 27/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import UIKit

enum VisibilityType{
    case Private
    case Friends
    case Public
}

class UserConfigurations: NSObject {
   
    private override init() {}
    
    static var instance: UserConfigurations!
    
    var favoritesVisibility:VisibilityType!
    var historicVisibility:VisibilityType!
    var hasVehicle:Bool!
    var eventsNotifications:Bool!
    var placesNotifications:Bool!
    var canBeLocalized:Bool!
    
    class func sharedInstance() -> UserConfigurations {
        self.instance = (self.instance ?? UserConfigurations())
        return self.instance
    }
    
}

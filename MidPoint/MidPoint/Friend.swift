//
//  Friends.swift
//  MidPoint
//
//  Created by William Alvelos on 08/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Friend: NSObject {
    //normal Login
    var name: String?
    var location: CLLocationCoordinate2D?
    var email: String?
    var image: NSURL?
    
    //Login with API
    var userNameTwitter: String?
    var userIdTwitter: String?
    var userNameFacebook: String?
    var userIdFacebook: String?
    
    
    init(name: String, location: CLLocationCoordinate2D, email:String, image: NSURL){
        self.name = name
        self.location = location
        self.email = email
        self.image = image
    }
    
    //init for FB
    init(userNameFB: String, userIdFB: String){
        self.userIdFacebook = userIdFB
        self.userNameFacebook = userNameFB
    }
    
    //init for Twitter
    init(userNameTwitter: String, userIdTwitter:String){
        self.userNameTwitter = userNameTwitter
        self.userIdTwitter = userIdTwitter
    
    }
    
    
    override init(){
        
    }
    
    
    
}
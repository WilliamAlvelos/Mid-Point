//
//  User.swift
//  MidPoint
//
//  Created by William Alvelos on 07/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation
import UIKit

class User: NSObject {
    
    var name: String?
    var email: String?
    var image: UIImage?
    var id : Int?
    
    //facebook login
    var userIdFacebook: String?
    var userNameFacebook: String?
    
    //twitter login
    var userIdTwitter: String?
    var userNameTwitter: String?
    
    
    init(name: String, email:String, image: UIImage){
        self.name = name
        self.email = email
        self.image = image
    }
    
    init(name: String, email:String, id: Int){
        self.name = name
        self.email = email
        self.id = id
    }
    
    init(name:String, email:String) {
        self.name = name
        self.email = email
        
    }
    //init with Facebook
    init(userIdFacebook: String, userNameFacebook: String){
        self.userIdFacebook = userIdFacebook
        self.userNameFacebook = userNameFacebook
    }
    //init with Twitter
    init(userIdTwitter: String, userNameTwitter: String){
        self.userIdTwitter = userIdTwitter
        self.userNameTwitter = userNameTwitter
    }
    
    init(id:Int) {
        self.id = id        
    }
    override init(){
        
    }
    

    
}

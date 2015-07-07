//
//  User.swift
//  MidPoint
//
//  Created by William Alvelos on 07/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation

class User: NSObject {
    
    var name: String?
    var password: String?
    var email: String?
    var image: NSData?
    
    
    
    init(name: String, password: String, email:String){
        self.name = name
        self.password = password
        self.email = email
    }
    
    
    init(name:String, password:String) {
        self.name = name
        self.password = password
        
    }
    
    override init(){
        
    }
    

    
}

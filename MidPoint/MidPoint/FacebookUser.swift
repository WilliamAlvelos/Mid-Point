//
//  FacebookUser.swift
//  MidPoint
//
//  Created by Danilo Mative on 22/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import UIKit

class FacebookUser: NSObject {
   
    var name:String!
    var id:String!
    
    convenience init(name:String!,id:String!) {
        self.init()
        self.name = name
        self.id = id
    }
    
}

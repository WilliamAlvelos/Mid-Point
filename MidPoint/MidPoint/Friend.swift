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
    
    var name: String?
    var location: CLLocationCoordinate2D?
    var email: String?
    var image: NSURL?
    
    
    init(name: String, location: CLLocationCoordinate2D, email:String, image: NSURL){
        self.name = name
        self.location = location
        self.email = email
        self.image = image
    }
    
    override init(){
        
    }
    
    
    
}
//
//  Conversa.swift
//  
//
//  Created by William Alvelos on 16/07/15.
//
//

import Foundation
import UIKit

class Conversa: NSObject{
    var title:String?
    var image:NSURL?
    var subtitle:String?
    var id:String?
    
    
    init(id:String,title: String, subtitle:String){
        self.id = id
        self.title = title
        self.subtitle = subtitle
    }
}
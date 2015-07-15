//
//  Evento.swift
//  MidPoint
//
//  Created by William Alvelos on 12/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation

import UIKit

class Event: NSObject {
    
    var name: String?
    var descricao: String?
    var date: NSDate?
    var image: NSURL?
    var id: Int?
    override init(){

    }
    
    init(name: String){
        self.name = name
    }

    
}
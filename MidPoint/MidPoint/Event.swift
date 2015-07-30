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
    var image: UIImage?
    var id: Int?
    var numberOfPeople:Int?
    var numberOfConfirmed:Int?
    var numberOfRefused:Int?
    var numberOfPending:Int?
    var localizacao :Localizacao?
    

    override init() {
        
    }
    init(name: String){
        self.name = name
    }
    init(name: String, id: Int, descricao: String){
        self.name = name
        self.id = id
        self.descricao = descricao
    }

    
}
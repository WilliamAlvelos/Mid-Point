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
    var avaliacao: Int?
    var local: String?
    var horario: String?
    var image: NSURL?

    
    override init(){
    
    
    }
    
    init(name: String, avaliacao: Int, local: String, horario: String, image: NSURL){
        self.name = name
        self.avaliacao = avaliacao
        self.local = local
        self.horario = horario
        self.image = image
    }
}
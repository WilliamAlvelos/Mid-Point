//
//  Localizacao.swift
//  MidPoint
//
//  Created by Joao Sisanoski on 7/30/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation

class Localizacao: NSObject{
    var latitude: Float?
    var longitude: Float?
    var name: String?
    var streetName: String?
    class func LocationNull()->Localizacao{
        let localizacao = Localizacao()
        localizacao.longitude = -1
        localizacao.latitude = -1
        return localizacao
    }
    override init(){
        super.init()
    }
}
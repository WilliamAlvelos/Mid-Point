//
//  EventDAO.swift
//  MidPoint
//
//  Created by William Alvelos on 13/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation

enum EventOption {
    case Create
    case Edit
    case Save
    case Get
}

protocol EventoDAOProtocol{
    func saveEvent(event:Event, usuario: User)
    func getEvent(event:Event, usuario: User)
    
}
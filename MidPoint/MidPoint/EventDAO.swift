//
//  EventDAO.swift
//  MidPoint
//
//  Created by William Alvelos on 13/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation

enum Option: Int {
    case Pending = 1, Refused, Accepted, Passed, Owner, All
}

protocol EventoDAOProtocol{
    func saveEvent(event:Event, usuario: User)
    
}
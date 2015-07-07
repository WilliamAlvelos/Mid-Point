//
//  UserDAO.swift
//  MidPoint
//
//  Created by William Alvelos on 07/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation
enum Option {
    case Create
    case Edit
    case Save
    case Get
}
protocol UserDAOProtocol{
    func createUser()->User
    func saveUser(user:User)
    func getUser(user: User, option : Option)
    
}
//
//  UserDAO.swift
//  MidPoint
//
//  Created by William Alvelos on 07/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation

protocol UserDAOProtocol{
    func createUser()->User
    func saveUser(user:User)
    func getUser(user: User)
    
}
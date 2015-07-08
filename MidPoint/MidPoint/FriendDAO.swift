//
//  FriendsDAO.swift
//  MidPoint
//
//  Created by William Alvelos on 08/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation

enum FriendOption {
    case Create
    case Edit
    case Save
    case Get
}
protocol FriendDAOProtocol{
    func saveFriend(friend:Friend)
    func getFriend(friend: Friend)
}
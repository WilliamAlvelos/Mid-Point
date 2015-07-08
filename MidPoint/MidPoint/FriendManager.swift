//
//  FriendManager.swift
//  MidPoint
//
//  Created by William Alvelos on 08/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation
import UIKit

@objc protocol FriendManagerDelegate{
    func errorThrowed(error: NSError)
    func friendStillInserted(friend: Friend)
    func saveFriendFinished(friend: Friend)
    func friendNotFound(friend : Friend)
    func getFriendFinished(friend: Friend)
}

class FriendManager: FriendDAOCloudKitDelegate{
    
    private var friendDao: FriendDAOCloudKit?
    
    var delegate:FriendManagerDelegate?
    
    init(){
        friendDao = FriendDAOCloudKit()
        friendDao?.delegate = self
    }
    
    
    func errorThrowed(error: NSError){
        self.delegate?.errorThrowed(error)
    }
    
    func friendStillInserted(friend: Friend){
        self.delegate?.friendStillInserted(friend)
    }
    
    func saveFriendFinished(friend: Friend){
        self.delegate?.saveFriendFinished(friend)
    }
    
    
    func friendNotFound(friend : Friend){
        self.delegate?.friendNotFound(friend)
    }
    func getFriendFinished(friend: Friend){
        self.delegate?.getFriendFinished(friend)
    }

    
    func createFriend()->Friend{
        return Friend()
    }
    
    func insertFriendDatabase(friend:Friend){
        friendDao?.saveFriend(friend)
    }
    
    func getFriendDatabase(friend:Friend){
        friendDao?.getFriend(friend)
    }
    
    
}

//
//  FriendDAOCloudKit.swift
//  MidPoint
//
//  Created by William Alvelos on 08/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

protocol FriendDAOCloudKitDelegate{
    func errorThrowed(error: NSError)
    func friendStillInserted(friend: Friend)
    func saveFriendFinished(friend: Friend)
    func friendNotFound(friend : Friend)
    func getFriendFinished(friend: Friend)
}

class FriendDAOCloudKit: NSObject, FriendDAOProtocol{
    
    private var container: CKContainer
    private var publicDB: CKDatabase
    
    var delegate: FriendDAOCloudKitDelegate!
    
    override init(){
        container = CKContainer.defaultContainer()
        publicDB = container.publicCloudDatabase
    }
    
    
    
    private func getFriend(friend:Friend, option : FriendOption, predicate : NSPredicate){
        
        var query = CKQuery(recordType: "AMIGOS", predicate: predicate)
        self.publicDB.performQuery(query, inZoneWithID: nil , completionHandler: { (records: [AnyObject]!, error : NSError!) in
            if error != nil{
                self.Dispatcher({
                    self.delegate.errorThrowed(error)
                })
                
            }
                
            else{
                if option == .Save{
                    if records.count == 0{
                        self.performQuery(friend)
                    }else{
                        self.Dispatcher({
                            self.delegate.friendStillInserted(friend)
                        })
                    }
                }
                else if option == .Get{
                    if records.count == 0{
                        self.Dispatcher({
                            self.delegate.friendNotFound(friend)
                        })
                        
                        
                    }else{
                        var client : Friend = Friend()
                        
                        client.name = records[0].objectForKey("nome") as? String
                        client.email = records[0].objectForKey("email") as? String
                        client.image = records[0].objectForKey("imagem") as? NSURL
                        
                        self.Dispatcher({
                            self.delegate.getFriendFinished(client)
                        })
                    }
                }
                
                
            }
            
        })
        
    }
    private func Dispatcher(functionToRunOnMainThread: () -> ())
    {
        dispatch_async(dispatch_get_main_queue(), functionToRunOnMainThread)
    }
    
    
    private func performQuery(friend: Friend){
        var record:CKRecord = CKRecord(recordType: "AMIGOS")
        record.setObject(friend.name, forKey: "nome")
        record.setObject(friend.email, forKey: "email")
        var asset:CKAsset = CKAsset(fileURL: friend.image)
        record.setObject(asset, forKey: "imagem")
        
        self.publicDB.saveRecord(record, completionHandler: { (record:CKRecord!, error:NSError!) -> Void in
            
            if error != nil{
                self.Dispatcher({
                    self.delegate.errorThrowed(error)
                })
                
                
            }else{
                self.Dispatcher({
                    self.delegate.saveFriendFinished(friend)
                })
                
            }
            
        })
        
    }
    
    func saveFriend(friend: Friend){
        var predicate = NSPredicate(format: "email = %@ ", friend.email!, friend.name!)
        self.getFriend(friend, option: .Save, predicate : predicate)
        
    }
    
    func getFriend(friend: Friend){
        var predicate = NSPredicate(format: "email = %@", friend.email!)
        
        self.getFriend(friend, option: .Get, predicate : predicate)
    }
    
    
}
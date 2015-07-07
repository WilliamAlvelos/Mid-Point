//
//  UserDAOCloudKit.swift
//  MidPoint
//
//  Created by William Alvelos on 07/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation
import CloudKit


protocol UserDAOCloudKitDelegate{
    func errorThrowed(error: NSError)
    func userStillInserted(user: User)
    func saveUserFinished(user: User)
    func userNotFound(user : User)
    func getUserFinished(user: User)
}

class UserDAOCloudKit: NSObject, UserDAOProtocol {
    
    private var container: CKContainer
    private var publicDB: CKDatabase
    
    var delegate: UserDAOCloudKitDelegate!
    
    override init(){
        container = CKContainer.defaultContainer()
        publicDB = container.publicCloudDatabase
    }

    

   private func getUser(user:User, option : Option){
        var predicate = NSPredicate(format: "email = %@ && senha = %@", user.email!, user.password!)
        var query = CKQuery(recordType: "USUARIO", predicate: predicate)
        self.publicDB.performQuery(query, inZoneWithID: nil , completionHandler: { (records: [AnyObject]!, error : NSError!) in
            if error != nil{
                self.runDelegateOnMainThread(Selector("self.delegate.errorThrowed(error)"))

                
            }
            
            else{
                if option == .Save{
                    if records.count == 0{
                        self.performQuery(user)
                    }else{
                        self.runDelegateOnMainThread(Selector("self.delegate.userStillInserted(user)"))

                        
                        
                    }
                }
                else if option == .Get{
                    if records.count == 0{
                        self.runDelegateOnMainThread(Selector("self.delegate.userNotFound(user)"))

                        
                    }else{
                        var client : User = User()
                        
                        client.name = records[0].objectForKey("nome") as? String
                        client.email = records[0].objectForKey("email") as? String
                        client.password = records[0].objectForKey("senha") as? String
                        self.runDelegateOnMainThread(Selector("self.delegate.getUserFinished(client)"))
                    }
                }
                
                
            }
            
        })
    
    }
    private func runDelegateOnMainThread(selector : Selector){
        dispatch_async(dispatch_get_main_queue(), {
            selector
        })
        
    }
    private func performQuery(user: User){
        var record:CKRecord = CKRecord(recordType: "USUARIO")
        record.setObject(user.name, forKey: "nome")
        record.setObject(user.email, forKey: "email")
        record.setObject(user.password, forKey: "senha")
        
        self.publicDB.saveRecord(record, completionHandler: { (record:CKRecord!, error:NSError!) -> Void in
            
            if error != nil{
                self.runDelegateOnMainThread(Selector("self.delegate.errorThrowed(error)"))

                
            }else{
               
                self.runDelegateOnMainThread(Selector("self.delegate.saveUserFinished(user)"))

            }
            
        })

    }

    func saveUser(user: User){
        var predicate = NSPredicate(format: "email = %@", user.email!)
        self.getUser(user, option: .Save)
        
    }
    
    func getUser(user: User){
        self.getUser(user, option: .Get)
    }
    
    
}

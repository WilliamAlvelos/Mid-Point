//
//  UserDAOCloudKit.swift
//  MidPoint
//
//  Created by William Alvelos on 07/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation
import UIKit

protocol UserDAOCloudKitDelegate{
    func errorThrowed(error: NSError)
    func userStillInserted(user: User)
    func saveUserFinished(user: User)
    func userNotFound(user : User)
    func getUserFinished(user: User)
}

class UserDAOCloudKit: NSObject, UserDAOProtocol{
    

    var delegate: UserDAOCloudKitDelegate!
    


    func saveUser(user: User, password : String){
        let url : String = "http://www.alvelos.wc.lt/MidPoint/cadastro.php"
        let bodyHttp = String(format: "email=%@&password=%@&name=%@", user.email!,password,user.name!)
        JsonResponse.createMutableRequest(url, bodyHttp: bodyHttp, completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if (error != nil) {
                self.delegate.errorThrowed(error)
               
                return
            }
            let datastring = NSString(data: data, encoding:NSUTF8StringEncoding)

            let string = JsonResponse.parseJSON(data)
        
            if (string.objectForKey("error") != nil){
                var int = string.objectForKey("error")! as! Int
                let error : NSError = NSError(domain: "Erro", code: int, userInfo: nil)
                self.delegate.errorThrowed(error)
                return
            }
            if (string.objectForKey("succesfull") != nil){
                var id = (string.objectForKey("id")! as! String).toInt()
                user.id = id
                self.delegate.saveUserFinished(user)
                return
            }
            
        })

    }
    
    func getUser(user: User, password : String){

        let url : String = "http://alvelos.wc.lt/MidPoint/login.php"
        let bodyHttp = String(format: "password=%@&email=%@", password ,user.email!)
        JsonResponse.createMutableRequest(url, bodyHttp: bodyHttp, completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if (error != nil) {
                self.delegate.errorThrowed(error)
                
                return
            }
            let string = JsonResponse.parseJSON(data)
            if (string.objectForKey("error") != nil){
                var int = string.objectForKey("error")! as! Int
                let error : NSError = NSError(domain: "Erro", code: int, userInfo: nil)
                self.delegate.errorThrowed(error)
            }
            else {
                let name = string.objectForKey("name") as! String
                let email = string.objectForKey("email") as! String
                let id = (string.objectForKey("id")! as! NSString).integerValue

                self.delegate.getUserFinished(User(name: name, email: email, id: id))
            }
            
            
        })
    
    }

    
    
}

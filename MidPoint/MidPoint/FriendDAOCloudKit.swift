//
//  FriendDAOCloudKit.swift
//  MidPoint
//
//  Created by William Alvelos on 08/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation
protocol FriendDAODelegate{
    func errorThrowed(error: NSError)
    func getUsersFinished(users: Array<User>)
}
class FriendDAOCloudKit{
    var delegate: FriendDAODelegate?
    
    func getUsersWithName(name: String) {
        
        let url : String = "\(LinkAccessGlobalConstants.LinkUsers)buscaUsuario.php"
        let bodyHttp = String(format: "\(UserGlobalConstants.Name)=%@", name)
        JsonResponse.createMutableRequest(url, bodyHttp: bodyHttp, completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if (error != nil) {
                DispatcherClass.dispatcher({ () -> () in
                    self.delegate?.errorThrowed(error)
                })
                return
            }
            
            let array = JsonResponse.parseJSONToArray(data)
            var arrayToReturn :[User]? = Array()
            for dataString in array {
                if (dataString.objectForKey("error") != nil){
                    var int = dataString.objectForKey("error") as! Int
                    let error : NSError = NSError(domain: "Erro", code: int, userInfo: nil)
                    DispatcherClass.dispatcher({ () -> () in
                        self.delegate?.errorThrowed(error)
                    })
                    return
                }

                var id = (dataString.objectForKey("\(UserGlobalConstants.Id)") as! String).toInt()
                var name = dataString.objectForKey("\(UserGlobalConstants.Name)") as! String
                var user = User()
                user.id = id
                user.name = name
                arrayToReturn!.append(user)
            }
            DispatcherClass.dispatcher({ () -> () in
                self.delegate?.getUsersFinished(arrayToReturn!)
            })
            

            
        })
        
    }
   
}
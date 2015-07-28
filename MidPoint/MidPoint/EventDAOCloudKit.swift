//
//  EventDAOCloudKit.swift
//  MidPoint
//
//  Created by William Alvelos on 13/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation
import UIKit

protocol EventoDAOCloudKitDelegate{
    func errorThrowed(error: NSError)
    func saveEventFinished(event: Event)
    func eventNotFound(event : Event)
    func getEventFinished(event: Event)
    func getEventsFinished(events: Array<Event>)
    func inviteFinished(event: Event)

}


class EventDAOCloudKit: NSObject, EventoDAOProtocol{
    
    
    var delegate: EventoDAOCloudKitDelegate?
    
    func inviteFriendsToEvent(event: Event, sender: User, friends: Array<User>){
        var dictionary = JsonResponse.userToCall(friends)
        let url : String = "http://www.alvelos.wc.lt/MidPoint/events/inviteToEvent.php"
        let avent: String = JsonResponse.dictionaryToString(JsonResponse.userToCall(friends))
        var bodyHttp = String(format: "\(EventGlobalConstants.Id)=%d&\(EventGlobalConstants.UserToInvite)=%@&\(EventGlobalConstants.UserSender)=%d" , event.id!, avent , sender.id!)
        JsonResponse.createMutableRequest(url, bodyHttp: bodyHttp, completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if (error != nil) {
            DispatcherClass.dispatcher({ () -> () in
                    self.delegate?.errorThrowed(error)
            })

                return
            }

            let string = JsonResponse.parseJSON(data)
            
            if (string.objectForKey("error") != nil){
                let error : NSError = NSError(domain: "Erro", code: (string.objectForKey("error")! as! Int), userInfo: nil)
                DispatcherClass.dispatcher({ () -> () in
                    self.delegate?.errorThrowed(error)
                })

                return
            }
            
            
            if (string.objectForKey("succesfull") != nil){
                DispatcherClass.dispatcher({ () -> () in
                    self.delegate?.inviteFinished(event)
                })

                return
            }
        })
    }
    
    func saveEvent(event: Event, usuario: User) {
        
        let url : String = "http://www.alvelos.wc.lt/MidPoint/events/insereEvento.php"
        let bodyHttp = String(format: "\(EventGlobalConstants.Name)=%@&\(EventGlobalConstants.Description)=%@&\(EventGlobalConstants.Date)=%@&\(UserGlobalConstants.Id)=%d", event.name!,event.descricao!,event.date!, usuario.id!)
        JsonResponse.createMutableRequest(url, bodyHttp: bodyHttp, completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if (error != nil) {
                DispatcherClass.dispatcher({ () -> () in
                    self.delegate?.errorThrowed(error)
                })

                
                return
            }

            let string = JsonResponse.parseJSON(data)
        
            if (string.objectForKey("error") != nil){
                let error : NSError = NSError(domain: "Erro", code: (string.objectForKey("error")! as! Int), userInfo: nil)
                DispatcherClass.dispatcher({ () -> () in
                    self.delegate?.errorThrowed(error)
                })
                return
            }
            if (string.objectForKey("succesfull") != nil){
 
                event.id = (string.objectForKey("\(EventGlobalConstants.Id)") as! String).toInt()
                DispatcherClass.dispatcher({ () -> () in
                    self.delegate?.saveEventFinished(event)
                })
                return
            }
            
        })
        
    }
    func getEvent(user:User, usuario: Option){
        let url : String = "http://alvelos.wc.lt/MidPoint/events/busca.php"
        let bodyHttp = String(format: "\(UserGlobalConstants.Id)=%d&\(EventGlobalConstants.UserState)=%d", user.id!, usuario.rawValue)
        JsonResponse.createMutableRequest(url, bodyHttp: bodyHttp, completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if (error != nil) {
                DispatcherClass.dispatcher({ () -> () in
                    self.delegate?.errorThrowed(error)
                })

                return
            }

            let array = JsonResponse.parseJSONToArray(data)
            var arrayToReturn =  [Event]()
            for dataString in array {
                if (dataString.objectForKey("error") != nil){
                    var int = dataString.objectForKey("error") as! Int
                    let error : NSError = NSError(domain: "Erro", code: int, userInfo: nil)
                    DispatcherClass.dispatcher({ () -> () in
                        self.delegate?.errorThrowed(error)
                    })
                    return
                }
                
                var id = (dataString.objectForKey("\(EventGlobalConstants.Id)") as! String).toInt()
                var event_date = (dataString.objectForKey("\(EventGlobalConstants.Date)") as! String).toInt()
                var name = (dataString.objectForKey("\(EventGlobalConstants.Name)") as! String)
                var description = (dataString.objectForKey("\(EventGlobalConstants.Description)") as! String)


                var event = Event(name: name, id: id!, descricao: description)
                event.id = id
                
                arrayToReturn.append(event)
                
            }
            DispatcherClass.dispatcher({ () -> () in
                self.delegate?.getEventsFinished(arrayToReturn)
            })

            
        })

    }
    
   class  func uploadImageOne(image : UIImage){
        var imageData = UIImagePNGRepresentation(image)
        
        if imageData != nil{
            var request = NSMutableURLRequest(URL: NSURL(string:"http://alvelos.wc.lt/MidPoint/events/uploadImage.php")!)
            var session = NSURLSession.sharedSession()
            
            request.HTTPMethod = "POST"
            
            var boundary = String(format: "---------------------------14737809831466499882746641449")
            var contentType = String(format: "multipart/form-data; boundary=%@",boundary)
            //  println("Content Type \(contentType)")
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
            
            var body = NSMutableData.alloc()
            
            // Title
            body.appendData(String(format: "\r\n--%@\r\n",boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(String(format:"Content-Disposition: form-data; name=\"title\"\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Hello World".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
            
            // Title
            body.appendData(String(format: "\r\n--%@\r\n",boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(String(format:"Content-Disposition: form-data; name=\"title\"\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Hello World".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
            
            // Image
            body.appendData(String(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(String(format:"Content-Disposition: form-data; name=\"uploadedfile\"; filename=\"test.png\"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(String(format: "Content-Type: application/octet-stream\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(imageData)
            body.appendData(String(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
            
            
            
            request.HTTPBody = body
            
            
            var returnData = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
            
            var returnString = NSString(data: returnData!, encoding: NSUTF8StringEncoding)
            
            println("returnString \(returnString!)")
            
        }
        
        
    }
}

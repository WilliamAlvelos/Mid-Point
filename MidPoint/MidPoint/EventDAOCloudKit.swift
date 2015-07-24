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
    
    
    var delegate: EventoDAOCloudKitDelegate!
    
    func inviteFriendsToEvent(event: Event, sender: User, friends: Array<User>){
        var dictionary = JsonResponse.userToCall(friends)
        let url : String = "http://www.alvelos.wc.lt/MidPoint/events/inviteToEvent.php"
        let avent: String = JsonResponse.dictionaryToString(JsonResponse.userToCall(friends))
        var bodyHttp = String(format: "event_id=%d&user_to_invite=%@&sender=%d" , event.id!, avent , sender.id!)
        JsonResponse.createMutableRequest(url, bodyHttp: bodyHttp, completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if (error != nil) {
                self.delegate.errorThrowed(error)
                
                return
            }
            let datastring = NSString(data: data, encoding:NSUTF8StringEncoding)

            let string = JsonResponse.parseJSON(data)
            
            if (string.objectForKey("error") != nil){
                let error : NSError = NSError(domain: "Erro", code: (string.objectForKey("error")! as! Int), userInfo: nil)
                self.delegate.errorThrowed(error)
                return
            }
            
            
            if (string.objectForKey("succesfull") != nil){
                self.delegate.inviteFinished(event)
                return
            }
        })
    }
    
    func saveEvent(event: Event, usuario: User) {
        
        let url : String = "http://www.alvelos.wc.lt/MidPoint/events/insereEvento.php"
        let bodyHttp = String(format: "name=%@&description=%@&date=%@&usuario_id=%d", event.name!,event.descricao!,event.date!, usuario.id!)
        JsonResponse.createMutableRequest(url, bodyHttp: bodyHttp, completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if (error != nil) {
                self.delegate.errorThrowed(error)
                
                return
            }
            let string = JsonResponse.parseJSON(data)
        
            if (string.objectForKey("error") != nil){
                let error : NSError = NSError(domain: "Erro", code: (string.objectForKey("error")! as! Int), userInfo: nil)
                self.delegate.errorThrowed(error)
                return
            }
            if (string.objectForKey("succesfull") != nil){
 
                event.id = (string.objectForKey("id_evento") as! String).toInt()
                self.delegate.saveEventFinished(event)
                return
            }
            
        })
        
    }
    func getEvent(user:User, usuario: Option){
        let url : String = "http://alvelos.wc.lt/MidPoint/events/busca.php"
        let bodyHttp = String(format: "usuario_id=%d&usuario_state=%d", user.id!, usuario.rawValue)
        JsonResponse.createMutableRequest(url, bodyHttp: bodyHttp, completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if (error != nil) {
                self.delegate?.errorThrowed(error)
                return
            }
            let datastring = NSString(data: data, encoding:NSUTF8StringEncoding)

            let array = JsonResponse.parseJSONToArray(data)
            var arrayToReturn =  [Event]()
            for dataString in array {
                if (dataString.objectForKey("error") != nil){
                    var int = dataString.objectForKey("error") as! Int
                    let error : NSError = NSError(domain: "Erro", code: int, userInfo: nil)
                    self.delegate?.errorThrowed(error)
                    return
                }
                
                var id = (dataString.objectForKey("id") as! String).toInt()
                var event_date = (dataString.objectForKey("event_date") as! String).toInt()
                var name = (dataString.objectForKey("name") as! String)
                var description = (dataString.objectForKey("description") as! String)


                var event = Event(name: name, id: id!, descricao: description)
                event.id = id
                
                arrayToReturn.append(event)
                
            }
            self.delegate.getEventsFinished(arrayToReturn)

            
        })

    }

    func getEvent(event: Event) {
        
        let url : String = "http://alvelos.wc.lt/MidPoint/login.php"
        let bodyHttp = String(format: "name=%@&description=%@&date=%@", event.name!, event.descricao! ,event.date!)
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
                
                self.delegate.saveEventFinished(event)
            }
            
            
        })
        
    }
    
    
    
}

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
    //func inviteFinished(event: Event)
}

class EventDAOCloudKit: NSObject{
    var delegate: EventoDAOCloudKitDelegate?
    func getEventInformations(event: Event){
        
    }
//    func inviteFriendsToEvent(event: Event, sender: User, friends: Array<User>){
//        var dictionary = JsonResponse.userToCall(friends)
//        let url : String = "\(LinkAccessGlobalConstants.LinkEvents)inviteToEvent.php"
//        let avent: String = JsonResponse.dictionaryToString(JsonResponse.userToCall(friends))
//        var bodyHttp = String(format: "\(EventGlobalConstants.Id)=%d&\(EventGlobalConstants.UserToInvite)=%@&\(EventGlobalConstants.UserSender)=%d" , event.id!, avent , sender.id!)
//        JsonResponse.createMutableRequest(url, bodyHttp: bodyHttp, completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
//            if (error != nil) {
//            DispatcherClass.dispatcher({ () -> () in
//                    self.delegate?.errorThrowed(error)
//            })
//
//                return
//            }
//
//            let string = JsonResponse.parseJSON(data)
//            
//            if (string.objectForKey("error") != nil){
//                let error : NSError = NSError(domain: "Erro", code: (string.objectForKey("error")! as! Int), userInfo: nil)
//                DispatcherClass.dispatcher({ () -> () in
//                    self.delegate?.errorThrowed(error)
//                })
//
//                return
//            }
//            
//            
//            if (string.objectForKey("succesfull") != nil){
//                DispatcherClass.dispatcher({ () -> () in
//                    self.delegate?.inviteFinished(event)
//                })
//
//                return
//            }
//        })
//    }
//    
    func saveEvent(event: Event, usuario: User, friends: Array<User>, localizacaoUsuario: Localizacao ) {
        let users_to_invite: String = "\(EventGlobalConstants.UserToInvite)=\(JsonResponse.dictionaryToString(JsonResponse.userToCall(friends)))"
        let event_name = "\(EventGlobalConstants.Name)=\(event.name!)"
        let event_description = "\(EventGlobalConstants.Description)=\(event.descricao!)"
        let event_date = "\(EventGlobalConstants.Date)=\(event.date!)"
        let user_id = "\(UserGlobalConstants.Id)=\(usuario.id!)"
        let event_latitude = "\(EventGlobalConstants.Latitude)=\(event.localizacao!.latitude!)"
        let event_longitude = "\(EventGlobalConstants.Longitude)=\(event.localizacao!.longitude!)"
        let user_latitude = "\(UserGlobalConstants.Latitude)=\(localizacaoUsuario.latitude!)"
        let user_longitude = "\(UserGlobalConstants.Longitude)=\(localizacaoUsuario.longitude!)"
        let url : String = "\(LinkAccessGlobalConstants.LinkEvents)insereEvento.php"
        let bodyHttp = "\(users_to_invite)&\(event_name)&\(event_description)&\(event_date)&\(user_id)&\(event_latitude)&\(event_longitude)&\(user_latitude)&\(user_longitude)"
        JsonResponse.createMutableRequest(url, bodyHttp: bodyHttp, completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if (error != nil) {
                DispatcherClass.dispatcher({ () -> () in
                    self.delegate?.errorThrowed(error)
                })

                
                return
            }
            var dataString = NSString(data: data, encoding:NSUTF8StringEncoding)
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
    func getEventsFromUser(user:User, usuario: Option){
        let url : String = "\(LinkAccessGlobalConstants.LinkEvents)busca.php"
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
                
                var number = dataString[EventGlobalConstants.Number] as! NSDictionary
                
                var accepted = number[EventGlobalConstants.Accepted] as! Int
                var total = number[EventGlobalConstants.Total] as! Int
                var pending = number[EventGlobalConstants.Pending] as! Int
                var refused = number[EventGlobalConstants.Refused] as! Int
                
                var id = (dataString.objectForKey("\(EventGlobalConstants.Id)") as! String).toInt()
                var event_date = (dataString.objectForKey("\(EventGlobalConstants.Date)") as! String).toInt()
                var name = (dataString.objectForKey("\(EventGlobalConstants.Name)") as! String)
                var description = (dataString.objectForKey("\(EventGlobalConstants.Description)") as! String)
                var latitude = (dataString.objectForKey("\(EventGlobalConstants.Latitude)") as! NSString).doubleValue
                var longitude = (dataString.objectForKey("\(EventGlobalConstants.Longitude)") as! NSString).doubleValue
                
                var midPoint : Localizacao = Localizacao()
                midPoint.latitude = Float(latitude)
                midPoint.longitude = Float(longitude)
                midPoint.name = name
                

                var event = Event(name: name, id: id!, descricao: description)
                event.id = id
                event.numberOfConfirmed = accepted
                event.numberOfPending = pending
                event.numberOfPeople = total
                event.numberOfRefused = refused
                event.localizacao = midPoint
                
                
                arrayToReturn.append(event)
                
            }
            DispatcherClass.dispatcher({ () -> () in
                self.delegate?.getEventsFinished(arrayToReturn)
            })

            
        })
    }
    func downloadImage(id : Int)->UIImage?{
        let url = NSURL(string:"\(LinkAccessGlobalConstants.LinkImagesEvents)\(id).jpg")
        let request = NSMutableURLRequest(URL: url!)
        request.timeoutInterval = 4
        var response: NSURLResponse?
        var error: NSError?
        let urlData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
    
        if urlData == nil || error != nil  || NSString(data: urlData!, encoding:NSUTF8StringEncoding) != nil {
            return UIImage(named: "logo")
        }
        return UIImage(data: urlData!)
    }
    
    
}

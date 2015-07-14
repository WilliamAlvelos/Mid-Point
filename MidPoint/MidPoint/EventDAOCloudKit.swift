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
    func eventStillInserted(event: Event)
    func saveEventFinished(event: Event)
    func eventNotFound(event : Event)
    func getEventFinished(event: Event)
}


class EventDAOCloudKit: NSObject, EventoDAOProtocol{
    
    
    var delegate: EventoDAOCloudKitDelegate!
    
    
    func parseJSON(inputData: NSData) -> NSDictionary{
        var error: NSError?
        var boardsDictionary:  NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
        return boardsDictionary
    }
    
    private func createMutableRequest(url : String, bodyHttp : String, completionHandler handler: (NSURLResponse!, NSData!, NSError!) -> Void){
        
        var url : NSURL  = NSURL(string: url)!
        var mutableRequest: NSMutableURLRequest  = NSMutableURLRequest(URL: url)
        mutableRequest.cachePolicy = .UseProtocolCachePolicy
        mutableRequest.timeoutInterval = 10.0
        mutableRequest.HTTPBody = bodyHttp.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        mutableRequest.HTTPMethod = "POST"
        let queue:NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(mutableRequest, queue: queue, completionHandler: handler)
        
    }
    func saveEvent(event: Event) {
        
        let url : String = "http://www.alvelos.wc.lt/MidPoint/evento.php"
        let bodyHttp = String(format: "name=%@&description=%@&date=%@", event.name!,event.descricao!,event.date!)
        createMutableRequest(url, bodyHttp: bodyHttp, completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if (error != nil) {
                self.delegate.errorThrowed(error)
                
                return
            }
            let string = self.parseJSON(data)
            if (string.objectForKey("error") != nil){
                var int = string.objectForKey("error")! as! Int
                let error : NSError = NSError(domain: "Erro", code: int, userInfo: nil)
                self.delegate.errorThrowed(error)
                return
            }
            if (string.objectForKey("succesfull") != nil){
                self.delegate.saveEventFinished(event)
                return
            }
            
        })
        
    }
    
    func getEvent(event: Event) {
        
        let url : String = "http://alvelos.wc.lt/MidPoint/login.php"
        let bodyHttp = String(format: "name=%@&description=%@&date=%@", event.name!, event.descricao! ,event.date!)
        createMutableRequest(url, bodyHttp: bodyHttp, completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if (error != nil) {
                self.delegate.errorThrowed(error)
                return
            }
            let string = self.parseJSON(data)
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

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
    func getUsersFinished(users: Array<User>)
    func getLocationFinished(users: Array<Localizacao>)
    func updateStateFinished()
    func updateLocationFinished()
    func insertLocationFinished()
    
}

class UserDAOCloudKit: NSObject, UserDAOProtocol{
    
    
    var delegate: UserDAOCloudKitDelegate?
    
    
    
    func saveUser(user: User, password : String){
        let url : String = "\(LinkAccessGlobalConstants.LinkUsers)cadastro.php"
        let bodyHttp = String(format: "\(UserGlobalConstants.Email)=%@&\(UserGlobalConstants.Password)=%@&\(UserGlobalConstants.Name)=%@", user.email!,password,user.name!)
        JsonResponse.createMutableRequest(url, bodyHttp: bodyHttp, completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if (error != nil) {
                DispatcherClass.dispatcher({ () -> () in
                    self.delegate?.errorThrowed(error)
                })
                return
            }
            
            let string = JsonResponse.parseJSON(data)
            
            if (string.objectForKey("error") != nil){
                var int = string.objectForKey("error")! as! Int
                let error : NSError = NSError(domain: "Erro", code: int, userInfo: nil)
                DispatcherClass.dispatcher({ () -> () in
                    self.delegate?.errorThrowed(error)
                })
                return
            }
            if (string.objectForKey("succesfull") != nil){
                var id = (string.objectForKey("\(UserGlobalConstants.Id)")! as! String).toInt()
                user.id = id
                DispatcherClass.dispatcher({ () -> () in
                    self.delegate?.saveUserFinished(user)
                })
                return
            }
            
        })
        
    }
    
    func getUser(user: User, password : String){
        
        let url : String = "\(LinkAccessGlobalConstants.LinkUsers)login.php"
        let bodyHttp = String(format: "\(UserGlobalConstants.Password)=%@&\(UserGlobalConstants.Email)=%@", password ,user.email!)
        JsonResponse.createMutableRequest(url, bodyHttp: bodyHttp, completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if (error != nil) {
                print(error.code)
                DispatcherClass.dispatcher({ () -> () in
                    self.delegate?.errorThrowed(error)
                })
                return
            }
            let string = JsonResponse.parseJSON(data)
            if (string.objectForKey("error") != nil){
                var int = string.objectForKey("error")! as! Int
                let error : NSError = NSError(domain: "Erro", code: int, userInfo: nil)
                DispatcherClass.dispatcher({ () -> () in
                    self.delegate?.errorThrowed(error)
                })
            }
            else {
                let name = string.objectForKey("\(UserGlobalConstants.Name)") as! String
                let email = string.objectForKey("\(UserGlobalConstants.Email)") as! String
                let id = (string.objectForKey("\(UserGlobalConstants.Id)")! as! NSString).integerValue
                
                
                DispatcherClass.dispatcher({ () -> () in
                    self.delegate?.getUserFinished(User(name: name, email: email, id: id))
                })
            }
            
            
        })
        
    }
    
    func getUsersWithName(name: String) {
        
        let emailCurrent = UserDAODefault.getLoggedUser().email
        
        let url : String = "\(LinkAccessGlobalConstants.LinkUsers)buscaUsuario.php"
        let bodyHttp = String(format: "\(UserGlobalConstants.Name)=%@&\(UserGlobalConstants.Email)=%@", name, emailCurrent!)
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
    func getUsersFrom(event: Event) {
        
        let url : String = "\(LinkAccessGlobalConstants.LinkUsers)busca.php"
        let bodyHttp = String(format: "\(EventGlobalConstants.Id)=%d", event.id!)
        JsonResponse.createMutableRequest(url, bodyHttp: bodyHttp, completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if (error != nil) {
                DispatcherClass.dispatcher({ () -> () in
                    self.delegate?.errorThrowed(error)
                })
                return
            }
            var dataString = NSString(data: data, encoding:NSUTF8StringEncoding)
            
            
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
                var latitude = (dataString[UserGlobalConstants.Latitude]  as! NSString).doubleValue
                var longitude = (dataString[UserGlobalConstants.Longitude]  as! NSString).doubleValue
                var state = (dataString[EventGlobalConstants.UserState] as! String).toInt()
                
                let stateFinal = State()
                stateFinal.event = event
                stateFinal.state = Option(rawValue: state!)
                //ver como funciona o state
                
                let localizacao = Localizacao()
                localizacao.latitude = Float(latitude)
                localizacao.longitude = Float(longitude)
                
                var user = User()
                user.id = id
                user.name = name
                user.location = localizacao
                user.state = stateFinal
                arrayToReturn!.append(user)
            }
            DispatcherClass.dispatcher({ () -> () in
                self.delegate?.getUsersFinished(arrayToReturn!)
            })
            
            
            
        })
        
    }
    func downloadImage(id : Int)->UIImage?{
        let url = NSURL(string:"\(LinkAccessGlobalConstants.LinkImagesUsers)\(id).jpg")
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
    
    func updateUserLocationAndState(user: User , location : Localizacao?, event : Event, state: Option){
        let url : String = "\(LinkAccessGlobalConstants.LinkUsers)updateLocationUser.php"
        var bodyHttp :String = ""
        if (location == nil ){
            bodyHttp = String(format: "\(UserGlobalConstants.Id)=%d&\(EventGlobalConstants.Id)=%d&\(EventGlobalConstants.UserState)=%d", user.id! ,event.id!, state.rawValue)
            
        }
        else {
            bodyHttp = String(format: "\(UserGlobalConstants.Id)=%d&\(EventGlobalConstants.Id)=%d&\(UserGlobalConstants.Latitude)=%f&\(UserGlobalConstants.Longitude)=%f&\(LocationGlobalConstants.NameLocation)=%@&\(EventGlobalConstants.UserState)=%d", user.id! ,event.id!, location!.latitude!, location!.longitude!, location!.name!, state.rawValue)
        }
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
                var int = string.objectForKey("error")! as! Int
                let error : NSError = NSError(domain: "Erro", code: int, userInfo: nil)
                DispatcherClass.dispatcher({ () -> () in
                    self.delegate?.errorThrowed(error)
                })
                return
            }
            if (string.objectForKey("succesfull") != nil){
                // pegar aqui o valor do novo mid point
                DispatcherClass.dispatcher({ () -> () in
                    self.delegate?.updateLocationFinished()
                })
                return
            }
            
            
        })
    }
    func getAllLocation(user: User){
        let url : String = "\(LinkAccessGlobalConstants.LinkUsers)buscaLocalizacao.php"
        let bodyHttp = String(format: "\(UserGlobalConstants.Id)=%d", user.id!)
        JsonResponse.createMutableRequest(url, bodyHttp: bodyHttp, completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if (error != nil) {
                DispatcherClass.dispatcher({ () -> () in
                    self.delegate?.errorThrowed(error)
                })
                return
            }
            var dataString = NSString(data: data, encoding:NSUTF8StringEncoding)
            
            let array = JsonResponse.parseJSONToArray(data)
            var arrayToReturn :[Localizacao]? = Array()
            
            for dataString in array {
                if (dataString.objectForKey("error") != nil){
                    var int = dataString.objectForKey("error") as! Int
                    let error : NSError = NSError(domain: "Erro", code: int, userInfo: nil)
                    DispatcherClass.dispatcher({ () -> () in
                        self.delegate?.errorThrowed(error)
                    })
                    return
                }
                if (dataString.objectForKey("empty") != nil){
                    DispatcherClass.dispatcher({ () -> () in
                        self.delegate?.getLocationFinished(arrayToReturn!)
                    })
                    return
                }
                
                
                var nameLocation = dataString[LocationGlobalConstants.LocationName] as! String
                var latitude = (dataString[LocationGlobalConstants.Latitude] as! NSString).floatValue
                var longitude = (dataString[LocationGlobalConstants.Longitude] as! NSString).floatValue
                
                let localizacao = Localizacao()
                localizacao.longitude = longitude
                localizacao.latitude = latitude
                localizacao.name = nameLocation
                
                
                
                arrayToReturn!.append(localizacao)
            }
            DispatcherClass.dispatcher({ () -> () in
                self.delegate?.getLocationFinished(arrayToReturn!)
            })
            
            
            
        })
    }
    func insereNovaLocalizacao(user: User, localizacao : Localizacao){
        let url : String = "\(LinkAccessGlobalConstants.LinkUsers)insereNovaLocalizacao.php"
        let bodyHttp = String(format: "\(UserGlobalConstants.Id)=%d&\(LocationGlobalConstants.Latitude)=%f&\(LocationGlobalConstants.Longitude)=%f&\(LocationGlobalConstants.LocationName)=%@", user.id!, localizacao.latitude!, localizacao.longitude!, localizacao.name!)
        JsonResponse.createMutableRequest(url, bodyHttp: bodyHttp, completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if (error != nil) {
                DispatcherClass.dispatcher({ () -> () in
                    self.delegate?.errorThrowed(error)
                })
                return
            }
            var dataString = NSString(data: data, encoding:NSUTF8StringEncoding)
            
            let array = JsonResponse.parseJSON(data)
            
            if (array.objectForKey("error") != nil){
                var int = array.objectForKey("error") as! Int
                let error : NSError = NSError(domain: "Erro", code: int, userInfo: nil)
                DispatcherClass.dispatcher({ () -> () in
                    self.delegate?.errorThrowed(error)
                })
                return
            }
            
            DispatcherClass.dispatcher({ () -> () in
                self.delegate?.insertLocationFinished()
            })
            
            
            
            
        })
        
    }
}

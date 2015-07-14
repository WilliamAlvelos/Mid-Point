//
//  JsonCreate.swift
//  MidPoint
//
//  Created by Joao Sisanoski on 7/14/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation
class JsonResponse {
    class func userToCall(users: [User]) -> [Dictionary<String, NSNumber>] {
        var dictPoints: [Dictionary<String, NSNumber>] = []
        for user in users{
            var dictPoint =  [
                "user": NSNumber(integer: user.id!),
                ]
            dictPoints.append(dictPoint)
        }
        return dictPoints
    }
    class func dictionaryToString(dic : [Dictionary<String, NSNumber>])->String{
        let theJSONData = NSJSONSerialization.dataWithJSONObject(
             dic,
            options: NSJSONWritingOptions(0),
            error: nil)
        let theJSONText = NSString(data: theJSONData!,
            encoding: NSASCIIStringEncoding)
      return  String(theJSONText!)
    }
    class func parseJSON(inputData: NSData) -> NSDictionary{
        var error: NSError?
        var boardsDictionary:  NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
        return boardsDictionary
    }
    
    class func createMutableRequest(url : String, bodyHttp : String, completionHandler handler: (NSURLResponse!, NSData!, NSError!) -> Void){
        
        var url : NSURL  = NSURL(string: url)!
        var mutableRequest: NSMutableURLRequest  = NSMutableURLRequest(URL: url)
        mutableRequest.cachePolicy = .UseProtocolCachePolicy
        mutableRequest.timeoutInterval = 10.0
        mutableRequest.HTTPBody = bodyHttp.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        mutableRequest.HTTPMethod = "POST"
        let queue:NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(mutableRequest, queue: queue, completionHandler: handler)
    }
    class func createArrayFakeToTest(numberOfFake: Int)->Array<User>{
        var array: [User] = []
        for var i = 0 ; i < numberOfFake ; i++ {
            var user : User = User()
            user.id = i
            array.append(user)
        }
        return array
    }
}
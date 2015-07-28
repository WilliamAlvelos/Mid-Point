//
//  PictureCloudKit.swift
//  MidPoint
//
//  Created by Joao Sisanoski on 7/27/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation
protocol PictureCloudKitDelegate{
    func errorCloudKit(error: NSError)
    func progressUpload(float : Float)
    func saveImageFinished()
}
class PictureCloudKit : NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate{

    var saveImageUserConnection : NSURLConnection?
    var saveImageEventConnection : NSURLConnection?
    var delegate: PictureCloudKitDelegate?
    var data: NSData?
    override init(){
     
    }
    func downloadProfileImage(user: User){
        
    }
    func downloadEventImage(event: Event){
    }
    
    func uploadImageUser(user : User){
        var imageData = UIImageJPEGRepresentation(user.image, 0.5)
        
        if imageData != nil{
            var request = NSMutableURLRequest(URL: NSURL(string:"\(LinkAccessGlobalConstants.LinkUsers)uploadImage.php")!)
            
            request.HTTPMethod = "POST"
            
            var boundary = String(format: "---------------------------14737809831466499882746641449")
            var contentType = String(format: "multipart/form-data; boundary=%@",boundary)
            //  println("Content Type \(contentType)")
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
            
            var body = NSMutableData.alloc()
            // Image
            body.appendData(String(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(String(format:"Content-Disposition: form-data; name=\"uploadedfile\"; filename=\"\(user.id!).jpg\"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(String(format: "Content-Type: application/octet-stream\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(imageData)
            body.appendData(String(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
            
            
            
            request.HTTPBody = body
            
            
            self.saveImageUserConnection = NSURLConnection(request: request, delegate: self, startImmediately: true)!
            self.saveImageUserConnection!.start()
           
        }
    }
    func uploadImageEvent(event : Event){
        var imageData = UIImageJPEGRepresentation(event.image, 0.5)
        
        if imageData != nil{
            var request = NSMutableURLRequest(URL: NSURL(string:"\(LinkAccessGlobalConstants.LinkEvents)uploadImage.php")!)
            
            request.HTTPMethod = "POST"
            
            var boundary = String(format: "---------------------------14737809831466499882746641449")
            var contentType = String(format: "multipart/form-data; boundary=%@",boundary)
            //  println("Content Type \(contentType)")
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
            
            var body = NSMutableData.alloc()
            // Image
            body.appendData(String(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(String(format:"Content-Disposition: form-data; name=\"uploadedfile\"; filename=\"\(event.id!).jpg\"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(String(format: "Content-Type: application/octet-stream\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(imageData)
            body.appendData(String(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
            
            
            
            request.HTTPBody = body
            
            
            self.saveImageEventConnection = NSURLConnection(request: request, delegate: self, startImmediately: true)!
            self.saveImageEventConnection!.start()
            
        }
    }
    func connection(connection: NSURLConnection, didReceiveData data: NSData){
        self.data = data
    }
    func connectionDidFinishLoading(connection: NSURLConnection)
    {

        let array = JsonResponse.parseJSON(self.data!)
        if (array.objectForKey("error") != nil){
            let error : NSError = NSError(domain: "Erro", code: (array.objectForKey("error")! as! Int), userInfo: nil)
            DispatcherClass.dispatcher({ () -> () in
                self.delegate?.errorCloudKit(error)
            })
            return
        }
        if (array.objectForKey("succesfull") != nil){
            
            DispatcherClass.dispatcher({ () -> () in
                self.delegate?.saveImageFinished()
            })
            return
        }

    }
    func connection(connection: NSURLConnection, didSendBodyData bytesWritten: Int, totalBytesWritten: Int, totalBytesExpectedToWrite: Int) {
        DispatcherClass.dispatcher { () -> () in
            self.delegate?.progressUpload(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite))
        }
    }
    
}

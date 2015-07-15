//
//  DemoModelData.swift
//  MidPoint
//
//  Created by William Alvelos on 14/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


class DemoModelData: NSObject{
    
    //constantes
    let kJSQDemoAvatarDisplayNameSquires = "Jesse Squires"
    let kJSQDemoAvatarDisplayNameCook = "Tim Cook"
    let kJSQDemoAvatarDisplayNameJobs = "Jobs"
    let kJSQDemoAvatarDisplayNameWoz = "Steve Wozniak"
    
    let kJSQDemoAvatarIdSquires = "053496-4509-289"
    let kJSQDemoAvatarIdCook = "468-768355-23123"
    let kJSQDemoAvatarIdJobs = "707-8956784-57"
    let kJSQDemoAvatarIdWoz = "309-41802-93823"
    
    
    var Pessoas:[User]?
    
    //propertys
    var messages:Array<JSQMessage!>?
    var avatars:NSDictionary?
    var outgoingBubbleImageData: JSQMessagesBubbleImage?
    var incomingBubbleImageData: JSQMessagesBubbleImage?
    var users: NSDictionary?
    
    
    override init(){
        super.init()
        
        
        self.messages = [JSQMessage]()
        
//        }else{
            //self.loadFakeMessages()
//

        
        var jsqImage:JSQMessagesAvatarImage = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials("JSQ", backgroundColor: UIColor(white: 0.85, alpha: 1.0), textColor: UIColor(white: 0.60, alpha: 1.0), font: UIFont.systemFontOfSize(14.0), diameter:UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
    
        
        var cookImage:JSQMessagesAvatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "demo_avatar_cook"), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
        
        
        var jobsImage:JSQMessagesAvatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "demo_avatar_jobs"), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))

        var wozImage:JSQMessagesAvatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "demo_avatar_woz"), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
        
        
        self.avatars = [kJSQDemoAvatarIdSquires: jsqImage,
            kJSQDemoAvatarIdCook : cookImage,
            kJSQDemoAvatarIdJobs : jobsImage,
            kJSQDemoAvatarIdWoz : wozImage]
        
        self.users = [kJSQDemoAvatarIdJobs : kJSQDemoAvatarDisplayNameJobs,
            kJSQDemoAvatarIdCook : kJSQDemoAvatarDisplayNameCook,
            kJSQDemoAvatarIdWoz : kJSQDemoAvatarDisplayNameWoz,
            kJSQDemoAvatarIdSquires : kJSQDemoAvatarDisplayNameSquires]
        
    
        var bubbleFactory:JSQMessagesBubbleImageFactory = JSQMessagesBubbleImageFactory()
        
        self.outgoingBubbleImageData = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        
        self.incomingBubbleImageData = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
    
    }
    
    //warning
    func loadFakeMessages(){
        
        self.messages = Array(arrayLiteral:JSQMessage(senderId: kJSQDemoAvatarIdSquires, senderDisplayName: kJSQDemoAvatarDisplayNameSquires, date: NSDate.distantPast() as! NSDate, text: "Welcome to JSQMessages: A messaging UI framework for iOS."),
        
        
        JSQMessage(senderId: kJSQDemoAvatarIdWoz, senderDisplayName: kJSQDemoAvatarDisplayNameWoz, date: NSDate.distantPast() as! NSDate, text: "It is simple, elegant, and easy to use. There are super sweet default settings, but you can customize like crazy."),
        
        
        JSQMessage(senderId: kJSQDemoAvatarIdSquires, senderDisplayName: kJSQDemoAvatarDisplayNameSquires, date: NSDate.distantPast() as! NSDate, text: "It even has data detectors. You can call me tonight. My cell number is 123-456-7890. My website is www.hexedbits.com."),
        
        
        JSQMessage(senderId: kJSQDemoAvatarIdJobs, senderDisplayName: kJSQDemoAvatarDisplayNameJobs, date: NSDate.distantPast() as! NSDate, text: "JSQMessagesViewController is nearly an exact replica of the iOS Messages App. And perhaps, better."),
        
        
        JSQMessage(senderId: kJSQDemoAvatarIdCook, senderDisplayName: kJSQDemoAvatarDisplayNameCook, date: NSDate.distantPast() as! NSDate, text: "It is unit-tested, free, open-source, and documented."),
        
        
        JSQMessage(senderId: kJSQDemoAvatarIdSquires, senderDisplayName: kJSQDemoAvatarDisplayNameSquires, date: NSDate(), text: "Now with media messages!"))

        
        addPhotoMediaMessage()
        
        
    }
    

    func addPhotoMediaMessage(){
        var photoItem:JSQPhotoMediaItem = JSQPhotoMediaItem(image: UIImage(named: "teste"))
        
        var photoMessage:JSQMessage = JSQMessage(senderId: kJSQDemoAvatarIdSquires, displayName: kJSQDemoAvatarDisplayNameSquires, media: photoItem)
        
        self.messages?.append(photoMessage)
    
    }
    
    func addLocationMediaMessageCompletion(completion: JSQLocationMediaItemCompletionBlock){
    
        
        var ferryBuildingInSF: CLLocation = CLLocation(latitude: 37.795313, longitude: -122.393757)
        
        var locationItem: JSQLocationMediaItem = JSQLocationMediaItem()
        
        
        locationItem.setLocation(ferryBuildingInSF, withCompletionHandler:completion)
        
        var locationMessage:JSQMessage = JSQMessage(senderId: kJSQDemoAvatarIdSquires, displayName: kJSQDemoAvatarDisplayNameSquires, media: locationItem)
        
        self.messages?.append(locationMessage)
        
    }
    
    
    
    func addVideoMediaMessage(){
        var videoURL:NSURL = NSURL(string: "file://")!
        
        var videoItem:JSQVideoMediaItem = JSQVideoMediaItem(fileURL: videoURL, isReadyToPlay: true)
        
        var videoMessage:JSQMessage = JSQMessage(senderId: kJSQDemoAvatarIdSquires, displayName: kJSQDemoAvatarDisplayNameSquires, media: videoItem)
        
        self.messages?.append(videoMessage)
    
    }
    
}







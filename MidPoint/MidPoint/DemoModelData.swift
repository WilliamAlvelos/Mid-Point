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
        
        self.outgoingBubbleImageData = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1))
        
        self.incomingBubbleImageData = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
    
    }
    

    


}







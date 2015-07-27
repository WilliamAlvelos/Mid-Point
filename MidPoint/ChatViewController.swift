//
//  ChatView.swift
//  MidPoint
//
//  Created by Joao Sisanoski on 7/14/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation



class ChatViewController : JSQMessagesViewController, UIActionSheetDelegate{
    
    var demoData:DemoModelData?
    
    var conversa:Int?
    
    // Create a reference to a Firebase location

    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.collectionView.collectionViewLayout.springinessEnabled = true

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId = String(format: "%d", UserDAODefault.getLoggedUser().id!)
        self.senderDisplayName = UserDAODefault.getLoggedUser().name
        self.showLoadEarlierMessagesHeader = true
        self.demoData = DemoModelData()
        setupFirebase()
        
    }
    

    
    func setupFirebase() {
        
        var messagesRef = Firebase(url: String(format: "https://midpoint.firebaseio.com/%d/messages", conversa!))
        
        messagesRef.observeEventType(FEventType.ChildAdded, withBlock: { snapshot in
            var text = snapshot.value["text"] as? String
            var sender = snapshot.value["sender"] as? String
            var imageUrl = snapshot.value["imageUrl"] as? String
            
            var message = JSQMessage(senderId:self.senderId, senderDisplayName: self.senderDisplayName, date: NSDate(), text: text)
            
            self.demoData?.messages?.append(message)
            
            JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
            
            self.finishReceivingMessage()
            
        })
        
    }
    
    func sendMessage(text: String!, sender: String!, imageName: String!) {

//        messagesRef.childByAppendingPath(self.senderId).setValue([
//            "text":text,
//            "sender":sender,
//            "image":imageName
//            ])
        
        var messagesRef = Firebase(url: String(format: "https://midpoint.firebaseio.com/%d/messages", conversa!))
        
        messagesRef.childByAutoId().setValue([
                        "text":text,
                        "sender":sender,
                        "image":imageName
                        ])
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: Selector("closePressed:"))
        
    }
    
    
    override func  collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject!) -> Bool {
        
        return super.collectionView(collectionView, canPerformAction: action, forItemAtIndexPath: indexPath, withSender: sender)
    }
    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject!) {
       
        super.collectionView(collectionView, performAction: action, forItemAtIndexPath: indexPath, withSender: sender)
    }
    override func  collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if (indexPath.item % 3 == 0) {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        return 0.0
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 0.0
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, header headerView: JSQMessagesLoadEarlierHeaderView!, didTapLoadEarlierMessagesButton sender: UIButton!) {
        println("mensagem anterior")
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapAvatarImageView avatarImageView: UIImageView!, atIndexPath indexPath: NSIndexPath!) {
        println("Tapped avatar")
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath!) {
        println("Tapped message buble")
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapCellAtIndexPath indexPath: NSIndexPath!, touchLocation: CGPoint) {
        NSLog("Tapped cell at %@!", NSStringFromCGPoint(touchLocation))
    }
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {

        var message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        //self.demoData?.messages?.append(message)
        self.finishSendingMessageAnimated(true)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        sendMessage(text, sender: senderDisplayName, imageName: "demo_avatar_jobs")
        finishSendingMessage()
    
    }
    override func  collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
    
        return self.demoData?.messages![indexPath.item]
    }
  
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = self.demoData?.messages![indexPath.item]
        if message?.senderId == self.senderId {
            return self.demoData?.outgoingBubbleImageData;
        }
        
        return self.demoData?.incomingBubbleImageData;
        
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = self.demoData?.messages![indexPath.item]
        if message?.senderId == self.senderId {
            return nil;
        }
        
        return self.demoData?.avatars![message!.senderId] as! JSQMessageAvatarImageDataSource
       
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        if indexPath.item % 3 == 0 {
            var message = self.demoData?.messages![indexPath.item]
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message?.date)
        }
        return nil
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        var message = self.demoData?.messages![indexPath.item]
        if message?.senderId == self.senderId {
            return nil
        }
        if indexPath.item - 1 > 0 {
            var previousmessage = self.demoData?.messages![indexPath.item-1]
            if (previousmessage?.senderId == message?.senderId){
                return nil
            }
        }
        return NSAttributedString(string: message!.senderDisplayName!)
    }

    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        return nil
    }

    
    override func didPressAccessoryButton(sender: UIButton!) {
        var sheet:UIActionSheet = UIActionSheet(title: "Media messages", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Send photo", "Send location", "Send video")
        
        
        sheet.showFromToolbar(self.inputToolbar)
    }
    
    
    
    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        if (buttonIndex == actionSheet.cancelButtonIndex) {
            return;
        }
        
        switch (buttonIndex) {
            case 1:
                demoData?.addPhotoMediaMessage()
                break;
            
            case 2:
            
                var weak:UICollectionView = self.collectionView
                
                self.demoData?.addLocationMediaMessageCompletion({ () -> Void in
                    weak.reloadData()
                })
            break;
            
            case 3:
                demoData?.addVideoMediaMessage()
                break;
            
            
            default:
                break
        }
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishReceivingMessageAnimated(true)
        

    }
    
    
    func customAction(sender:AnyObject){
        println("Custom action received! Sender: %@", sender)
        
        UIAlertView(title: "Custom Action", message: "", delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "","").show()
        
    }
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.demoData!.messages!.count
    }

    

    
    
    func closePressed(sender:UIBarButtonItem){
    
        
    }
    


}

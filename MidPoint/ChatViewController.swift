//
//  ChatView.swift
//  MidPoint
//
//  Created by Joao Sisanoski on 7/14/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation



class ChatViewController : JSQMessagesViewController, UIActionSheetDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var demoData:DemoModelData?
    var event: Event?
    var conversa:Int?
    
    var name:String?
    
    var pickerLibrary : UIImagePickerController?
    
    var locationManager = CLLocationManager()
    
    //constantes
    let kJSQDemoAvatarDisplayNameSquires = "a"
    let kJSQDemoAvatarDisplayNameCook = "Tim Cook"
    let kJSQDemoAvatarDisplayNameJobs = "b"
    let kJSQDemoAvatarDisplayNameWoz = "Steve Wozniak"
    
    let kJSQDemoAvatarIdSquires = "1"
    let kJSQDemoAvatarIdCook = "2"
    let kJSQDemoAvatarIdJobs = "3"
    let kJSQDemoAvatarIdWoz = "3"
    
    
    var Pessoas:[User]?
    
    
    var base64String: NSString?
    
    // Create a reference to a Firebase location
    
    //propriedades
    var messages:Array<JSQMessage!> = []
    var avatars:NSDictionary?
    var outgoingBubbleImageData: JSQMessagesBubbleImage?
    var incomingBubbleImageData: JSQMessagesBubbleImage?
    var users: NSDictionary?
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.collectionView.collectionViewLayout.springinessEnabled = true
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerLibrary = UIImagePickerController()
        pickerLibrary?.delegate = self
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        self.senderId = String(format: "%d", UserDAODefault.getLoggedUser().id!)
        self.senderDisplayName = UserDAODefault.getLoggedUser().name
        self.showLoadEarlierMessagesHeader = true
        self.demoData = DemoModelData()
        setupFirebase()
        setupImageFirebase()
        
        
        self.title = name
        
        
        
        
        
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
        
        self.outgoingBubbleImageData = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleRedColor())
        
        self.incomingBubbleImageData = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
        
        
        
    }
    
    

    
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            
            var shouldIAllow = false
            
            switch status {
            case CLAuthorizationStatus.AuthorizedAlways:
                shouldIAllow = true
            default:
                //LOCATION IS RESTRICTED ********
                //LOCATION IS RESTRICTED ********
                //LOCATION IS RESTRICTED ********
                return
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName("LabelHasbeenUpdated", object: nil)
            
            if (shouldIAllow == true) {
                // Start location services
                locationManager.startUpdatingLocation()
            }
            
    }
    

    
    
    func setupImageFirebase(){
        var ref = Firebase(url: String(format: "https://midpoint.firebaseio.com/%d/messages/imageMensage", conversa!))
        
        ref.observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) -> Void in
            var string = snapshot.value["string"] as? String
            
            var decodedData = NSData(base64EncodedString: string!, options: NSDataBase64DecodingOptions())
            var decodedImage = UIImage(data: decodedData!)!
            
            JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
            
            self.addPhotoMediaMessage(decodedImage)
            
            self.finishReceivingMessage()
        })
    
    }
    
    
    
    func setupFirebase() {
        
        var messagesRef = Firebase(url: String(format: "https://midpoint.firebaseio.com/%d/messages", conversa!))
        
        messagesRef.observeEventType(FEventType.ChildAdded, withBlock: { snapshot in
            var text = snapshot.value["text"] as? String
            var sender = snapshot.value["sender"] as? String
            var name = snapshot.value["name"] as? String
            var image = snapshot.value["imageMensage"] as? String
            var geolatitude = snapshot.value["geolatitude"] as? Double
            var geolongitude = snapshot.value["geolongitude"] as? Double
            
            

            
            JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
            
            
            if(text != ""){
                var message = JSQMessage(senderId: sender, senderDisplayName: name, date: NSDate(), text: text)
                
                self.messages.append(message)
                
            }else if(geolatitude != nil){
                
                self.addLocationMediaMessage(geolatitude!, longitude: geolongitude!, id: sender, name: name)
                
            }
            
            
            
            else if(image != nil){
                var decodedData = NSData(base64EncodedString: image!, options: NSDataBase64DecodingOptions())
                var decodedImage = UIImage(data: decodedData!)!
                
                self.addPhotoMediaMessage(decodedImage)
            }
            
            


            
            self.finishReceivingMessage()
            
            
        })
        
        
        
    }
    
    func sendMessage(text: String!, sender: String!, name: String!) {

//        messagesRef.childByAppendingPath(self.senderId).setValue([
//            "text":text,
//            "sender":sender,
//            "image":imageName
//            ])
        
        
        
        var messagesRef = Firebase(url: String(format: "https://midpoint.firebaseio.com/%d/messages", conversa!))
        
        messagesRef.childByAutoId().setValue([
                        "text":text,
                        "sender":sender,
                        "name":name,
                        "imageMensage":"",
                        "geolatitude":0.0,
                        "geolongitude":0.0
            ])
        
    }
    
    func sendImage(image: UIImage!, sender:String!, name: String!){
        
        var messagesRef = Firebase(url: String(format: "https://midpoint.firebaseio.com/%d/messages", conversa!))
        
        
        var uploadImage = image
        
        var imageData: NSData = UIImagePNGRepresentation(uploadImage)
        
        self.base64String = imageData.base64EncodedStringWithOptions(.allZeros)
        

        messagesRef.childByAutoId().setValue([
            "text":"",
            "sender":sender,
            "name":name,
            "imageMensage": self.base64String!,
            "geolatitude":0.0,
            "geolongitude":0.0
            ])

    }
    
    
    func sendLocation(latitude: Double, longitude:Double, sender:String!, name: String!){
    
    
        var messagesRef = Firebase(url: String(format: "https://midpoint.firebaseio.com/%d/messages", conversa!))
        
        messagesRef.childByAutoId().setValue([
            "text":"",
            "sender":sender,
            "name":name,
            "imageMensage": "",
            "geolatitude":latitude,
            "geolongitude":longitude
            ])
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        PermissionsResponse.checkCameraPermission()
        PermissionsResponse.checkRollCameraPermission()
        
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
        sendMessage(text, sender: self.senderId, name: self.senderDisplayName)
        finishSendingMessage()
    
    }
    override func  collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
    
        return self.messages[indexPath.item]
    }
  
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = self.messages[indexPath.item]
        
        if message?.senderId == self.senderId {
            return self.outgoingBubbleImageData;
        }
        return self.incomingBubbleImageData;
        
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = self.messages[indexPath.item]
        if message?.senderId == self.senderId {
            return nil;
        }
        
        return self.avatars![message!.senderId] as! JSQMessageAvatarImageDataSource
       
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        if indexPath.item % 3 == 0 {
            var message = self.messages[indexPath.item]
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message?.date)
        }
        return nil
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        var message = self.messages[indexPath.item]
        if message?.senderId == self.senderId {
            return nil
        }
        if indexPath.item - 1 > 0 {
            var previousmessage = self.messages[indexPath.item-1]
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
        var sheet:UIActionSheet = UIActionSheet(title: "Media messages", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Camera", "Rolo de Camera", "Send location", "Send video")
        
        
        let cameraAction = UIAlertAction(title: "Camera", style: .Default,handler: { (alert: UIAlertAction!) -> Void in
            
            self.pickerLibrary?.sourceType = .Camera
            self.pickerLibrary?.allowsEditing = true
            self.presentViewController(self.pickerLibrary!, animated: true, completion: nil)
        })
        
        let roloCamera = UIAlertAction(title: "Rolo de camera", style: .Default,handler: { (alert: UIAlertAction!) -> Void in
            self.pickerLibrary?.sourceType = .PhotoLibrary
            self.pickerLibrary?.allowsEditing = true
            self.presentViewController(self.pickerLibrary!, animated: true, completion: nil)
        })

        
        
        
        sheet.showFromToolbar(self.inputToolbar)
    }
    
    
    
    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        if (buttonIndex == actionSheet.cancelButtonIndex) {
            return;
        }
        
        switch (buttonIndex) {
            case 1:
                
                self.pickerLibrary?.sourceType = .Camera
                self.pickerLibrary?.allowsEditing = true
                self.presentViewController(self.pickerLibrary!, animated: true, completion: nil)
                
                break;
            
            case 2:
            
                
                self.pickerLibrary?.sourceType = .PhotoLibrary
                self.pickerLibrary?.allowsEditing = true
                self.presentViewController(self.pickerLibrary!, animated: true, completion: nil)
            
            case 3:
            
                var weak:UICollectionView = self.collectionView
                
                self.addLocationMediaMessageCompletion({ () -> Void in
                    weak.reloadData()
                })
            break;
            
            case 4:
                addVideoMediaMessage()
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
        return self.messages.count
    }

    
    func addPhotoMediaMessage(image: UIImage){
        
        var photoItem:JSQPhotoMediaItem = JSQPhotoMediaItem(image: image)
        
        var photoMessage:JSQMessage = JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, media: photoItem)
        
        self.messages.append(photoMessage)
        
        
    }
    
    func addLocationMediaMessageCompletion(completion: JSQLocationMediaItemCompletionBlock){
        
        
        var ferryBuildingInSF: CLLocation = CLLocation(latitude: 37.795313, longitude: -122.393757)
        
        var locationItem: JSQLocationMediaItem = JSQLocationMediaItem()
        
        
        locationItem.setLocation(self.locationManager.location, withCompletionHandler:completion)
        
        
        sendLocation(self.locationManager.location.coordinate.latitude, longitude:self.locationManager.location.coordinate.longitude, sender: self.senderId, name: self.senderDisplayName)
        
        var locationMessage:JSQMessage = JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, media: locationItem)
        
        self.messages.append(locationMessage)
        
        

        
    }
    
    
    
    func addLocationMediaMessage(latitude: Double, longitude: Double, id: String!, name: String!){
        
        var location: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        var locationItem: JSQLocationMediaItem = JSQLocationMediaItem()
        
        
        locationItem.setLocation(location, withCompletionHandler: { () -> Void in
            
        })
        
        
        var locationMessage:JSQMessage = JSQMessage(senderId: id, displayName: name, media: locationItem)
        
        self.messages.append(locationMessage)
    
    }
    
    
    
    func addVideoMediaMessage(){
        var videoURL:NSURL = NSURL(string: "file://")!
        
        var videoItem:JSQVideoMediaItem = JSQVideoMediaItem(fileURL: videoURL, isReadyToPlay: true)
        
        var videoMessage:JSQMessage = JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, media: videoItem)
        
        self.messages.append(videoMessage)
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!){
        let data : NSData = NSData(data: UIImageJPEGRepresentation(image, 1))
        data.writeToFile(self.imagePathURL().path!, atomically: true)
        println("%@", self.imagePathURL().path!)
        
        //addPhotoMediaMessage(image)
        
        sendImage(image, sender: self.senderId, name: self.senderDisplayName)
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    private func imagePathURL()->NSURL{
        return NSURL.fileURLWithPath(NSString(format: "%@%@", aplicationDocumentsDirectory(),"/groupPhoto.JPG") as String)!
    }
    
    private func aplicationDocumentsDirectory()->NSString{
        var paths :NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        return paths[0] as! NSString
    }

    

    
    
    func closePressed(sender:UIBarButtonItem){
    
        
    }
    


}

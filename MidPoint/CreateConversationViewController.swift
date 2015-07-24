//
//  CreateConversationViewController.swift
//  MidPoint
//
//  Created by William Alvelos on 16/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import UIKit

class CreateConversationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    var pickerLibrary : UIImagePickerController?
    
    var conversasRef:Firebase = Firebase(url: "https://midpoint.firebaseio.com/")
    
    @IBOutlet var button: UIButton!
    
    @IBOutlet var titleGroup: UITextField!
    
    @IBOutlet var subtitleGroup: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Criar Grupo"
        pickerLibrary = UIImagePickerController()
        pickerLibrary!.delegate = self
        
        button.layer.cornerRadius = button.bounds.size.width/2
        button.layer.borderWidth = 0
        button.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        PermissionsResponse.checkCameraPermission()
        PermissionsResponse.checkRollCameraPermission()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

    @IBAction func actionCreateGroup(sender: AnyObject) {
        
        addConversation("4", title: titleGroup.text, subtitle: subtitleGroup.text, image: "halua image")
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func addConversation(id: String!, title: String!, subtitle: String!, image: String!) {
        
        conversasRef.childByAppendingPath(id).setValue([
            "id":id,
            "title":title,
            "subtitle":subtitle,
            "image":image
            ])
    }
    
    
    
    @IBAction func changeImage(sender: AnyObject) {
        
        var actionsheet: UIAlertController = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
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
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel,handler:{ (alert: UIAlertAction!) -> Void in
            println("cancelar")
        })
        
        actionsheet.addAction(cameraAction)
        actionsheet.addAction(roloCamera)
        actionsheet.addAction(cancelAction)
        
        
        self.presentViewController(actionsheet, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!){
        let data : NSData = NSData(data: UIImageJPEGRepresentation(image, 1))
        data.writeToFile(self.imagePathURL().path!, atomically: true)
        println("%@", self.imagePathURL().path!)
        
        button.setBackgroundImage(image, forState: .Normal)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    private func imagePathURL()->NSURL{
        return NSURL.fileURLWithPath(NSString(format: "%@%@", aplicationDocumentsDirectory(),"/userPhoto.JPG") as String)!
    }
    
    private func aplicationDocumentsDirectory()->NSString{
        var paths :NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        return paths[0] as! NSString
    }
    

}

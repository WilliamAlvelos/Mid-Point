//
//  CreateConversationViewController.swift
//  MidPoint
//
//  Created by William Alvelos on 16/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import UIKit

import CloudKit

class CreateConversationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate{

    var pickerLibrary : UIImagePickerController?
    
    var locationManager = CLLocationManager()
    
    var conversasRef:Firebase = Firebase(url: "https://midpoint.firebaseio.com/")
    
    var event:Event?

    var location: CLLocationCoordinate2D?
    
    var nameRole: String?
    
    @IBOutlet var button: UIButton!
    
    @IBOutlet var titleGroup: UITextField!
    
    @IBOutlet var subtitleGroup: UITextField!
    
    @IBOutlet var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Criar Grupo"
        pickerLibrary = UIImagePickerController()
        pickerLibrary!.delegate = self
        
        mapView.delegate = self
        locationManager.delegate = self
        mapView.showsUserLocation = true
        
        locationManager.requestAlwaysAuthorization()

        button.layer.cornerRadius = button.bounds.size.width/2
        button.layer.borderWidth = 0
        button.layer.masksToBounds = true
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .Done, target: self, action: "next")
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func next(){
    
        event = Event()
        event?.name = self.titleGroup.text
        event?.descricao = self.subtitleGroup.text
        event?.date = NSDate(timeIntervalSinceNow: 0)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("AmigosViewController") as! AmigosTableViewController
        nextViewController.event = event
        self.navigationController?.pushViewController(nextViewController, animated: true)
        //var vc = segue.destinationViewController as! AmigosTableViewController

        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        PermissionsResponse.checkCameraPermission()
        PermissionsResponse.checkRollCameraPermission()
        
        var point: MKPointAnnotation = MKPointAnnotation()
        
        var coordinate: CLLocationCoordinate2D = self.location!
        
        print(self.location!)
        
        point.subtitle = "Role"
        point.title = self.nameRole
        point.coordinate = coordinate
        
        mapView.addAnnotation(point)
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
    
    
//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        
//        
//        locationManager.stopUpdatingLocation()
//        
//        var locationArray = locations as NSArray
//        var locationObj = locationArray.lastObject as! CLLocation
//        var coord = locationObj.coordinate
//        
////        let region = MKCoordinateRegionMakeWithDistance(coord, radius, radius)
////        
////        geoLocation = coord
////        
////        mapView.setRegion(region, animated: true)
//        
//        
//    }
//    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        
        locationManager.stopUpdatingLocation()
        
        var locationArray = locations as NSArray
        var locationObj = locationArray.lastObject as! CLLocation
        //var coord = locationObj.coordinate
        
        let region = MKCoordinateRegionMakeWithDistance(self.location!, 500, 500)
        
        //geoLocation = coord
        
        mapView.setRegion(region, animated: true)
        
        //mapView.userLocation.title = nomeUser
        
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        event = Event()
        event?.name = self.titleGroup.text
        event?.descricao = self.subtitleGroup.text
        event?.date = NSDate(timeIntervalSinceNow: 0)
        var vc = segue.destinationViewController as! AmigosTableViewController
        vc.event = event
        
    
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    
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
        let perRecordProgressionBlock = { (record : CKRecord!, double : Double) -> Void in
            print("\(double)\n")
        }
        let perRecordCompletionBlock = { (record : CKRecord!, error: NSError!) -> Void in
            print("terminou\n")

        }
        
            PictureCloudKit().uploadProfile(self.imagePathURL(), id: 10, perRecordProgressBlock: perRecordProgressionBlock, perRecordCompletionBlock: perRecordCompletionBlock)
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

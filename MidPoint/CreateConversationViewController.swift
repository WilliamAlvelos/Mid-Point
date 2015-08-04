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
    
    var startLocation : Localizacao?

    var location: CLLocationCoordinate2D?
    
    var nameRole: String?
    
    @IBOutlet var button: UIButton!
    
    @IBOutlet var titleGroup: UITextField!
    
    @IBOutlet var subtitleGroup: UITextField!
    
    @IBOutlet var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Criar Grupo"
        
        UIMPConfiguration.addBorderAndMakeRounded(self.button!, color: Colors.Rosa, width: 1.5)
        UIMPConfiguration.configureTextField(self.subtitleGroup, text: "Nome do grupo", color: Colors.Azul)
        UIMPConfiguration.configureTextField(self.titleGroup, text: "Descricao", color: Colors.Azul)

        let float: Float = Float(self.button.frame.width/2.0)
        
        UIMPConfiguration.addBorderToView(self.button!, color: Colors.Rosa, width: 3.0, corner: float)
        UIMPConfiguration.addColorAndFontToButton(self.button, color: Colors.Rosa, fontName: FontName.ButtonFont, fontSize: 20)
        pickerLibrary = UIImagePickerController()
        pickerLibrary!.delegate = self
        
        self.button.layer.cornerRadius = 10
        
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
        
        if(self.titleGroup.text == ""){
            
            
            ActionError.actionWithTextField("Cuidado", errorMessage: "O titulo do Grupo está vazio", placeholder:"Digite o Titulo do Grupo", textFieldView: self.titleGroup, view: self)

        }

        
        if(self.subtitleGroup.text == ""){
            
            ActionError.actionWithTextField("Cuidado", errorMessage: "O subtitulo do Grupo está vazio", placeholder:"Digite o subtitulo do Grupo", textFieldView: self.subtitleGroup, view: self)

        }
        
        
        if(self.event?.image == nil){
            
            var alertController = UIAlertController(title: "Cuidado", message: "O Grupo não possui imagem", preferredStyle: .Alert)
            
            // Create the actions
            
            var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) {
                UIAlertAction in
                
                self.event?.name = self.titleGroup.text
                self.event?.descricao = self.subtitleGroup.text
                self.event?.date = NSDate(timeIntervalSinceNow: 0)
                
                let nextViewController = TransitionManager.creatView("AmigosViewController") as! AmigosTableViewController
                nextViewController.event = self.event
                nextViewController.startLocation = self.startLocation!
                
                self.navigationController?.pushViewController(nextViewController, animated: true)
                
            }
            
            
            var takeAction = UIAlertAction(title: "Tirar Foto", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                
                self.pickerLibrary?.sourceType = .Camera
                self.pickerLibrary?.allowsEditing = true
                self.presentViewController(self.pickerLibrary!, animated: true, completion: nil)
                
            }
            
            alertController.addAction(okAction)
            alertController.addAction(takeAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        if(self.titleGroup.text != "" && self.subtitleGroup.text != ""){
            
            event?.name = self.titleGroup.text
            event?.descricao = self.subtitleGroup.text
            event?.date = NSDate(timeIntervalSinceNow: 0)
            
            let nextViewController = TransitionManager.creatView("AmigosViewController") as! AmigosTableViewController
            nextViewController.event = event
            nextViewController.startLocation = self.startLocation
            self.navigationController?.pushViewController(nextViewController, animated: true)
            //var vc = segue.destinationViewController as! AmigosTableViewController
        }

        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        PermissionsResponse.checkCameraPermission()
        PermissionsResponse.checkRollCameraPermission()
        
        var point: MKPointAnnotation = MKPointAnnotation()
        
        
        if(self.location == nil){
            var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(self.startLocation!.latitude!) , longitude: Double(self.startLocation!.longitude!))
            point.coordinate = coordinate

        }else{
            point.coordinate = self.location!
        }
        
        
        
        point.subtitle = "Role"
        point.title = self.nameRole
        
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
        
        let region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: Double(self.startLocation!.latitude!), longitude: Double(self.startLocation!.longitude!)), 500, 500)
        
        //geoLocation = coord
        
        mapView.setRegion(region, animated: true)
        
        //mapView.userLocation.title = nomeUser
        
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        event?.name = self.titleGroup.text
        event?.descricao = self.subtitleGroup.text
        event?.date = NSDate(timeIntervalSinceNow: 0)
        var vc = segue.destinationViewController as! AmigosTableViewController
        vc.event = event
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
        //EventDAOCloudKit().uploadImageOne(UIImage(contentsOfFile: self.imagePathURL().path!)!)
        button.setBackgroundImage(image, forState: .Normal)
        button.setTitle("", forState: UIControlState.Normal)
        event?.image = UIImage(contentsOfFile: self.imagePathURL().path!)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    private func imagePathURL()->NSURL{
        return NSURL.fileURLWithPath(NSString(format: "%@%@", aplicationDocumentsDirectory(),"/groupPhoto.JPG") as String)!
    }
    
    private func aplicationDocumentsDirectory()->NSString{
        var paths :NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        return paths[0] as! NSString
    }
    

    
    
    
    

}

//
//  ChangeMidPointViewController.swift
//  MidPoint
//
//  Created by William Alvelos on 30/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import UIKit

class ChangeMidPointViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UserManagerDelegate{

    
    var userManager: UserManager?
    
    @IBOutlet var mapView: MKMapView!
    
    var event : Event?
    
    var user  = User()
    
    var conversa:Int?
    
    var avatars:NSMutableDictionary?
    
    var pessoas = NSMutableDictionary()
    
    var midPoint : MKPointAnnotation = MKPointAnnotation()

    var locations = Localizacao()
    
    var locationManager = CLLocationManager()
    
    var array = Array<User>()
    
    var activity: activityIndicator?
    
    var pins = Array<MKPointAnnotation>()
    
    var gestureRecognizer: GestureRecognizerMap?
    
    var userPoint: MKPointAnnotation  = MKPointAnnotation()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        userManager = UserManager()
        userManager!.delegate = self
        mapView.delegate = self
        locationManager.delegate = self
        mapView.showsUserLocation = true
        
        
        
        self.title = "MID POINT"

//        var reply = UIBarButtonItem(image: UIImage(named: "btest3"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("conversa:"))
//        self.navigationItem.rightBarButtonItem = reply
//        
        
        
        userManager!.getUsersFrom(event!)
        
        
        
        var tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("tap:"))
        
        tapRecognizer.numberOfTapsRequired = 1
        
        tapRecognizer.numberOfTouchesRequired = 1
        
        
        self.mapView.addGestureRecognizer(tapRecognizer)

        gestureRecognizer  = GestureRecognizerMap()

        gestureRecognizer!.initWithViewController(self, mapView: self.mapView)
    
       // userManager!.getUsersFrom(event!)
        
        //        //Inicia a UBA com o numero de botoões
        var uba = UBAView(buttonsQuantity: 4)
        //
        //        //Prepara os botões na view passada

        uba.prepareAnimationOnView(self.view, navigation: self.navigationController!.navigationBar.frame.size)
        
        uba.addSelectorToButton(0, target: self, selector: Selector("acepted"), image:"group")
        
        uba.addSelectorToButton(1, target: self, selector: Selector("refused"), image:"group")
        
        uba.addSelectorToButton(2, target: self, selector: Selector("passed"), image:"group")
        
        uba.addSelectorToButton(3, target: self, selector: Selector("owner"), image:"group")
    
        
        var messageButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        messageButton.setImage(UIImage(named: "message"), forState: UIControlState.Normal)
        messageButton.addTarget(self, action: Selector("changeView:"), forControlEvents: .TouchUpInside)
        var message = UIBarButtonItem(customView: messageButton)
        self.navigationItem.rightBarButtonItem = message
        
    }
    
    
    func changeView(sender: UIButton){
        var nextView = TransitionManager.creatView("ChatViewController") as! ChatViewController
        nextView.conversa = self.conversa
        nextView.event = self.event
        nextView.imageEvent = event?.image
        nextView.avatars = self.avatars!
        nextView.users = self.pessoas
        self.navigationController?.pushViewController(nextView, animated: true)
        
    }
    
    func tap(recognizer: UITapGestureRecognizer){
        self.mapView.removeAnnotation(self.userPoint)

        activity = activityIndicator(view: self.navigationController!, texto: "Enviando localizaçāo", inverse: false, viewController: self)
        
        var point: CGPoint = recognizer.locationInView(self.mapView)
        
        var tapPoint: CLLocationCoordinate2D = self.mapView.convertPoint(point, toCoordinateFromView: self.view)
        
        var point1 : MKPointAnnotation = MKPointAnnotation()
        
        point1.coordinate = tapPoint

        var localizacao = Localizacao()
        
        localizacao.latitude = NSNumber(double: point1.coordinate.latitude) as Float
        
        localizacao.longitude = NSNumber(double: point1.coordinate.longitude) as Float
        
        localizacao.name = self.user.name
        
        self.userManager!.updateUserLocationAndState(self.user, location: localizacao, event: event!, state: self.user.state!.state!)
        

        self.mapView.addAnnotation(point1)
//    
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        activity?.removeActivityViewWithName(self)
    }
    
    
    func acepted(){
        self.userManager!.updateUserLocationAndState(UserDAODefault.getLoggedUser(), location: nil, event: event!, state: Option.Accepted)
    }
    
    func owner(){
        self.userManager!.updateUserLocationAndState(UserDAODefault.getLoggedUser(), location: nil, event: event!, state: Option.Owner)
        //self.userManager?.updateUserState(UserDAODefault.getLoggedUser(), state: Option.Owner, event: event!)
    }
    
    
    func passed(){
        self.userManager!.updateUserLocationAndState(UserDAODefault.getLoggedUser(), location: nil, event: event!, state: Option.Passed)
        //self.userManager?.updateUserState(UserDAODefault.getLoggedUser(), state: Option.Passed, event: event!)
    }
    
    func refused(){
        self.userManager!.updateUserLocationAndState(UserDAODefault.getLoggedUser(), location: nil, event: event!, state: Option.Refused)
        //self.userManager?.updateUserState(UserDAODefault.getLoggedUser(), state: Option.Refused, event: event!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func addUsersMap(){
        
        mapView.removeAnnotations(self.mapView.annotations)
        
        for(var i = 0; i < self.array.count; i++){
            var point: MKPointAnnotation = MKPointAnnotation()
            if (self.array[i].id == self.user.id){
                self.userPoint = point
            }
            
            var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double(self.array[i].location!.latitude!), Double(self.array[i].location!.longitude!))
            
            point.title = self.array[i].name
            point.coordinate = coordinate
            
            mapView.addAnnotation(point)
        }
        
        activity?.removeActivityViewWithName(self)
    }
    
    
    
    func mapView(mapView: MKMapView!,
        viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
            
            if annotation is MKUserLocation {
                return nil
            }
            
            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.animatesDrop = true
                pinView!.canBecomeFirstResponder()
                
                pinView?.pinColor = MKPinAnnotationColor.Green
//                
//                if(pinView?.annotation.title == "Mid Point"){
//                    pinView!.pinColor = .Red
//                    
//                }
//                
                
            }
            else {
                pinView!.annotation = annotation
            }
            return pinView
    }
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            
            var shouldIAllow = false
            
            switch status {
            case CLAuthorizationStatus.AuthorizedAlways:
                shouldIAllow = true
            default:
                return
            }
            
            
            if (shouldIAllow == true) {
                // Start location services
                locationManager.startUpdatingLocation()
            }
            
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        
        locationManager.stopUpdatingLocation()
        
        var locationArray = locations as NSArray
        var locationObj = locationArray.lastObject as! CLLocation
        var coord = locationObj.coordinate
        
        let region = MKCoordinateRegionMakeWithDistance(coord, 100, 100)
        
        
        mapView.setRegion(region, animated: true)
        
        mapView.userLocation.title = "user"
        
    }
    

    
    func getUsersFinished(users: Array<User>, event: Event) {
        
        for user2 in users{
            if user2.id == UserDAODefault.getLoggedUser().id{
                self.user = user2
            }
            
        }
        self.userManager?.getImages(users, event: event)

        self.addUsersMap()

    }
    
    func downloadImageUsersFinished(users:Array<User>, event: Event){
        
        self.avatars = NSMutableDictionary()
        self.avatars?.removeAllObjects()
        
        for user in users {
            var usuario :JSQMessagesAvatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(user.image, diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
            self.avatars?.setValue(usuario, forKey: "\(user.id!)")
        }
        
    }
    

    func errorThrowedServer(stringError: String) {
        
    }
    
    func errorThrowedSystem(error: NSError) {
        
    }


    func updateLocationFinished(localizacao: Localizacao) {
        self.mapView.removeAnnotations([self.midPoint])
        self.midPoint = MKPointAnnotation()
        self.midPoint.coordinate.latitude = Double(localizacao.latitude!)
        self.midPoint.coordinate.longitude = Double(localizacao.longitude!)
        self.midPoint.title = "Mid Point"
        self.mapView.addAnnotation(self.midPoint)
        self.activity?.removeActivityViewWithName(self)
        //self.userManager?.getUsersFrom(self.event!)
        
    }
//    override func viewWillDisappear(animated: Bool) {
//        mapView.showsUserLocation = false;
//        mapView.delegate = nil;
//        mapView.removeFromSuperview();
//        mapView = nil;
//
//    }


}


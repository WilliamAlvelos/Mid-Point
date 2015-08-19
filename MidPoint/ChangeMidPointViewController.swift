//
//  ChangeMidPointViewController.swift
//  MidPoint
//
//  Created by William Alvelos on 30/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import UIKit

class ChangeMidPointViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UserManagerDelegate, PartidaProtocol{

    var alertView2: JSSAlertView = JSSAlertView()

    var userManager: UserManager?
    
    @IBOutlet var mapView: MKMapView!
    
    var event : Event?
    
    private var alertView =  JSSAlertView()
    
    var user  = User()
    var actionButton: ActionButton!

    var radius: CLLocationDistance = 750
    
    let googleAPIKey: String = "AIzaSyA75fDAWf4X6SJmcDA1UDxQNM0HjwMc9bc"

    var conversa:Int?
    
    var avatars:NSMutableDictionary?
    
    var pessoas = NSMutableDictionary()
    
    var midPoint : MKPointAnnotation = MKPointAnnotation()
    
    var activity:activityIndicator?

    var locations = Localizacao()
    
    var locationManager = CLLocationManager()
    
    var array = Array<User>()
    
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
        self.activity = activityIndicator(view: self.navigationController!, texto: "Carregando Locais", inverse: true, viewController: self)
        
        let twitterImage = UIImage(named: "sim_selected")!
        let plusImage = UIImage(named: "talvez_selected")!
        let twitter = ActionButtonItem(title: "Aceitar", image: twitterImage)
        twitter.action = {
        
            item in
            DispatcherClass.dispatcher({ () -> () in
               self.acepted()
            })

        }
        
        let google = ActionButtonItem(title: "Recusar", image: plusImage)
        google.action = { item in
            self.refused()
        
        
        
        }

        actionButton = ActionButton(attachedToView: self.view, items: [google, twitter])
        actionButton.action = { button in button.toggleMenu() }
        actionButton.backgroundColor = Colors.Rosa
        self.title = "Mid Point"

        
        self.userManager!.getUsersFrom(event!)
        
    
        
        var messageButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        messageButton.setImage(UIImage(named: "main_chat"), forState: UIControlState.Normal)
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

    
    
    override func viewWillDisappear(animated: Bool) {
        alertView2.removeView()
        activity?.removeActivityViewWithName(self)
    }
    
    
    func acepted(){
        let a = TransitionManager.creatView("PartidaTableViewController") as! PartidaTableViewController
        a.shouldReturn = true
        a.delegate = self
        
        let b = TransitionManager.creatView("navigationController") as! UINavigationController
        b.viewControllers = [a]
        self.navigationController!.presentViewController(b, animated: true, completion: nil)
        //
//
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
    
    private func addPointsOfInterest(type: String, name: String, location: CLLocationCoordinate2D, pageToken:String) {
        //showActivity()
        
        //Not completed. Needs [ &types=" + type + ] in the future ***
     
        
        var url = "https://maps.googleapis.com/maps/api/place/search/json?location=\(location.latitude),\(location.longitude)&radius=\(radius)&sensor=true&key=" + googleAPIKey
        
        if name.isEmpty == false {
            url = url + "&name=" + name
        }
        
        if pageToken.isEmpty == false {
            url = "https://maps.googleapis.com/maps/api/place/search/json?key=" + googleAPIKey + "&pagetoken=" + pageToken
        }
        
        
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            let data: NSData? = NSData(contentsOfURL: NSURL(string: url)!)
            
            var json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers, error: nil)
            if data == nil {
                self.alertView2.danger(self.navigationController!.view, title: "Error", text: "Sem Internet", cancelButtonText : "Ok")
                return
            }
            if data != nil {
                
                var jsonGooogle: AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
                
                var places: NSArray = jsonGooogle.objectForKey("results") as! NSArray
                
                if let token = jsonGooogle.objectForKey("next_page_token") as? String {
                    
                    self.addPointsOfInterest(type, name: name, location: location, pageToken:token)
                }
                
                if let error = jsonGooogle.objectForKey("error_message") as? String {
                    ActionError.actionError("Error", errorMessage: error, view: self)
                    println(error)
                }
                
                if((places.count < 5 && name == "") || places.count < 1){
                    
                    if(self.radius < 3000000){
                        self.radius = self.radius * 2
                        self.addPointsOfInterest(type, name: name, location: location, pageToken:"")
                    }
                }
                
                
                for(var x = 0; x < places.count; x++) {
                    
                    var place: NSDictionary = places.objectAtIndex(x) as! NSDictionary
                    var geo: NSDictionary = place.objectForKey("geometry") as! NSDictionary
                    var opening: NSDictionary? = place.objectForKey("opening_hours") as? NSDictionary
                    var openNow: NSString? = opening?.objectForKey("open_now") as? NSString
                    var icon: String = place.objectForKey("icon") as! String
                    var loc: NSDictionary = geo.objectForKey("location") as! NSDictionary
                    var name: String = place.objectForKey("name") as! String
                    var lat: NSNumber = loc.objectForKey("lat") as! NSNumber
                    var lon: NSNumber = loc.objectForKey("lng") as! NSNumber
                    var types = place.objectForKey("types") as! [AnyObject]
                    
                    var point: MKPointAnnotation = MKPointAnnotation()
                    
                    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat.doubleValue, lon.doubleValue)
                    
                    point.subtitle = ""
                    point.title = name
                    point.coordinate = coordinate
                    
                    
                    if openNow == "true"{
                        point.subtitle = "Aberto"
                    }else if openNow == "false"{
                        point.subtitle = "Fechado"
                    }
                    
                    
                    for(var i = 0; i < types.count; i++){
                        let typeString: String = types[i] as! String
                        
                        var string = typeString.stringByReplacingOccurrencesOfString("_", withString: " ", options:  NSStringCompareOptions.LiteralSearch, range: nil)
                        point.subtitle = point.subtitle + string + "\n"
                    }
                    
                    DispatcherClass.dispatcher({ () -> () in
                        self.mapView.addAnnotation(point)
                    })
                    
                }
                
            }else{
                ActionError.actionError("Error", errorMessage: "Falha na Conexao", view: self)
            }
            
            
        })
        

        self.alertView2.removeView()
    }
    
    
    
    func addUsersMap(){
        
        mapView.removeAnnotations(self.mapView.annotations)
        
        for(var i = 0; i < self.array.count; i++){
            var point: MKPointAnnotation = MKPointAnnotation()
            
            
            var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double(self.array[i].location!.latitude!), Double(self.array[i].location!.longitude!))
            
            point.title = self.array[i].name
            point.coordinate = coordinate
            
            mapView.addAnnotation(point)
            
            if (self.array[i].id == self.user.id){
                self.userPoint = point
            }
            

        }
        
        self.alertView2.removeView()
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
        
        self.array.removeAll(keepCapacity: false)
        
        for user2 in users{
            if user2.id == UserDAODefault.getLoggedUser().id{
                self.user = user2
            }
            if(user2.location?.longitude == -1 && user2.location?.longitude == -1){
            
            }else{
                self.array.append(user2)
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
        
        self.activity?.removeActivityViewWithName(self)
    }
    

    func errorThrowedServer(stringError: String) {
        alertView2.danger(self.navigationController!.view, title: "Error", text: stringError, cancelButtonText : "Ok")
    
    }
    
    func errorThrowedSystem(error: NSError) {
        
    }


    func updateLocationFinished(localizacao: Localizacao) {

        self.mapView.removeAnnotations([self.midPoint])
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        for(var i = 0; i < self.pins.count ; i++){
            self.mapView.addAnnotation(self.pins[i])
        }
        self.midPoint = MKPointAnnotation()
        self.midPoint.coordinate.latitude = Double(localizacao.latitude!)
        self.midPoint.coordinate.longitude = Double(localizacao.longitude!)
        self.midPoint.title = "Mid Point"
        self.mapView.addAnnotation(self.midPoint)
        
        let region = MKCoordinateRegionMakeWithDistance(self.midPoint.coordinate, radius, radius)
        
        addPointsOfInterest("", name: "", location: self.midPoint.coordinate, pageToken: "")

        self.mapView.setRegion(region, animated: true)

        self.alertView2.removeView()
        
        
    }
    
    func locationFinished(location: Localizacao?) {
        alertView2.show(self.view!, title: "Carregando", text: "Estamos salvando o ponto.", buttonText: nil, color: Colors.Rosa)
        self.userManager!.updateUserLocationAndState(UserDAODefault.getLoggedUser(), location: location, event: event!, state: Option.Accepted)
    }
//    override func viewWillDisappear(animated: Bool) {
//        mapView.showsUserLocation = false;
//        mapView.delegate = nil;
//        mapView.removeFromSuperview();
//        mapView = nil;
//
//    }


}


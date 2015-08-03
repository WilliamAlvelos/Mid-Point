//
//  ViewController.swift
//  MidPoint
//
//  Created by Danilo Mative on 05/05/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation



class GeolocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var localTextField: UITextField!
    
    var nomeUser: String?
    
    let googleAPIKey: String = "AIzaSyA75fDAWf4X6SJmcDA1UDxQNM0HjwMc9bc"
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    var radius: CLLocationDistance = 300
    
    var bool : Bool = true
    
    var activity :activityIndicator?
    
    
    var geoLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(-23.670055, -46.701234)

    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        localTextField.resignFirstResponder()

    }
    @IBAction func groups(sender: AnyObject) {
        let nextViewController = TransitionManager.creatView("ConversasTableView") as! ConversasTableViewController
        
        self.navigationController?.pushViewController(nextViewController, animated: true)

    }
    
    @IBAction func profile(sender: AnyObject) {
        
        let nextViewController = TransitionManager.creatView("ProfileView") as! ProfileViewController
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        
    }
    
    
    func grupos(){
        let nextViewController = TransitionManager.creatView("ConversasTableView") as! ConversasTableViewController
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    
    func perfil(){
        let nextViewController = TransitionManager.creatView("ProfileView") as! ProfileViewController
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let font = UIFont(name: "OpenSans-light", size: 42)

        self.navigationController!.navigationBar.barTintColor = Colors.Azul
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : Colors.Rosa]
        
        self.navigationController?.navigationBar.tintColor = Colors.Rosa

        
        //activity = activityIndicator(view: self.navigationController!, texto: "Buscando Locais", inverse:false, viewController:self)

//        //Inicia a UBA com o numero de botoões
        var uba = UBAView(buttonsQuantity: 3)
//        
//        //Prepara os botões na view passada
        uba.prepareAnimationOnView(self.view, navigation: self.navigationController!.navigationBar.frame.size)
        
        uba.addSelectorToButton(0, target: self, selector: Selector("perfil"), image:"users")
        
        uba.addSelectorToButton(1, target: self, selector: Selector("grupos"), image:"group")
        
        uba.addSelectorToButton(2, target: self, selector: Selector("creatGroup"), image:"group")
    
        
        addPointsOfInterest("", name: "", location: geoLocation, pageToken: "")
//        
//        //Adiciona um seletor para o botão no indice passado
//        var add:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("createConversation"))
//
//        self.navigationItem.rightBarButtonItem = add
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.title = "Mapa"

    }
    
    override func viewWillAppear(animated: Bool) {
        mapView.delegate = self
        locationManager.delegate = self
        mapView.showsUserLocation = true
        localTextField.hidden = true
        
        locationManager.requestAlwaysAuthorization()
    }
    
    
    func createConversation(){
        let nextViewController = TransitionManager.creatView("CreateConversation") as! CreateConversationViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    

    
    
    
    private func addPointsOfInterest(type: String, name: String, location: CLLocationCoordinate2D, pageToken:String) {
        
        mapView.removeAnnotations(mapView.annotations)
        //showActivity()

        

        //Not completed. Needs [ &types=" + type + ] in the future ***
        
        var url = "https://maps.googleapis.com/maps/api/place/search/json?location=\(location.latitude),\(location.longitude)&radius=\(radius)&sensor=true&key=" + googleAPIKey
        
        if name.isEmpty == false {
            url = url + "&name=" + name
        }
        
        if pageToken.isEmpty == false {
            url = "https://maps.googleapis.com/maps/api/place/search/json?key=" + googleAPIKey + "&pagetoken=" + pageToken
        }
        
    
//        if name.isEmpty {
//            url = "https://maps.googleapis.com/maps/api/place/search/json?location=\(location.latitude),\(location.longitude)&radius=\(radius)&types=" + type + "&sensor=true&key=" + googleAPIKey
//
//        }
//        
//        else {
//            url = "https://maps.googleapis.com/maps/api/place/search/json?location=\(location.latitude),\(location.longitude)&radius=\(radius)&types=" + type + "&name=" + name + "&sensor=true&key=" + googleAPIKey
//        }

        let data: NSData? = NSData(contentsOfURL: NSURL(string: url)!)

        var json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers, error: nil)
        
        if data != nil {
            
            var jsonGooogle: AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
            
            var places: NSArray = jsonGooogle.objectForKey("results") as! NSArray
            
            if let token = jsonGooogle.objectForKey("next_page_token") as? String {
                
                addPointsOfInterest(type, name: name, location: location, pageToken:token)
            }
            
            if let error = jsonGooogle.objectForKey("error_message") as? String {
                
                println(error)
            }
            
            if((places.count < 15 && name == "") || places.count < 1){
                
                if(radius < 3000000){
                    radius = radius * 2
                    addPointsOfInterest(type, name: name, location: location, pageToken:"")
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


                mapView.addAnnotation(point)
                
            }
            
        }
        
        
        activity?.removeActivityViewWithName(self)

    
    }
    

    func creatGroup(){
        
        let nextViewController = TransitionManager.creatView("PartidaTableViewController") as! PartidaTableViewController
        var event = Event()
        nextViewController.event = event
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    
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
                    pinView!.pinColor = .Purple
                
                
                    annotation.coordinate
                
                
                
                    let roleButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
                
                    roleButton.addTarget(self, action: "selectRole:", forControlEvents: UIControlEvents.TouchUpInside)
                
                
                    roleButton.frame.size.width = 44
                    roleButton.frame.size.height = 44
                    roleButton.backgroundColor = UIColor.redColor()
                    roleButton.setImage(UIImage(named: "teste.png"), forState: .Normal)
                
                
                
                //var rightButton :UIButton = UIButton.buttonWithType(UIButtonType.InfoDark) as! UIButton
                
                
                
                    pinView!.rightCalloutAccessoryView = roleButton
                
                    var icon = UIImageView(image: UIImage(named: "teste.png"))
                    pinView!.leftCalloutAccessoryView = icon
                
            }
            else {
                pinView!.annotation = annotation
            }
            
            
            return pinView
    }
    
    
    
    
    func selectRole (sender : UIButton!) {
        
        
//        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("CreateConversation") as! CreateConversationViewController
//        
//        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        
        
        var annView = view.annotation
        
    
        let nextViewController = TransitionManager.creatView("PartidaTableViewController") as! PartidaTableViewController
        var event = Event()
        
        
        event.localizacao = Localizacao()
        event.localizacao?.name = annView.title
        
        event.localizacao?.latitude = Float(annView.coordinate.latitude)
        event.localizacao?.longitude = Float(annView.coordinate.longitude)
        
        nextViewController.event = event
        
        nextViewController.location = annView.coordinate
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        
//        annotation *annView = view.annotation;
//        detailedViewOfList *detailView = [[detailedViewOfList alloc]init];
//        detailView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//        detailView.address = annView.address;
//        detailView.phoneNumber = annView.phonenumber;
//        [self presentModalViewController:detailView animated:YES];
    }
    

    @IBAction func actionSearch(sender: AnyObject) {
        
        
        
        if(localTextField.hidden){
            localTextField.hidden = false
            
        }else{
        
            activity = activityIndicator(view: self.navigationController!, texto: "Buscando Locais", inverse: false, viewController: self)
            
            localTextField.hidden = true
            
            var string = localTextField.text.stringByReplacingOccurrencesOfString(" ", withString: "%20", options:  NSStringCompareOptions.LiteralSearch, range: nil)
            
            //var string : String = localTextField.text.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)! as String
            
            
            addPointsOfInterest("", name: string, location: geoLocation, pageToken: "")
            
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            
            //showActivity()
            
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
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {

        locationManager.stopUpdatingLocation()

        var locationArray = locations as NSArray
        var locationObj = locationArray.lastObject as! CLLocation
        var coord = locationObj.coordinate
        
        let region = MKCoordinateRegionMakeWithDistance(coord, radius, radius)
        
        geoLocation = coord
        
        if(self.bool){
            addPointsOfInterest("", name: "", location: geoLocation, pageToken: "")
            self.bool = false
        }
        mapView.setRegion(region, animated: true)
        
        mapView.userLocation.title = nomeUser
        
        var string : String = localTextField.text.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)! as String

    }

    
    func getMiddleDistanceFromPoints(coordinate1: CLLocationCoordinate2D, coordinate2: CLLocationCoordinate2D) {
        
        var source = MKMapItem( placemark: MKPlacemark(
            coordinate: coordinate1,
            addressDictionary: nil))
        var destination = MKMapItem(placemark: MKPlacemark(
            coordinate: coordinate2,
            addressDictionary: nil))
        
        var directionsRequest = MKDirectionsRequest()
        directionsRequest.setSource(source)
        directionsRequest.setDestination(destination)
        
        var directions = MKDirections(request: directionsRequest)
        
        directions.calculateDirectionsWithCompletionHandler { (response, error) -> Void in
            println(error)
            
            if error != nil {
                
            }
            else {
                
                for(var x = 0; x < response.routes.count; x++) {
                     
                    println(response.routes[x].distance)
                }
                
                
            }
        }
        
        
    }
}





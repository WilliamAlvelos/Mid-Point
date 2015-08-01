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
    
    var locationManager = CLLocationManager()
    
    var array = Array<User>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userManager = UserManager()
        
        userManager!.delegate = self
        mapView.delegate = self
        locationManager.delegate = self
        mapView.showsUserLocation = true
        
        self.title = "MID POINT"

        
        userManager!.getUsersFrom(event!)
        
        
        
        var tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("tap:"))
        
        tapRecognizer.numberOfTapsRequired = 1
        
        tapRecognizer.numberOfTouchesRequired = 1
        
        self.mapView.addGestureRecognizer(tapRecognizer)
        
        
        //        //Inicia a UBA com o numero de botoões
        var uba = UBAView(buttonsQuantity: 4)
        //
        //        //Prepara os botões na view passada
        uba.prepareAnimationOnView(self.view, navigation: self.navigationController!.navigationBar.frame.size)
        
        uba.addSelectorToButton(0, target: self, selector: Selector("acepted"), image:"group")
        
        uba.addSelectorToButton(1, target: self, selector: Selector("refused"), image:"group")
        
        uba.addSelectorToButton(2, target: self, selector: Selector("passed"), image:"group")
        
        uba.addSelectorToButton(3, target: self, selector: Selector("owner"), image:"group")
        
    }
    func tap(recognizer: UITapGestureRecognizer){
        
        var point: CGPoint = recognizer.locationInView(self.mapView)
        
        var tapPoint: CLLocationCoordinate2D = self.mapView.convertPoint(point, toCoordinateFromView: self.view)
        
        var point1 : MKPointAnnotation = MKPointAnnotation()
        
        point1.coordinate = tapPoint

        var localizacao = Localizacao()
        
        localizacao.latitude = NSNumber(double: point1.coordinate.latitude) as Float
        
        localizacao.longitude = NSNumber(double: point1.coordinate.longitude) as Float

        
        localizacao.name = UserDAODefault.getLoggedUser().name
        
        self.userManager?.updateUserLocation(UserDAODefault.getLoggedUser(), location: localizacao, event: event!)
        
//        self.mapView.addAnnotation(point1)
//    
    }
    
    
    func acepted(){
        self.userManager?.updateUserState(UserDAODefault.getLoggedUser(), state: Option.Accepted, event: event!)
        

    }
    
    func owner(){
        self.userManager?.updateUserState(UserDAODefault.getLoggedUser(), state: Option.Owner, event: event!)
    }
    
    
    func passed(){
        self.userManager?.updateUserState(UserDAODefault.getLoggedUser(), state: Option.Passed, event: event!)
    }
    
    func refused(){
        self.userManager?.updateUserState(UserDAODefault.getLoggedUser(), state: Option.Refused, event: event!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func addUsersMap(){
        
        
//        for (var i = 0; i < mapView.annotations.count; i++){
//            if
//            
//            mapView.removeAnnotation(mapView.annotations[i].annotation)
//        }

        
        
        for(var i = 0; i < self.array.count; i++){
            var point: MKPointAnnotation = MKPointAnnotation()
            
            var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double(self.array[i].location!.latitude!), Double(self.array[i].location!.longitude!))
            
            point.title = self.array[i].name
            point.coordinate = coordinate
            
            
            mapView.addAnnotation(point)
        
        }
        
        
        
        var point: MKPointAnnotation = MKPointAnnotation()
        
        var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double(self.event!.localizacao!.latitude!), Double(self.event!.localizacao!.longitude!))
        
        point.title = self.event?.localizacao?.name
        point.coordinate = coordinate
        
        
        mapView.addAnnotation(point)
    
    }
    
    
    
    func mapView(mapView: MKMapView!,
        viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
            
            if annotation is MKUserLocation {
                return nil
            }
            
            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            
            
            if(pinView?.annotation.title == event!.localizacao?.name){
                pinView!.pinColor = .Red
            
            }
            
            pinView?.pinColor = MKPinAnnotationColor.Green

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
    

    
    func getUsersFinished(users: Array<User>) {
        self.array = users
        addUsersMap()
    }

    
    func errorThrowedServer(stringError: String) {
        
    }
    
    func errorThrowedSystem(error: NSError) {
        
    }

    
    func updateLocationFinished() {
        self.userManager?.getUsersFrom(event!)
    }
    


}

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
    
    var activity: activityIndicator?
    
    var pins = Array<MKPointAnnotation>()
    
    var gestureRecognizer: GestureRecognizerMap?
    override func viewDidLoad() {
        super.viewDidLoad()
        userManager = UserManager()
        
        userManager!.delegate = self
        mapView.delegate = self
        locationManager.delegate = self
        mapView.showsUserLocation = true
        
        self.title = "MID POINT"
        gestureRecognizer  = GestureRecognizerMap()
        
        gestureRecognizer!.initWithViewController(self, mapView: self.mapView)
    
       // userManager!.getUsersFrom(event!)
        
        //        //Inicia a UBA com o numero de botoões
       // var uba = UBAView(buttonsQuantity: 4)
        //
        //        //Prepara os botões na view passada
//        uba.prepareAnimationOnView(self.view, navigation: self.navigationController!.navigationBar.frame.size)
//        
//        uba.addSelectorToButton(0, target: self, selector: Selector("acepted"), image:"group")
//        
//        uba.addSelectorToButton(1, target: self, selector: Selector("refused"), image:"group")
//        
//        uba.addSelectorToButton(2, target: self, selector: Selector("passed"), image:"group")
//        
//        uba.addSelectorToButton(3, target: self, selector: Selector("owner"), image:"group")
        
    }
//    func addUsersMap(){
//        
//        
//        mapView.removeAnnotations(self.mapView.annotations)
//        
//        for(var i = 0; i < self.array.count; i++){
//            var point: MKPointAnnotation = MKPointAnnotation()
//            
//            var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double(self.array[i].location!.latitude!), Double(self.array[i].location!.longitude!))
//            
//            point.title = self.array[i].name
//            point.coordinate = coordinate
//            
//            
//            mapView.addAnnotation(point)
//        
//        }
//        
//        var point: MKPointAnnotation = MKPointAnnotation()
//        
//        var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double(self.event!.localizacao!.latitude!), Double(self.event!.localizacao!.longitude!))
//        
//        point.title = self.event?.localizacao?.name
//        point.coordinate = coordinate
//        
//        
//        mapView.addAnnotation(point)
//        
//        self.pins.append(point)
//        
//        activity?.removeActivityViewWithName(self)
//    
//    }
//    
//    
//    
//    func mapView(mapView: MKMapView!,
//        viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
//            
//            if annotation is MKUserLocation {
//                return nil
//            }
//            
//            let reuseId = "pin"
//            
//            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
//            if pinView == nil {
//                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//                pinView!.canShowCallout = true
//                pinView!.animatesDrop = true
//                pinView!.canBecomeFirstResponder()
//                pinView!.pinColor = .Purple
//                
//
//                
//                pinView?.pinColor = MKPinAnnotationColor.Green
//                
//                if(pinView?.annotation.title == event!.localizacao?.name){
//                    pinView!.pinColor = .Red
//                    
//                }
//                
//                
//
//                
//            }
//            else {
//                pinView!.annotation = annotation
//            }
//            
//            
//            
//
//            return pinView
//    }
//    
//    
//    
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
       // addUsersMap()
    }

    
    func errorThrowedServer(stringError: String) {
        
    }
    
    func errorThrowedSystem(error: NSError) {
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        mapView.showsUserLocation = false;
        mapView.delegate = nil;
        mapView.removeFromSuperview();
        mapView = nil;
    }


}

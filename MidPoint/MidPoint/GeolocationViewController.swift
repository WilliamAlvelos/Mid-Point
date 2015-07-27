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

    @IBOutlet var activity: UIActivityIndicatorView!
    @IBOutlet var localTextField: UITextField!
    
    var nomeUser: String?
    
    let googleAPIKey: String = "AIzaSyDHIzjnXRJtWRDpPsux99HhTwjOmcLQplU"
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    var radius: CLLocationDistance = 300
    
    
    var geoLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(-23.670055, -46.701234)

    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        localTextField.resignFirstResponder()

    }
    @IBAction func groups(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("ConversasTableView") as! ConversasTableViewController
        
        self.navigationController?.pushViewController(nextViewController, animated: true)

    }
    
    override func viewWillAppear(animated: Bool) {
        mapView.delegate = self
        locationManager.delegate = self
        mapView.showsUserLocation = true
        localTextField.hidden = true
        showActivity()
        

        
        locationManager.requestAlwaysAuthorization()
        
        var coorSP:CLLocationCoordinate2D = CLLocationCoordinate2DMake(-23.670055, -46.701234)
        var coor2:CLLocationCoordinate2D = CLLocationCoordinate2DMake(-23.690055, -46.901234)
        
        getMiddleDistanceFromPoints(coorSP, coordinate2: coor2)
        //addPointsOfInterest("restaurant|food", name: "", location: coor2);
        //addLocationsFromGoogle()
        
        activity.stopAnimating()
        
        self.title = "Mapa"
    }
    
    
    func showActivity(){
        activity.hidesWhenStopped = true
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activity.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        activity.layer.cornerRadius = 10
        activity.startAnimating()
    }
    
    
    
    
    private func addPointsOfInterest(type: String, name: String, location: CLLocationCoordinate2D) {
        
        mapView.removeAnnotations(mapView.annotations)
        showActivity()

        
        
        var url: String?
        //var url2: String!
        
        if name.isEmpty {
            url = "https://maps.googleapis.com/maps/api/place/search/json?location=\(location.latitude),\(location.longitude)&radius=\(radius)&types=" + type + "&sensor=true&key=" + googleAPIKey

            
            //url = "https://api.foursquare.com/v2/venues/search?client_id=AF0RKOHW12ZHKMLCLO0C5LV0CA3CQEFC2RBIV4TDUQARJCE0&client_secret=VBQQDPB5OHA4NFRX5O02KZR5FVDNNBKC1HLB1YKJUTTLODNB&v=20130815&ll=\(location.latitude),\(location.longitude)&query="
        }else {
            url = "https://maps.googleapis.com/maps/api/place/search/json?location=\(location.latitude),\(location.longitude)&radius=\(radius)&types=" + type + "&name=" + name + "&sensor=true&key=" + googleAPIKey
            
            //url = "https://api.foursquare.com/v2/venues/search?client_id=AF0RKOHW12ZHKMLCLO0C5LV0CA3CQEFC2RBIV4TDUQARJCE0&client_secret=VBQQDPB5OHA4NFRX5O02KZR5FVDNNBKC1HLB1YKJUTTLODNB&v=20130815&ll=\(location.latitude),\(location.longitude)&query="+name
            
        }

        let data: NSData? = NSData(contentsOfURL: NSURL(string: url!)!)

        var json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers, error: nil)
        
        if data != nil {
            
            var jsonGooogle: AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
            
            var places: NSArray = jsonGooogle.objectForKey("results") as! NSArray
            
            
            if((places.count < 15 && name == "") || places.count < 1){
                
                if(radius < 3000000){
                    radius = radius * 2
                    addPointsOfInterest(type, name: name, location: location)
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
        
//        let data1: NSData?
//        
//        data1 = NSData(contentsOfURL: NSURL(string: url!)!)
//            
//        if data1 != nil {
//
//            
//            var jsonFourSquare: AnyObject! = NSJSONSerialization.JSONObjectWithData(data1!, options: NSJSONReadingOptions.MutableContainers, error: nil)
//            
//            
//            var venues: NSDictionary = jsonFourSquare.objectForKey("response") as! NSDictionary
//            
//            var placesFourSquare: NSArray = venues.objectForKey("venues") as! NSArray
//            
//            if((placesFourSquare.count < 15 && name == "") || placesFourSquare.count < 1){
//                radius = radius + 500
//                
//                if(radius < 15000){
//                    addPointsOfInterest(type, name: name, location: location)
//                }
//                
//            }
//            
//            
//            for(var x = 0; x < placesFourSquare.count; x++) {
//                
//                var placeFourSquare: NSDictionary = placesFourSquare.objectAtIndex(x) as! NSDictionary
//                
//                var locFourSquare: NSDictionary = placeFourSquare.objectForKey("location") as! NSDictionary
//                
//                var nameFourSquare: String = placeFourSquare.objectForKey("name") as! String
//                
//                var latFourSquare: NSNumber = locFourSquare.objectForKey("lat") as! NSNumber
//                
//                var lonFourSquare: NSNumber = locFourSquare.objectForKey("lng") as! NSNumber
//                
//                var pointFourSquare: MKPointAnnotation = MKPointAnnotation()
//                
//                var coordinateFourSquare: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latFourSquare.doubleValue, lonFourSquare.doubleValue)
//                
//                pointFourSquare.title = nameFourSquare
//                pointFourSquare.coordinate = coordinateFourSquare
//                pointFourSquare.subtitle = "FourSquare"
//                
//                mapView.addAnnotation(pointFourSquare)
//                
//            }
//            
//        }
        

        activity.stopAnimating()
    
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
                
                
                
                    let roleButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
                
                    roleButton.addTarget(self, action: "selectRole:", forControlEvents: UIControlEvents.TouchUpInside)
                
                    roleButton.frame.size.width = 44
                    roleButton.frame.size.height = 44
                    roleButton.backgroundColor = UIColor.redColor()
                    roleButton.setImage(UIImage(named: "teste.png"), forState: .Normal)
                
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
        println("role Selecionado")
        
    }
    

    @IBAction func actionSearch(sender: AnyObject) {
        
        if(localTextField.hidden){
            localTextField.hidden = false
        }else{
            localTextField.hidden = true
            
            var string = localTextField.text.stringByReplacingOccurrencesOfString(" ", withString: "%20", options:  NSStringCompareOptions.LiteralSearch, range: nil)
            
            //var string : String = localTextField.text.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)! as String
            
            
            
            
            
            addPointsOfInterest("", name: string, location: geoLocation);
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            
            showActivity()
            
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
            
            activity.stopAnimating()
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        
        locationManager.stopUpdatingLocation()

        var locationArray = locations as NSArray
        var locationObj = locationArray.lastObject as! CLLocation
        var coord = locationObj.coordinate
        
        let region = MKCoordinateRegionMakeWithDistance(coord, radius, radius)
        
        geoLocation = coord
        
        mapView.setRegion(region, animated: true)
        
        mapView.userLocation.title = nomeUser
        
        var string : String = localTextField.text.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)! as String
        
        
        addPointsOfInterest("", name: string, location: coord);

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





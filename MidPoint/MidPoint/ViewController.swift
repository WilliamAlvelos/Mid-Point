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



class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var localTextField: UITextField!
    
    let googleAPIKey: String = "AIzaSyDHIzjnXRJtWRDpPsux99HhTwjOmcLQplU"
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    let radius: CLLocationDistance = 100
    
    
    var geoLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(-23.670055, -46.701234)

    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        localTextField.resignFirstResponder()
//        var coor2:CLLocationCoordinate2D = CLLocationCoordinate2DMake(-23.690055, -46.901234)
//        addPointsOfInterest("", name: localTextField.text, location: coor2);
    }
    
    override func viewWillAppear(animated: Bool) {
        mapView.delegate = self
        locationManager.delegate = self
        mapView.showsUserLocation = true
        localTextField.hidden = true
        
        locationManager.requestAlwaysAuthorization()
        
        var coorSP:CLLocationCoordinate2D = CLLocationCoordinate2DMake(-23.670055, -46.701234)
        var coor2:CLLocationCoordinate2D = CLLocationCoordinate2DMake(-23.690055, -46.901234)
        
        getMiddleDistanceFromPoints(coorSP, coordinate2: coor2)
        //addPointsOfInterest("restaurant|food", name: "", location: coor2);
        //addLocationsFromGoogle()
        
    }
    
    private func addPointsOfInterest(type: String, name: String, location: CLLocationCoordinate2D) {
        
        mapView.removeAnnotations(mapView.annotations)
        
        
        var url: String!
        var url2: String!
        
        if name.isEmpty {
            url = "https://maps.googleapis.com/maps/api/place/search/json?location=\(location.latitude),\(location.longitude)&radius=5000&types=" + type + "&sensor=true&key=" + googleAPIKey

            
            url2 = "https://api.foursquare.com/v2/venues/search?client_id=AF0RKOHW12ZHKMLCLO0C5LV0CA3CQEFC2RBIV4TDUQARJCE0&client_secret=VBQQDPB5OHA4NFRX5O02KZR5FVDNNBKC1HLB1YKJUTTLODNB&v=20130815&ll=\(location.latitude),\(location.longitude)&query=" + type
        }
        
        else {
            url = "https://maps.googleapis.com/maps/api/place/search/json?location=\(location.latitude),\(location.longitude)&radius=5000&types=" + type + "&name=" + name + "&sensor=true&key=" + googleAPIKey
            
            url2 = "https://api.foursquare.com/v2/venues/search?client_id=AF0RKOHW12ZHKMLCLO0C5LV0CA3CQEFC2RBIV4TDUQARJCE0&client_secret=VBQQDPB5OHA4NFRX5O02KZR5FVDNNBKC1HLB1YKJUTTLODNB&v=20130815&ll=\(location.latitude),\(location.longitude)&query="+type
            
        }

        if let data = NSData(contentsOfURL: NSURL(string: url)!) {
            
            
            var jsonGooogle: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)
            
            var places: NSArray = jsonGooogle.objectForKey("results") as! NSArray
            
            
            
            for(var x = 0; x < places.count; x++) {
                
                var place: NSDictionary = places.objectAtIndex(x) as! NSDictionary
                var geo: NSDictionary = place.objectForKey("geometry") as! NSDictionary
                var icon: String = place.objectForKey("icon") as! String
                var loc: NSDictionary = geo.objectForKey("location") as! NSDictionary
                var name: String = place.objectForKey("name") as! String
                var lat: NSNumber = loc.objectForKey("lat") as! NSNumber
                var lon: NSNumber = loc.objectForKey("lng") as! NSNumber
                var point: MKPointAnnotation = MKPointAnnotation()
                
                var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat.doubleValue, lon.doubleValue)
                
                
                point.title = name
                point.coordinate = coordinate
                
                mapView.addAnnotation(point)
                
                
            }
            
        }
        
        
        if let data1: NSData = NSData(contentsOfURL: NSURL(string: url2)!){
            
            var jsonFourSquare: AnyObject! = NSJSONSerialization.JSONObjectWithData(data1, options: NSJSONReadingOptions.MutableContainers, error: nil)
            
            
            var venues: NSDictionary = jsonFourSquare.objectForKey("response") as! NSDictionary
            
            var placesFourSquare: NSArray = venues.objectForKey("venues") as! NSArray
            
            
            for(var x = 0; x < placesFourSquare.count; x++) {
                
                var placeFourSquare: NSDictionary = placesFourSquare.objectAtIndex(x) as! NSDictionary
                
                var locFourSquare: NSDictionary = placeFourSquare.objectForKey("location") as! NSDictionary
                
                var nameFourSquare: String = placeFourSquare.objectForKey("name") as! String
                
                var latFourSquare: NSNumber = locFourSquare.objectForKey("lat") as! NSNumber
                
                var lonFourSquare: NSNumber = locFourSquare.objectForKey("lng") as! NSNumber
                
                var pointFourSquare: MKPointAnnotation = MKPointAnnotation()
                
                var coordinateFourSquare: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latFourSquare.doubleValue, lonFourSquare.doubleValue)
                
                
                pointFourSquare.title = nameFourSquare
                pointFourSquare.coordinate = coordinateFourSquare
                
                
                mapView.addAnnotation(pointFourSquare)
                
            }
            
        
        }
    
    }
    
    @IBAction func actionSearch(sender: AnyObject) {
        
        if(localTextField.hidden){
            localTextField.hidden = false
            addPointsOfInterest("", name: localTextField.text, location: geoLocation);
            locationManager.startUpdatingLocation()
        }else{
            localTextField.hidden = true
        }
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
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
//        var coorSP:CLLocationCoordinate2D = CLLocationCoordinate2DMake(-23.670055, -46.701234)
        
        locationManager.stopUpdatingLocation()

        var locationArray = locations as NSArray
        var locationObj = locationArray.lastObject as! CLLocation
        var coord = locationObj.coordinate
        
        let region = MKCoordinateRegionMakeWithDistance(coord, radius, radius)
        
        geoLocation = coord

        
        mapView.setRegion(region, animated: true)
        
        addPointsOfInterest("restaurant", name: localTextField.text, location: coord);

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





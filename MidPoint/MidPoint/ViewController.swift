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

    let googleAPIKey: String = "AIzaSyDHIzjnXRJtWRDpPsux99HhTwjOmcLQplU"
    
    var locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    let radius: CLLocationDistance = 100

    
    override func viewWillAppear(animated: Bool) {
        mapView.delegate = self
        locationManager.delegate = self
        mapView.showsUserLocation = true
        
        locationManager.requestAlwaysAuthorization()
        
        var coorSP:CLLocationCoordinate2D = CLLocationCoordinate2DMake(-23.670055, -46.701234)
        var coor2:CLLocationCoordinate2D = CLLocationCoordinate2DMake(-23.690055, -46.901234)
        
        getMiddleDistanceFromPoints(coorSP, coordinate2: coor2)
        //addLocationsFromGoogle()
        
    }
    
    private func addPointsOfInterest(type: String, name: String, location: CLLocationCoordinate2D) {
        
        var url: String
        
        if name.isEmpty {
            url = "https://maps.googleapis.com/maps/api/place/search/json?location=-23.670055,-46.701234&radius=1000&types=" + type + "&sensor=true&key=" + googleAPIKey
        }
        
        else {
            url = "https://maps.googleapis.com/maps/api/place/search/json?location=-23.670055,-46.701234&radius=1000&types=" + type + "&name=" + name + "&sensor=true&key=" + googleAPIKey
        }

        var data: NSData = NSData(contentsOfURL: NSURL(string: url)!)!
        
        var json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)
        
        var places: NSArray = json.objectForKey("results") as! NSArray
        
        for(var x = 0; x < places.count; x++) {
            
            var place: NSDictionary = places.objectAtIndex(x) as! NSDictionary
            var geo: NSDictionary = place.objectForKey("geometry") as! NSDictionary
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
        
        var coorSP:CLLocationCoordinate2D = CLLocationCoordinate2DMake(-23.670055, -46.701234)
        
        let region = MKCoordinateRegionMakeWithDistance(coorSP, radius, radius)
        //mapView.setRegion(region, animated: true)
        
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





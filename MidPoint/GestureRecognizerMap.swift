//
//  GestureRecognizerMap.swift
//  MidPoint
//
//  Created by Joao Sisanoski on 8/1/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import UIKit
protocol GestureRecognizerMapDelegate {
func getLocationMapFinished(location: Localizacao)
}
class GestureRecognizerMap: NSObject , UIGestureRecognizerDelegate{
    var tapRecognizer: UITapGestureRecognizer?
    var mapView: MKMapView?
    var viewController: UIViewController?
    var delegate: GestureRecognizerMapDelegate?
    private var  alertView1 =  JSSAlertView()
    private var showing: Bool?
    func initWithViewController(viewController : UIViewController ,mapView: MKMapView){
        var tapRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("tap:"))
        tapRecognizer.minimumPressDuration = 3
        tapRecognizer.numberOfTouchesRequired = 1
        self.mapView = mapView
        self.viewController = viewController
        self.mapView!.addGestureRecognizer(tapRecognizer)
    }
    
    func tap(sender: UIGestureRecognizer){
        if (showing == true){
            return
        }
        showing = true
        alertView1.show(viewController!.view, title: "Carregando", text: "Buscando as informações sobre o local", buttonText: nil, color: UIColorFromHex(0x9b59b6, alpha: 1))
        alertView1.setTextTheme(.Light)
        var point: CGPoint = sender.locationInView(self.mapView)
        
        var tapPoint: CLLocationCoordinate2D = self.mapView!.convertPoint(point, toCoordinateFromView: self.viewController!.view)
        var point1 : MKPointAnnotation = MKPointAnnotation()
        
        point1.coordinate = tapPoint
        
        var localizacao = Localizacao()
        localizacao.latitude = Float(point1.coordinate.latitude)
        localizacao.longitude = Float(point1.coordinate.longitude)

        let geocoder = CLGeocoder()
        let location : CLLocation = CLLocation(latitude: Double(localizacao.latitude!), longitude: Double(localizacao.longitude!))
        
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            let placeArray = placemarks as? [CLPlacemark]
            var placeMark: CLPlacemark!
            placeMark = placeArray?[0]
            if let street = placeMark.addressDictionary["Name"] as? String {
                localizacao.streetName = street
            }

            self.alertView1.removeView()
            self.showing = false
            self.delegate?.getLocationMapFinished(localizacao)
        })
    }

}

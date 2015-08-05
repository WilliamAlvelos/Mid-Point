//
//  PartidaSelectVC.swift
//  MidPoint
//
//  Created by Joao Sisanoski on 8/1/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import UIKit
protocol PartidaSelectProtocol {
    func locationFinished(location : Localizacao?)
}
class PartidaSelectVC: UIViewController, GestureRecognizerMapDelegate, UserManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var location: Localizacao?
    var gestureRecognizer: GestureRecognizerMap?
    var locations: Array<Localizacao>?
    var userManager : UserManager?
    var alertView1: JSSAlertView?
    private var viewToPres: UIView?
    var delegate: PartidaSelectProtocol?
    var shouldReturn : Bool = false
    override func viewDidLoad() {
        gestureRecognizer = GestureRecognizerMap()
        gestureRecognizer?.delegate = self
        gestureRecognizer?.initWithViewController(self, mapView: self.mapView)
        userManager = UserManager()
        userManager?.delegate = self
        viewToPres = view
        
    }
    
    override func viewWillAppear(animated: Bool) {
        for loc in locations! {
            let pin : MKPointAnnotation = MKPointAnnotation()
            pin.coordinate.latitude = Double(loc.latitude!)
            pin.coordinate.longitude = Double(loc.longitude!)
            pin.title = loc.name!
            self.mapView.addAnnotation(pin)
        }
    }
    func errorThrowedServer(stringError: String) {
        
    }
    func errorThrowedSystem(error: NSError) {
        
    }
    func getLocationMapFinished(location: Localizacao) {
        location.name = location.streetName
        var customIcon = UIImage(named: "lightbulb")
        alertView1 = JSSAlertView()
        alertView1!.show(self.view, title: "Local da partida", text: "Seu local de partida é \(location.streetName!)?                       ", buttonText: "Sim", cancelButtonText: "Não",color: Colors.Rosa, iconImage: customIcon)
        alertView1!.addAction(closeCallback)
        alertView1?.addCancelAction(cancelCallback)
        alertView1!.setTextTheme(.Light)
        self.location = location
    }
    
    func closeCallback() {
        alertView1!.show(self.view!, title: "Carregando", text: "Estamos atualizando.", buttonText: nil, color: Colors.Rosa)
        userManager?.insereNovaLocalizacao(UserDAODefault.getLoggedUser(), localizacao: self.location!)
    }
    
    func cancelCallback() {
        
    }
    func insertLocationFinished() {
        alertView1?.removeView()
        self.delegate?.locationFinished(location)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewWillDisappear(animated: Bool) {
        
        self.cleanClass()
    }
    func cleanClass(){
        self.mapView!.showsUserLocation = false
        mapView.delegate = nil;
        mapView.removeFromSuperview()
        mapView = nil;
    }
}

//
//  ProfileViewController.swift
//  MidPoint
//
//  Created by William Alvelos on 14/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, EventManagerDelegate, UserManagerDelegate, ETBNavigationTitle
{

    var ocView: OCView!

    var navItem: UINavigationItem?
    
    var activity : activityIndicator?
    
    var userManager: UserManager?
    
    var carregou: Bool = false
    
    var eventManager : EventManager = EventManager()
    
    var events = Array<Event>()
    
    var imageUsers = Array<User>()
    
    var user:User?
    
    var quantidade = 0
    
    var eventosCarregados = Array<Event>()
    
    var a = 0
    
    var j = 0
 
    @IBOutlet var tableView: UITableView!

    @IBOutlet var gestureView: UIView!
    
    var refreshControl: UIRefreshControl?
    
    
     override func viewDidLoad() {
    
        if(user == nil){
            user = UserDAODefault.getLoggedUser()
        }
        self.userManager = UserManager()
        
        self.userManager!.delegate = self
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = Colors.Azul
        self.refreshControl?.tintColor = Colors.Rosa
        self.refreshControl?.addTarget(self, action: Selector("reloadData"), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(self.refreshControl!)

        self.tableView.backgroundColor = Colors.Azul
        self.view.backgroundColor = Colors.Azul
        
        self.eventManager.delegate = self
        
        navItem = self.navigationItem
        
        navItem?.title = user!.name
        
        tableView.delegate = self
        tableView.dataSource = self
        
        reloadData()
        tableView.estimatedRowHeight = 200.0
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.activity?.removeActivityViewWithName(self)
    }
    
    func reloadData(){
        self.refreshControl?.endRefreshing()
        
        eventManager.getEventsFromUser(self.user!, usuario: .All)
        //eventManager.getEvent(UserDAODefault.getLoggedUser(), usuario: .All)
        animateTable()
    }
    
    func imagesUser(){
        self.quantidade = self.events.count
        
        for(var i = 0 ; i < self.events.count; i++){
            self.userManager!.getUsersFrom(self.events[i])
        }
    }

    
    override func viewWillAppear(animated: Bool) {
        
        /* Cria uma nova ETB, com a quantidade de botões
        na barra e a imagem de cada um deles */
        var newETB = ETBScrollView(numberOfButtons: 3, images:[UIImage(named: "user_historico")!, UIImage(named: "user_locais_favoritos")!,UIImage(named: "user_chat")!], backgroundImage:UIImage(named: "testbg.png")!)
        
        //Foto do usuário
        newETB.profileImage = UIImage(named: "4user.png")
        
        //Nome do usuário
        newETB.profileName = "Felipe Viana Teruel"
        
        //Local do usuário
        newETB.profileLocation = "Diadema, SP"
        
        //ETB Delegate
        newETB.ETBNavigationDelegate = self
        
        var contentView = UIView(frame: CGRectMake(0.0, 0.0, self.view.frame.size.width, CGFloat(events.count) * tableView.estimatedRowHeight))
        contentView.frame.size.height = 800
        
        
        tableView.frame.size.height = contentView.frame.size.height
        tableView.frame.origin = CGPointZero
        
        var rect = contentView.frame
       // contentView.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //newETB.prepareScrollViewWithContentView(contentView, frame: self.view.frame, navigationBar: self.navigationController!.navigationBar)
        
        //Adiciona a ETB na view
        //self.view.addSubview(newETB)
        
        animateTable()
        self.carregou = false

    }
    
    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells()
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as! UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as! UITableViewCell
            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: nil, animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.reloadData()
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 200;
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
        var nextView = TransitionManager.creatView("infoEvent") as! EventInfoViewController
        nextView.event = self.events[indexPath.row]
        self.navigationController?.pushViewController(nextView, animated: true)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:CustomCellProfile = self.tableView.dequeueReusableCellWithIdentifier("CustomCellProfile") as! CustomCellProfile
        
        
        
        //var activity: activityCell?
        
        
        //activity = activityCell(view: cell.view, inverse: true)
        
        var image = self.events[indexPath.row].image
        
        cell.titleEvent.text = self.events[indexPath.row].name
        
        cell.selectionStyle = .None
    
        cell.descricao.text = self.events[indexPath.row].descricao
        
        var auxDouble:Double = NSNumber(float: self.events[indexPath.row].localizacao!.latitude!).doubleValue

        var aux:Double = NSNumber(float: self.events[indexPath.row].localizacao!.latitude!).doubleValue
        
        var latitude: CLLocationDegrees = auxDouble
        var longitude: CLLocationDegrees = aux

        var location = CLLocation(latitude: latitude, longitude: longitude)
        //println(location)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            var placemark:CLPlacemark!
            
            if error == nil && placemarks.count > 0 {
                placemark = placemarks[0] as! CLPlacemark
                
                var addressString : String = ""
                    if placemark.locality != nil {
                        addressString = addressString + placemark.locality + ", "
                    }
                    if placemark.country != nil {
                        addressString = addressString + placemark.country
                    }
                    else{
                        addressString = addressString + "Local não encontrado"
                        
                    }
               // }
                
                    cell.localHorarioEvento.text = addressString
                }
            })
        var s = "\(self.events[indexPath.row].numberOfPeople!) Pessoas "
        if !(self.events[indexPath.row].numberOfPeople! > 1){
            s = "1 pessoa"
        }
         cell.numeroPessoas.text? = s
        if(image != nil){


            let contextImage: UIImage = UIImage(CGImage: image!.CGImage)!
            
            let contextSize: CGSize = contextImage.size
            
            var rect: CGRect = CGRectMake(image!.size.width/4, image!.size.height/4, 375, 200)
            let imageRef: CGImageRef = CGImageCreateWithImageInRect(contextImage.CGImage, rect)
            let imageFinal: UIImage = UIImage(CGImage: imageRef, scale: image!.scale, orientation: image!.imageOrientation)!

            var images = [UIImage]()
            
            
            if(self.a == self.events.count){
                for(var x = 0; x < self.events[indexPath.row].pessoas.count; x++){
                    images.append(self.events[indexPath.row].pessoas[x].image!)
                }
            
                rect = CGRectMake(0, 0, cell.view.frame.size.width, cell.view.frame.size.height)
                ocView = OCView(mainImage: imageFinal, insideImages: images, frame: rect)
         
                cell.view.addSubview(ocView)
                
            }
            else{
                cell.view.backgroundColor = UIColor(patternImage: self.events[indexPath.row].image!)
                
            }
        
         
            
            
            
            rect = CGRectMake(0, 0, cell.view.frame.size.width, cell.view.frame.size.height)
            
            ocView = OCView(mainImage: imageFinal, insideImages: images, frame: rect)
            cell.view.addSubview(ocView)
   }
        
        cell.titleEvent.textColor = Colors.Branco
        cell.descricao.textColor = Colors.Branco
        cell.numeroPessoas.textColor = Colors.Branco
        cell.localHorarioEvento.textColor = Colors.Branco
        
        return cell
    }
    
    
    func getEventsFinished(events: Array<Event>) {
        activity = activityIndicator(view: self.navigationController!, texto: "Carregando Eventos", inverse: false, viewController: self)
        
        
        self.events = events
        self.eventManager.getImages(events)
        
        
        
        
    }
    
    
    
    func downloadImageUsersFinished(users: Array<User>, event: Event) {
        event.pessoas = users
        a++
        if a == self.events.count{
            self.tableView.reloadData()
        }
    }

    func getUsersFinished(users: Array<User>, event: Event) {
        self.userManager?.getImages(users, event: event)

    }
    
    func getUsersFinished(users: Array<User>) {
        

    }


    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        var rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func errorThrowedServer(stringError: String) {
        
    }
    func errorThrowedSystem(error: NSError) {
        
    }
    func downloadImageEventsFinshed(images: Array<Event>) {
        self.events = images
        self.activity?.removeActivityViewWithName(self)
       
        for event in events{
            self.userManager?.getUsersFrom(event)
        }
        //self.tableView.reloadData()
    }
    
    func downloadImageEventFinshed(event: Event) {

        //descobrir aonde esta esse evento na table view e entao recarregar
    }
    
    //MARK: ETB Delegate
    
    func shouldDisplayTitle(title:String!) {
        self.title = title
    }
    
    func shouldHideTitle() {
        self.title = ""
    }
}
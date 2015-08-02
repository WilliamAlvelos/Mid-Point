//
//  ProfileViewController.swift
//  MidPoint
//
//  Created by William Alvelos on 14/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, EventManagerDelegate, UserManagerDelegate
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
    
    
    var j = 0
 
    @IBOutlet var tableView: UITableView!

    @IBOutlet var gestureView: UIView!
    
    var refreshControl: UIRefreshControl?
    
    
     override func viewDidLoad() {
    
        user = UserDAODefault.getLoggedUser()
        
        self.userManager = UserManager()
        
        self.userManager!.delegate = self
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = Colors.Azul
        self.refreshControl?.tintColor = Colors.Rosa
        self.refreshControl?.addTarget(self, action: Selector("reloadData"), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(self.refreshControl!)
        
        
        var newETB = ETBScrollView(numberOfButtons: 3, images:[UIImage(named: "btest1.png")!, UIImage(named: "btest2.png")!,UIImage(named: "btest3.png")!])
        
        //Cor de fundo da barra
        newETB.toolbarBackgroundColor = Colors.Azul
        
        //Foto do usuário
        newETB.profileImage = user?.image
        
        //Nome do usuário
        newETB.profileName = user?.name
        
        //Local do usuário
        newETB.profileLocation = "Maceio"
        
        //View de teste
        var viewTeste = UIView(frame:self.view.frame)
        viewTeste.backgroundColor = Colors.Rosa
        
        //Prepara a ETB, passando a view com o conteúdo que ela terá normalmente e o frame da view onde a ETB será inserida
        newETB.prepareScrollViewWithContent(self.view, frame: self.view.frame)
        
        
        
        self.tableView.backgroundColor = Colors.Azul
        
        //Mude a cor da view que irá inserir a ETB para a mesma da toolbar
        self.view.backgroundColor = Colors.Azul
        
        //Adiciona a ETB na view
        //self.navigationController?.view.addSubview(newETB)
        
        //Adiciona um seletor para o botão no indice passado
        newETB.addSelectorToButton(1,target:self, selector: Selector("holyTest"))
        
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
        eventManager.getEventsFromUser(UserDAODefault.getLoggedUser(), usuario: .All)
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
//                if placemark.ISOcountryCode == "BR" /*Address Format in Brazil*/ {
//                    if placemark.country != nil {
//                        addressString = placemark.country
//                    }
//                    if placemark.subAdministrativeArea != nil {
//                        addressString = addressString + placemark.subAdministrativeArea + ", "
//                    }
//                    if placemark.postalCode != nil {
//                        addressString = addressString + placemark.postalCode + " "
//                    }
//                    if placemark.locality != nil {
//                        addressString = addressString + placemark.locality
//                    }
//                    if placemark.thoroughfare != nil {
//                        addressString = addressString + placemark.thoroughfare
//                    }
//                    if placemark.subThoroughfare != nil {
//                        addressString = addressString + placemark.subThoroughfare
//                    }
//                } else {
//                    if placemark.subThoroughfare != nil {
//                        addressString = placemark.subThoroughfare + " "
//                    }
//                    if placemark.thoroughfare != nil {
//                        addressString = addressString + placemark.thoroughfare + ", "
//                    }
                    if placemark.locality != nil {
                        addressString = addressString + placemark.locality + ", "
                    }
//                    if placemark.administrativeArea != nil {
//                        addressString = addressString + placemark.administrativeArea + " "
//                    }
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
        
//        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
//            let placeArray = placemarks as? [CLPlacemark]
//            
//            
//            // Place details
//            var placeMark: CLPlacemark!
//            placeMark = placeArray?[0]
//            
//            // Address dictionary
//            println(placeMark.addressDictionary)
//            
//            // Location name
//            if let locationName = placeMark.addressDictionary["Name"] as? NSString {
//                println(locationName)
//            }
//            
//            // Street address
//            if let street = placeMark.addressDictionary["Thoroughfare"] as? NSString {
//                println(street)
//            }
//            
//            // City
//            if let city = placeMark.addressDictionary["City"] as? NSString {
//                println(city)
//            }
//            
//            // Zip code
//            if let zip = placeMark.addressDictionary["ZIP"] as? NSString {
//                println(zip)
//            }
//            
//            // Country
//            if let country = placeMark.addressDictionary["Country"] as? NSString {
//                println(country)
//            }
//            
//        })



        if(self.events[indexPath.row].numberOfPeople! > 1){
        
        cell.numeroPessoas.text? = String(format: "%d Pessoas", self.events[indexPath.row].numberOfPeople!)
        
        }else{
            cell.numeroPessoas.text? = String(format: "%d Pessoa", self.events[indexPath.row].numberOfPeople!)
        }
        
        if(image != nil){


            let contextImage: UIImage = UIImage(CGImage: image!.CGImage)!
            
            let contextSize: CGSize = contextImage.size
            
            var rect: CGRect = CGRectMake(image!.size.width/4, image!.size.height/4, 375, 200)
            let imageRef: CGImageRef = CGImageCreateWithImageInRect(contextImage.CGImage, rect)
            let imageFinal: UIImage = UIImage(CGImage: imageRef, scale: image!.scale, orientation: image!.imageOrientation)!

            var images = [UIImage]()
            
            if(self.events.count > indexPath.row){
                if(self.events[indexPath.row].pessoas.count > 0){
                    
                    for(var x = 0; x < self.events[indexPath.row].numberOfPeople!; x++){
                        images.append(self.events[indexPath.row].pessoas[x].image!)
                    }
                    
                    
                    
                    rect = CGRectMake(0, 0, cell.view.frame.size.width, cell.view.frame.size.height)
                    
                    //Cria uma OCView, passando a imagem de capa, as imagens dentro da scrollview e o frame da OCVIew
                    ocView = OCView(mainImage: imageFinal, insideImages: images, frame: rect)
                    
                    //Neste caso, todo o código acima é para criar imagens coloridas de teste para a OCView. Ele não é importante.
                    
                    //Adiciona a OCView
                    cell.view.addSubview(ocView)
                    
                }

            
            }
            else{
                cell.view.backgroundColor = UIColor(patternImage: self.events[indexPath.row].image!)
                
            }
            
            
            rect = CGRectMake(0, 0, cell.view.frame.size.width, cell.view.frame.size.height)
            
            ocView = OCView(mainImage: imageFinal, insideImages: images, frame: rect)
            cell.view.addSubview(ocView)
   }
        
        cell.titleEvent.textColor = Colors.Rosa
        cell.descricao.textColor = Colors.Rosa
        cell.numeroPessoas.textColor = Colors.Rosa
        cell.localHorarioEvento.textColor = Colors.Rosa
        
        return cell
    }
    
    
    func getEventsFinished(events: Array<Event>) {
        
        activity = activityIndicator(view: self.navigationController!, texto: "Carregando Eventos", inverse: false, viewController: self)
        
        
        self.events = events
        
        self.tableView.reloadData()
        self.eventManager.getImages(events)
        
        
        for event in events{
            self.userManager?.getUsersFrom(event)
        }
        
    }
    
    
    
    func downloadImageUsersFinished(users: Array<User>, event: Event) {
        event.pessoas = users
        
        for(var i = 0 ; i < self.events.count ; i++ ){
            if(self.events[i].id == event.id){
                self.events[i] = event
            }
        }
        self.tableView.reloadData()
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
        self.tableView.reloadData()
    }
    
    func downloadImageEventFinshed(event: Event) {

        //descobrir aonde esta esse evento na table view e entao recarregar
    }
}
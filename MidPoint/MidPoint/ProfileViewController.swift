//
//  ProfileViewController.swift
//  MidPoint
//
//  Created by William Alvelos on 14/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, EventManagerDelegate
{

    var ocView: OCView!

    var navItem: UINavigationItem?
    
    var travado: Bool = false
    
    var eventManager : EventManager = EventManager()
    
    var events = Array<Event>()
    
    var user:User?
    
    
    @IBOutlet var tableView: UITableView!

    @IBOutlet var gestureView: UIView!
    
    var refreshControl: UIRefreshControl?
    
    
     override func viewDidLoad() {
    
        user = UserDAODefault.getLoggedUser()
        
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

    
    func reloadData(){
        eventManager.getEventsFromUser(UserDAODefault.getLoggedUser(), usuario: .All)

    }

    
    override func viewWillAppear(animated: Bool) {
        
        animateTable()
        

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
        
        
        
        var activity: activityCell?
        
        
        activity = activityCell(view: cell.view, inverse: true)
        
        var image = self.events[indexPath.row].image
        
        cell.titleEvent.text = self.events[indexPath.row].name
        
        cell.selectionStyle = .None
    
        cell.descricao.text = self.events[indexPath.row].descricao

        if(self.events[indexPath.row].numberOfPeople! > 1){
        
        cell.numeroPessoas.text? = String(format: "%d Pessoas", self.events[indexPath.row].numberOfPeople!)
        
        }else{
            cell.numeroPessoas.text? = String(format: "%d Pessoa", self.events[indexPath.row].numberOfPeople!)
        }
        
        if(image != nil){
            activity!.removeActivityViewWithName(cell.view)

            let contextImage: UIImage = UIImage(CGImage: image!.CGImage)!
            
            let contextSize: CGSize = contextImage.size
            
            var rect: CGRect = CGRectMake(image!.size.width/4, image!.size.height/4, 375, 200)
            let imageRef: CGImageRef = CGImageCreateWithImageInRect(contextImage.CGImage, rect)
            let imageFinal: UIImage = UIImage(CGImage: imageRef, scale: image!.scale, orientation: image!.imageOrientation)!

            var images = [UIImage]()
            
            for var x = 0.3; x < 1.0; x = x + 0.2 {
                
                var newImage = getImageWithColor(UIColor(red: 0.8, green: 0.2, blue: CGFloat(x), alpha: 1.0), size: CGSizeMake(100.0,100.0))
                images.append(newImage)
                
            }
            
            
            
            rect = CGRectMake(0, 0, cell.view.frame.size.width, cell.view.frame.size.height)
            
            ocView = OCView(mainImage: imageFinal, insideImages: images, frame: rect)
            cell.view.addSubview(ocView)
            
            
        
        }
        
        
        cell.titleEvent.textColor = Colors.Rosa
        cell.descricao.textColor = Colors.Rosa
        cell.numeroPessoas.textColor = Colors.Rosa

        return cell
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
    func getEventsFinished(events: Array<Event>) {
        self.events = events
        for event in events {
            self.eventManager.getImage(event)
        }
        self.animateTable()
    }
    func downloadImageEventFinshed(event: Event) {
        //descobrir aonde esta esse evento na table view e entao recarregar
    }
}
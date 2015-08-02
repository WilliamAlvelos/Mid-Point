//
//  EventInfoViewController.swift
//  MidPoint
//
//  Created by William Alvelos on 29/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import UIKit

class EventInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UserManagerDelegate{

    var userManager: UserManager?
    
    @IBOutlet var imageEvent: UIImageView!
    
    @IBOutlet var labelEventName: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    var dataPessoas = Array<User>()
    
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.userManager = UserManager()
        self.userManager?.delegate = self
        
        self.userManager?.getUsersFrom(event!)
        
        self.tableView.reloadData()
        
        
        self.title = "Grupo"
        
//        
//        self.imageEvent.image = imagemDoEvent
//        self.labelEventName.text = nameEvent

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return 213
        
        }
        return 65
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        return 50
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0 || section == 2){
            return ""
        }

        return "Participantes \(self.dataPessoas.count) de 1000"

    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(section == 0 || section == 2){
            return 1
        }
        
        return self.dataPessoas.count
        
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if(indexPath.section == 0){
            var cell:EventoInfoCellCustom = self.tableView.dequeueReusableCellWithIdentifier("EventoInfoCellCustom") as!EventoInfoCellCustom
            
            
            cell.imageLabel.image = event?.image
            
            cell.imageLabel.layer.cornerRadius = cell.imageLabel.frame.size.height / 2.0
            
            cell.imageLabel.layer.masksToBounds = true
            
            cell.titleLabel.text = event?.name
            
            return cell
        }
        
        
        if(indexPath.section == 2){
        
            var cell:MidPointTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("MidPointTableViewCell") as!MidPointTableViewCell
            
            //if(cell.button == nil){
            
            
             cell.button.addTarget(self, action: Selector("ChangeMidPoint"), forControlEvents: UIControlEvents.TouchDown)
           
            
//            cell.imageLabel.image = event?.image
//            
//            cell.imageLabel.layer.cornerRadius = cell.imageLabel.frame.size.height / 2.0
//            
//            cell.imageLabel.layer.masksToBounds = true
//            
//            cell.titleLabel.text = event?.name
            
            return cell
        }
        
        var cell:UsersTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("UsersTableViewCell") as!UsersTableViewCell
        
        
        cell.titleLabel.text = dataPessoas[indexPath.row].name
        
        cell.imageLabel.image = dataPessoas[indexPath.row].image

        cell.imageLabel?.layer.cornerRadius = cell.imageLabel.frame.size.height / 2.0
        
        cell.imageLabel.layer.masksToBounds = true
//
//        cell.imageLabel?.layer.cornerRadius = cell.imageLabel.frame.size.height/2.0
//        
//        cell.titleLabel?.text = dataPessoas[indexPath.row].name
//        var url:NSURL = NSURL(string:"\(LinkAccessGlobalConstants.LinkImagesUsers)\(data[indexPath.row].id!).jpg")!
//        //var url:NSURL = NSURL(string: "http://alvelos.wc.lt/MidPoint/users/user_images/2.jpg")!
//        
//        println(url)
//        var dados:NSData = NSData(contentsOfURL: url)!
//        cell.imageLabel?.image = UIImage(data: dados)
//        
//        //cell.imageLabel?.layer.cornerRadius = cell.imageLabel.frame.size.height / 2.0
//        
//        
//        //        var url:NSURL = NSURL.URLWithString(string)
//        //        var data:NSData = NSData.dataWithContentsOfURL(url, options: nil, error: nil)
//        //        cell.imageLabel = UIImage.imageWithData(data)
//        
//        if(contains(self.dataSelected){ x in x.id == self.data[indexPath.row].id})
//        {
//            cell.accessoryType = .Checkmark
//        }
//        else {
//            cell.accessoryType = .None
//        }
//        cell.selectionStyle = .None
        return cell
//        
        
    }
    
    func ChangeMidPoint(){
        var nextView = TransitionManager.creatView("changeMidPoint") as! ChangeMidPointViewController
        
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    func errorThrowedServer(stringError: String) {
        
    }
    func errorThrowedSystem(error: NSError) {
        
    }
    
    
    func downloadImageUserFinished(user: User) {
        for(var i = 0; i < self.dataPessoas.count ; i++){
            if(self.dataPessoas[i].id == user.id){
                self.dataPessoas[i] = user
            }
        
        }
        
        self.tableView.reloadData()
    }

    
    

    func getUsersFinished(users: Array<User>, event: Event) {
        self.dataPessoas = users
        for user in users {
            self.userManager?.getImage(user)
        }
        
        
        self.tableView.reloadData()
    }
    

}

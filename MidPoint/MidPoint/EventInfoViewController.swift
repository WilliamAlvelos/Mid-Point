//
//  EventInfoViewController.swift
//  MidPoint
//
//  Created by William Alvelos on 29/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import UIKit

class EventInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet var imageEvent: UIImageView!
    
    @IBOutlet var labelEventName: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    var dataPessoas = Array<User>()
    
    var imagemDoEvent: UIImage?
    
    var nameEvent: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
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
        return 50
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(section == 0){
            return 50
        }
        
        return 5
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return ""
        }
        
        return "Participantes \(self.dataPessoas.count) de 1000"
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(section == 0){
            return 1
        }
        
        return self.dataPessoas.count + 1
        
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if(indexPath.section == 0){
            var cell:EventoInfoCellCustom = self.tableView.dequeueReusableCellWithIdentifier("EventoInfoCellCustom") as!EventoInfoCellCustom
            
            
            cell.imageLabel.image = imagemDoEvent
            
            cell.imageLabel.layer.cornerRadius = cell.imageLabel.frame.size.height / 2.0
            
            cell.imageLabel.layer.masksToBounds = true
            
            cell.titleLabel.text = nameEvent
            
            return cell
        }
        
        var cell:UsersTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("UsersTableViewCell") as!UsersTableViewCell
        
        
        cell.titleLabel.text = "teste"
//
//        cell.imageLabel?.layer.cornerRadius = cell.imageLabel.frame.size.height / 2.0
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

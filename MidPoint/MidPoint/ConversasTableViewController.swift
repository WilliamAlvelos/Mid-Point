//
//  ConversasTableViewController.swift
//  MidPoint
//
//  Created by William Alvelos on 16/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import UIKit

class ConversasTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, EventManagerDelegate{

    var conversasRef:Firebase = Firebase(url: "https://midpoint.firebaseio.com/")
    
    var Data = Array<Event>()
    
    var filteredTableData = [Event]()
    
    var eventDelegate = EventManager()
    
    var resultSearchController = UISearchController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eventDelegate.getEvent(UserDAODefault.getLoggedUser(), usuario: .All)
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.eventDelegate.delegate = self
        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        
        //refreshControl
        self.refreshControl = UIRefreshControl()
        //= [[UIRefreshControl alloc] init];
        self.refreshControl?.backgroundColor = UIColor.purpleColor()
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: Selector("reloadData"), forControlEvents: UIControlEvents.ValueChanged)


        
        var add:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("createConversation"))

        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = editButtonItem()
        //self.navigationItem.rightBarButtonItem = self.
        
        self.title = "Grupos"
        
    }
    
    func reloadData(){
        self.eventDelegate.getEvent(UserDAODefault.getLoggedUser(), usuario: .All)
        
        
    }
    

    
    func setupFirebase() {
        
        conversasRef.observeEventType(FEventType.ChildAdded, withBlock: { snapshot in
            var id = snapshot.value["id"] as? Int
            var title = snapshot.value["text"] as? String
            var subtitle = snapshot.value["subtitle"] as? String
            var image = snapshot.value["image"] as? String
            
            //var conversa = Event(id: id!, title: title!, subtitle:subtitle!)
            
            var event = Event(name: title!, id: id!, descricao: subtitle!)
            
            
            self.Data.append(event)
        })
        
    }
    
    
    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells()
        let tableWidth: CGFloat = tableView.bounds.size.width
        
        for i in cells {
            let cell: UITableViewCell = i as! UITableViewCell
            //          cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
            cell.transform = CGAffineTransformMakeTranslation(-tableWidth, 0)
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
    
    func addConversation(id: String!, title: String!, subtitle: String!, image: String!) {
        
        conversasRef.childByAppendingPath(id).setValue([
            "id":id,
            "title":title,
            "subtitle":subtitle,
            "image":image
            ])
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {


        if (self.resultSearchController.active) {
            return self.filteredTableData.count
        }
        else {
            return self.Data.count
        }
    }
    
    
    

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let nextView = TransitionManager.creatView("ChatViewController") as! ChatViewController
        nextView.conversa = Data[indexPath.row].id
        nextView.name = Data[indexPath.row].name
        self.navigationController?.pushViewController(nextView, animated: true)
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:CustomCellConversas = self.tableView.dequeueReusableCellWithIdentifier("CustomCellConversas") as! CustomCellConversas
        
        
        cell.selectionStyle = .None
        
        
        cell.imageLabel?.layer.cornerRadius = cell.imageLabel.frame.size.height/2.0
   
        if (self.resultSearchController.active) {
            cell.titleLabel.text = filteredTableData[indexPath.row].name
            cell.subtitleLabel.text = filteredTableData[indexPath.row].descricao
            
//            var url:NSURL = NSURL(string:"\(LinkAccessGlobalConstants.LinkImagesEvents)\(filteredTableData[indexPath.row].id).jpg")!
//            var data:NSData = NSData(contentsOfURL: url)!
//            
//            cell.imageLabel?.image = UIImage(data: data)
            
            return cell
        }
        else {

            cell.titleLabel.text = Data[indexPath.row].name
            cell.subtitleLabel.text = Data[indexPath.row].descricao
            
            //var url:NSURL = NSURL(string:"\(LinkAccessGlobalConstants.LinkImagesEvents)\(Data[indexPath.row].id).jpg")!
            //var data:NSData = NSData(contentsOfURL: url)!
            
            //cell.imageLabel?.image = UIImage(data: data)
            
            return cell
        }
        
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        
        
        return true
    }
    

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }


    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }

    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        println("here")
        let sb = searchController.searchBar
        let target = sb.text
        self.filteredTableData = self.Data.filter {
            s in
            let options = NSStringCompareOptions.CaseInsensitiveSearch
            let found = s.name!.rangeOfString(target, options: options)
            return (found != nil)
        }
        self.tableView.reloadData()
    }

    func getEventsFinished(events: Array<Event>){
        Data = events
        self.tableView.reloadData()
        //animateTable()
        self.refreshControl?.endRefreshing()
        DispatcherClass.dispatcher { () -> () in
            self.eventDelegate.getImages(events)
        }
        self.animateTable()
        
    }
    
    func errorThrowedSystem(error: NSError){
        
    }
    func downloadImageFinished(image: Array<UIImage!>){
        
        for var x  = 0 ; x < image.count ; x++ {
            let indexPath = NSIndexPath(forRow: x, inSection: 0)
            let customCell = self.tableView.cellForRowAtIndexPath(indexPath) as! CustomCellConversas
            customCell.imageLabel.image = image[x]
        }
    }

    

}

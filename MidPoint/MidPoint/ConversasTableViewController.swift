//
//  ConversasTableViewController.swift
//  MidPoint
//
//  Created by William Alvelos on 16/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import UIKit

class ConversasTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, EventoDAOCloudKitDelegate{

    var conversasRef:Firebase = Firebase(url: "https://midpoint.firebaseio.com/")
    
    var Data = Array<Event>()
    
    var filteredTableData = [Event]()
    
    var eventDelegate = EventDAOCloudKit()
    
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eventDelegate.getEvent(User(id: 2), usuario: .All)
        
        
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
        
        
//        var add:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("createConversation"))

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        //self.navigationItem.rightBarButtonItem = add
        //self.navigationItem.rightBarButtonItem = self.
        
        self.title = "Grupos"
        
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        if(!animated){
            animateTable()
        }
    }
    
//    func createConversation(){
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("CreateConversation") as! CreateConversationViewController
//        self.presentViewController(nextViewController, animated:true, completion:nil)
//    
//    }
    
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
        
        self.navigationController?.pushViewController(nextView, animated: true)
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:CustomCellConversas = self.tableView.dequeueReusableCellWithIdentifier("CustomCellConversas") as!CustomCellConversas
        
        
        cell.selectionStyle = .None
   
        if (self.resultSearchController.active) {
            cell.titleLabel.text = filteredTableData[indexPath.row].name
            cell.subtitleLabel.text = filteredTableData[indexPath.row].descricao
            
            return cell
        }
        else {
            cell.titleLabel.text = Data[indexPath.row].name
            cell.subtitleLabel.text = Data[indexPath.row].descricao
            
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

    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        filteredTableData.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text)
        let array = (Data as NSArray).filteredArrayUsingPredicate(searchPredicate)
        filteredTableData = array as! [Event]
        
        self.tableView.reloadData()
    }
    
    
    func errorThrowed(error: NSError){}
    
    func saveEventFinished(event: Event){}
    
    func eventNotFound(event : Event){}
    
    func getEventFinished(event: Event){}
    
    func getEventsFinished(events: Array<Event>){
        Data = events
        self.tableView.reloadData()
    }
    func inviteFinished(event: Event){
    
    }

    /*
    // MARK:
    
    - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

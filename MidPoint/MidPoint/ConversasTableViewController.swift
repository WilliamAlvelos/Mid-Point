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
    
    var filteredImageData = [UIImage]()
    
    var eventDelegate = EventManager()
    
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.eventDelegate.delegate = self
        
        
       self.reloadData()
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
        self.refreshControl?.backgroundColor = Colors.Azul
        self.refreshControl?.tintColor = Colors.Rosa
        self.refreshControl?.addTarget(self, action: Selector("reloadData"), forControlEvents: UIControlEvents.ValueChanged)
        
        var add:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("createConversation"))
        
        self.title = "Grupos"
        
    }
    
    func reloadData(){
        self.eventDelegate.getEventsFromUser(UserDAODefault.getLoggedUser(), usuario: .All)
        
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
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
        self.resultSearchController.active = false
        let nextView = TransitionManager.creatView("changeMidPoint") as! ChangeMidPointViewController
        nextView.event = Data[indexPath.row]
        nextView.conversa = Data[indexPath.row].id
        self.navigationController?.pushViewController(nextView, animated: true)
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:CustomCellConversas = self.tableView.dequeueReusableCellWithIdentifier("CustomCellConversas") as! CustomCellConversas
        
        
        cell.selectionStyle = .None
        
        
        cell.imageLabel.layer.cornerRadius = cell.imageLabel.frame.size.height/2.0
        
        cell.imageLabel.layer.masksToBounds = true
   
        if (self.resultSearchController.active) {
            cell.titleLabel.text = filteredTableData[indexPath.row].name
            cell.subtitleLabel.text = filteredTableData[indexPath.row].descricao
            cell.imageLabel.image = filteredTableData[indexPath.row].image
            
            return cell
        }
        else {

            cell.titleLabel.text = Data[indexPath.row].name
            cell.subtitleLabel.text = Data[indexPath.row].descricao
            cell.imageLabel.image = Data[indexPath.row].image

            return cell
        }
        
    }

    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Insert {

        }
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    
        return true
    }

    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
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
    func errorThrowedSystem(error: NSError) {
        
    }
    func errorThrowedServer(stringError: String) {
    }
    func downloadImageEventsFinshed(images: Array<Event>) {
        self.Data = images
        self.animateTable()

        
    }
    func getEventsFinished(events: Array<Event>) {
        self.eventDelegate.getImages(events)
        
    }
    
    func downloadImageEventFinshed(event: Event) {
        // descobrir aonde esta esse evento na table view, e recarregar a celula
    }

}

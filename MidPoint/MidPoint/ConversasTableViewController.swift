//
//  ConversasTableViewController.swift
//  MidPoint
//
//  Created by William Alvelos on 16/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import UIKit

class ConversasTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, EventManagerDelegate, UserManagerDelegate{

    var conversasRef:Firebase = Firebase(url: "https://midpoint.firebaseio.com/")
    
    var Data = Array<Event>()
    
    var filteredTableData = [Event]()
    
    var filteredImageData = [UIImage]()
    
    var event = Event()
    
    var userManager = UserManager()
    
    var eventDelegate = EventManager()
    
    var resultSearchController = UISearchController()
    
    var avatars = NSMutableDictionary()
    
    var pessoas = NSMutableDictionary()
    
    var activity :activityIndicator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activity = activityIndicator(view: self.navigationController!, texto: "Carregando Eventos", inverse: false, viewController: self)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.eventDelegate.delegate = self
        self.userManager.delegate = self
        
        self.navigationController!.navigationBar.translucent = true
        
       self.reloadData()
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.barTintColor = Colors.Azul
            self.tableView.tableHeaderView = controller.searchBar
            controller.searchBar.tintColor = Colors.Rosa
            return controller
        })()
        
        self.eventDelegate.getEventsFromUser(UserDAODefault.getLoggedUser(), usuario: .All)
        
        //refreshControl
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = Colors.Azul
        self.refreshControl?.tintColor = Colors.Rosa
        self.refreshControl?.addTarget(self, action: Selector("reloadData"), forControlEvents: UIControlEvents.ValueChanged)
        
        var add:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("createConversation"))
        
        self.title = "Grupos"
        
    }
    
    
    func reloadData(){
        self.refreshControl?.endRefreshing()
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
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController!.navigationBar.translucent = false
        self.activity?.removeActivityViewWithName(self)
    }
    
    
    

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.resultSearchController.active = false
        
        var nextView = TransitionManager.creatView("ChatViewController") as! ChatViewController
        nextView.conversa = self.Data[indexPath.row].id
        nextView.event = self.Data[indexPath.row]
        nextView.imageEvent = self.Data[indexPath.row].image
        nextView.avatars = self.avatars
        nextView.users = self.pessoas
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
        self.refreshControl?.endRefreshing()
        self.activity?.removeActivityViewWithName(self)
    }
    func getEventsFinished(events: Array<Event>) {
        
        self.eventDelegate.getImages(events)
        
        for event in events{
            self.userManager.getUsersFrom(event)
        }
    }
    
    func downloadImageEventFinshed(event: Event) {
        // descobrir aonde esta esse evento na table view, e recarregar a celula
    }
    
    
    func getUsersFinished(users: Array<User>, event: Event) {
        self.userManager.getImages(users, event: event)
        
        
    }
    
    func downloadImageUsersFinished(users:Array<User>, event: Event){
        
        self.avatars = NSMutableDictionary()
        self.avatars.removeAllObjects()
        
        for user in users {
            var usuario :JSQMessagesAvatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(user.image, diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
            self.avatars.setValue(usuario, forKey: "\(user.id!)")
        }
        
        self.activity?.removeActivityViewWithName(self)
        

    }

}

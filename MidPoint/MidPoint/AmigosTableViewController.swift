//
//  AmigosViewController.swift
//  MidPoint
//
//  Created by William Alvelos on 23/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import UIKit

class AmigosTableViewController: UITableViewController, UITableViewDelegate,UITableViewDataSource , FriendDAODelegate, UISearchResultsUpdating, EventoDAOCloudKitDelegate{
    
    var conversasRef:Firebase = Firebase(url: "https://midpoint.firebaseio.com/")
    
    var event:Event?
    
    var eventDelegate:EventDAOCloudKit = EventDAOCloudKit()
    
    var daoFriend: FriendDAOCloudKit = FriendDAOCloudKit()
    
    var data: Array<User> = Array()
    
    var dataSelected: Array<User> = Array()
    
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        daoFriend.delegate = self
        eventDelegate.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.clearsSelectionOnViewWillAppear = false
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        self.tableView.reloadData()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action:Selector("finish"))
        
        
        self.title = "Amigos"
    }
    
    func finish(){
        UserDAODefault.saveLogin(User(name: "william", email: "will", id: 2))
        eventDelegate.saveEvent(event!, usuario: UserDAODefault.getLoggedUser())
        
        var alert = UIAlertController(title: "Sucesso", message: "Grupo Criado Com Sucesso", preferredStyle: UIAlertControllerStyle.Alert)

        
        
        var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("navigationHome") as! UINavigationController
            self.presentViewController(nextViewController, animated:false, completion:nil)
        }
        
        alert.addAction(okAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if(!animated){
            animateTable()
        }
    }
    
    
    
    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells()
        let tableWidth: CGFloat = tableView.bounds.size.width
        
        for i in cells {
            let cell: UITableViewCell = i as! UITableViewCell
  //          cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
            cell.transform = CGAffineTransformMakeTranslation(tableWidth, 0)
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
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
        
    }
    
    //    private func busca_binaria(Array, menor, maior, valor){
    //        int media = maior+menor/2;
    //
    //        if(Array[media] >= valor)
    //            busca_binaria(array, menor, media, valor)
    //
    //        else
    //            busca_binaria(array, media, maior, valor)
    //    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView.cellForRowAtIndexPath(indexPath)?.accessoryType == .Checkmark){
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
            let tru = self.dataSelected.filter{ $0.id == self.data[indexPath.row].id }
            var index = find(self.dataSelected.map({ $0.id! }), self.data[indexPath.row].id!)
            self.dataSelected.removeAtIndex(index!)

        }else{
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
            self.dataSelected.append(self.data[indexPath.row])
            self.dataSelected.sort({ $0.id < $1.id })
            
        }
    }
    
    
    private func insertOrdened(functionToRunOnMainThread: () -> ()){
        functionToRunOnMainThread()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:CustomCellAmigosGroupo = self.tableView.dequeueReusableCellWithIdentifier("CustomCellAmigosGroupo") as!CustomCellAmigosGroupo
        
        cell.titleLabel?.text = data[indexPath.row].name
        
        cell.imageLabel = UIImageView(image: UIImage(named: "teste"))
        
        if(contains(self.dataSelected){ x in x.id == self.data[indexPath.row].id})
        {
            cell.accessoryType = .Checkmark
        }
        else {
            cell.accessoryType = .None
        }
        cell.selectionStyle = .None
        return cell
    }
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        self.daoFriend.getUsersWithName(searchController.searchBar.text)
    }
    

    func getUsersFinished(users: Array<User>){
        self.data = users
        self.tableView.reloadData()
    }
    
    func addConversation(id: String, title: String!, subtitle: String!, image: String!) {
        
        conversasRef.childByAppendingPath(id).setValue([
            "id":id,
            "title":title,
            "subtitle":subtitle,
            "image":image
            ])
    }
    
    func errorThrowed(error: NSError){}
    func saveEventFinished(event: Event){
        addConversation(String(format:"%d",event.id!), title: event.name, subtitle: event.descricao, image: "halua")
        eventDelegate.inviteFriendsToEvent(event, sender: UserDAODefault.getLoggedUser(), friends: self.dataSelected)
    }
    func eventNotFound(event : Event){}
    func getEventFinished(event: Event){}
    func inviteFinished(event: Event){
        print("funcionando e que se foda")
    }
    
    func getEventsFinished(events: Array<Event>){
        
    }

}

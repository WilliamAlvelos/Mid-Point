//
//  AmigosViewController.swift
//  MidPoint
//
//  Created by William Alvelos on 23/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import UIKit
import CloudKit
class AmigosTableViewController: UITableViewController, UITableViewDelegate,UITableViewDataSource , UISearchResultsUpdating, EventManagerDelegate, UserManagerDelegate{
    
    var conversasRef:Firebase = Firebase(url: "https://midpoint.firebaseio.com/")
    
    var event:Event?
    
    var eventDelegate:EventManager = EventManager()
    
    var daoFriend: UserManager = UserManager()
    
    var data: Array<User> = Array()
    
    var dataSelected: Array<User> = Array()
    
    var resultSearchController = UISearchController()
    
    var initialProgress:Double = 0.0
    

    @IBOutlet var progressLabel: UILabel!
    
    @IBOutlet var progressLayer: CALayer!
    
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
        
        //if(event?.image)
        
        eventDelegate.saveEvent(event!, usuario: UserDAODefault.getLoggedUser())
        
        var progressView: ProgressView = ProgressView(frame: self.view.frame)
        
        self.view = progressView
        
        self.navigationController?.navigationBarHidden = true

        
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
        
        //cell.imageLabel?.layer.cornerRadius = cell.imageLabel.frame.size.height / 2.0
        
        cell.imageLabel?.layer.cornerRadius = cell.imageLabel.frame.size.height/2.0
        
        cell.titleLabel?.text = data[indexPath.row].name
        var url:NSURL = NSURL(string:"\(LinkAccessGlobalConstants.LinkImagesUsers)\(data[indexPath.row].id!).jpg")!
        //var url:NSURL = NSURL(string: "http://alvelos.wc.lt/MidPoint/users/user_images/2.jpg")!
        
        println(url)
        var dados:NSData = NSData(contentsOfURL: url)!
        cell.imageLabel?.image = UIImage(data: dados)
        
        //cell.imageLabel?.layer.cornerRadius = cell.imageLabel.frame.size.height / 2.0

        
//        var url:NSURL = NSURL.URLWithString(string)
//        var data:NSData = NSData.dataWithContentsOfURL(url, options: nil, error: nil)
//        cell.imageLabel = UIImage.imageWithData(data)
        
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
    func errorThrowedSystem(error: NSError) {
        
    }
    func uploadImageFinished(){

        var alertController = UIAlertController(title: "Sucesso", message: "Grupo Criado com Sucesso", preferredStyle: .Alert)
        
        var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            TransitionManager(indentifier: "navigationHome", animated: false, view: self)
        }

        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    func progressUpload(float : Float){
        
        var progressView: ProgressView = ProgressView(frame: self.view.frame)
        
        self.view = progressView
        
        self.navigationController?.navigationBarHidden = true
        
        progressView.animateProgressView(float)
    }
    func getUsersFinished(users: Array<User>){
        self.data = users
        let id = UserDAODefault.getLoggedUser().id!
        for var i = 0 ; i < self.data.count ; i++ {
            if (self.data[i].id == id){
                self.data.removeAtIndex(i)
                break
            }
        }
        self.tableView.reloadData()
    }

    func saveEventFinished(event: Event){
        addConversation(String(format:"%d",event.id!), title: event.name, subtitle: event.descricao, image: "halua")
        eventDelegate.inviteFriendsToEvent(event, sender: UserDAODefault.getLoggedUser(), friends: self.dataSelected)
    }
    func errorThrowedServer(stringError: String) {
        println(stringError)
    }
    
    func addConversation(id: String, title: String!, subtitle: String!, image: String!) {
        
        conversasRef.childByAppendingPath(id).setValue([
            "id":id,
            "title":title,
            "subtitle":subtitle,
            "image":image
            ])
    }
    
  
    

}

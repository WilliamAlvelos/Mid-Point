//
//  AmigosViewController.swift
//  MidPoint
//
//  Created by William Alvelos on 23/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import UIKit
import CloudKit
class AmigosTableViewController: UITableViewController, UITableViewDelegate,UITableViewDataSource , EventManagerDelegate, UserManagerDelegate, UISearchControllerDelegate, UISearchBarDelegate{
    
    var conversasRef:Firebase = Firebase(url: "https://midpoint.firebaseio.com/")
    
    var event:Event?
    
    var eventDelegate:EventManager = EventManager()
    
    var daoFriend: UserManager = UserManager()
    
    var startLocation: Localizacao?
    
    var data: Array<User> = Array()

    
    var dataSelected: Array<User> = Array()
    
    var resultSearchController = UISearchController()
    
    var initialProgress:Double = 0.0
    var progressView: ProgressView?
    @IBOutlet var progressLabel: UILabel!
    
    @IBOutlet var progressLayer: CALayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        daoFriend.delegate = self
        eventDelegate.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.clearsSelectionOnViewWillAppear = false
        progressView = ProgressView(frame: self.view.frame)

        self.navigationController!.navigationBar.translucent = true
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.delegate = self
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        self.tableView.reloadData()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action:Selector("finish"))
        
        
        self.title = "Amigos"
        
    }
    func showProgresView(){
        progressView!.backgroundColor = Colors.Rosa
        
        self.view = progressView
        
        self.navigationController?.navigationBarHidden = true

    }
    func finish(){

        eventDelegate.saveEvent(event!, usuario: UserDAODefault.getLoggedUser(), friends: self.dataSelected, localizacaoUsuario: self.startLocation!)
        self.showProgresView()
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
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
        
    }
    
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
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {

        self.daoFriend.getUsersWithName(searchBar.text)
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:CustomCellAmigosGroupo = self.tableView.dequeueReusableCellWithIdentifier("CustomCellAmigosGroupo") as!CustomCellAmigosGroupo
        
        //cell.imageLabel?.layer.cornerRadius = cell.imageLabel.frame.size.height / 2.0
        
        cell.imageLabel?.layer.cornerRadius = cell.imageLabel.frame.size.height/2.0
        
        cell.imageLabel.layer.masksToBounds = true
        
        cell.titleLabel?.text = data[indexPath.row].name

        cell.imageLabel.image = data[indexPath.row].image

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

    override func viewWillDisappear(animated: Bool) {
        self.navigationController!.navigationBar.translucent = false
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
        self.progressView!.animateProgressView(float)
    }
    func downloadImageEventFinshed(event: Event) {
            //descobrir aonde esta esse evento na table view, e entao atualizar somente a celula
    }
    func saveEventFinished(event: Event){
        println("terminou de salvar a porra toda, fazendo upload da imagem em background o novo id é \(event.id!)")
    }
    func errorThrowedServer(stringError: String) {
        println(stringError)
    }
    func getUsersFinished(users: Array<User>) {
        self.daoFriend.getImages(users, event: self.event!)

    }
    func downloadImageUserFinished(user: User) {


        
    }
    func downloadImageUsersFinished(users: Array<User>, event: Event) {
        self.data = users
        self.animateTable()
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

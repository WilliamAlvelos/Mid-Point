//
//  AmigosViewController.swift
//  MidPoint
//
//  Created by William Alvelos on 23/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import UIKit

class AmigosTableViewController: UITableViewController, UITableViewDelegate,UITableViewDataSource , FriendDAODelegate, UISearchResultsUpdating{
    
    var daoFriend: FriendDAOCloudKit = FriendDAOCloudKit()
    
    var data: Array<User> = Array()
    
    var dataSelected: Array<User> = Array()
    
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        daoFriend.delegate = self
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
        println("finish")
    }
    
    override func viewWillAppear(animated: Bool) {
        if(!animated){
            animateTable()
        }
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
        
        //        if(tableView.cellForRowAtIndexPath(indexPath)?.selected == true ){
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
        //        }
        //        else {
        //            tableView.cellForRowAtIndexPath(indexPath)?.selected = true
        //        }
        
        if(tableView.cellForRowAtIndexPath(indexPath)?.accessoryType == .Checkmark){
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
            let tru = self.dataSelected.filter{ $0.id == self.data[indexPath.row].id }
//            self.dataSelected.
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
    
    func errorThrowed(error: NSError){
        
    }
    func getUsersFinished(users: Array<User>){
        self.data = users
        self.tableView.reloadData()
    }
}

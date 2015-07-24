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

    
    var searchActive : Bool = false
    var data: Array<User> = Array()
    
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
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:CustomCellAmigosGroupo = self.tableView.dequeueReusableCellWithIdentifier("CustomCellAmigosGroupo") as!CustomCellAmigosGroupo
        
        cell.titleLabel?.text = data[indexPath.row].name
        
        cell.imageLabel = UIImageView(image: UIImage(named: "teste"))
        
        
        return cell
    }
    

    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
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

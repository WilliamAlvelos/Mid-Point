//
//  ProfileViewController.swift
//  MidPoint
//
//  Created by William Alvelos on 14/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, EventManagerDelegate
{
    
    //ganbs para ver se esta funfando enquanto nao recebo o Usuario


    var navItem: UINavigationItem?
    
    var travado: Bool = false
    
    var eventManager : EventManager = EventManager()
    
    var events = Array<Event>()
    
    
    @IBOutlet var tableView: UITableView!

    @IBOutlet var gestureView: UIView!
    
    
     override func viewDidLoad() {
        
        self.eventManager.delegate = self
        
        navItem = self.navigationItem
        
        navItem?.title = "Você"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        eventManager.getEvent(UserDAODefault.getLoggedUser(), usuario: .All)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160.0
        
        //gestures
        var swipeUPSearch:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("UpSwipeSearch:"))
        swipeUPSearch.direction = UISwipeGestureRecognizerDirection.Up
        
        var swipeDownSearch:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("DownSwipeSearch:"))
        
        swipeDownSearch.direction = UISwipeGestureRecognizerDirection.Down
        
        var swipeUP:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("UpSwipe:"))
        swipeUP.direction = UISwipeGestureRecognizerDirection.Up
        
        var swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("DownSwipe:"))
        
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        
        self.view.addGestureRecognizer(swipeUPSearch)
        
        self.view.addGestureRecognizer(swipeDownSearch)
        
        
//        self.tabBar.addGestureRecognizer(swipeUP)
//        
//        self.tabBar.addGestureRecognizer(swipeDown)
        
    }

    
    

    
    override func viewWillAppear(animated: Bool) {
        
        animateTable()
        

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
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 375;
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
    }
    
    
    func errorThrowedServer(stringError: String) {
        
    }
    
    func errorThrowedSystem(error: NSError) {
        
    }
    
    func getEventsFinished(events: Array<Event>) {
        self.events = events

        self.tableView.reloadData()
    }
    
    func downloadImageFinished(images: Array<Event>) {
        events = images
        
        self.tableView.reloadData()
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:CustomCellProfile = self.tableView.dequeueReusableCellWithIdentifier("CustomCellProfile") as! CustomCellProfile
        
        
        cell.titleEvent.text = self.events[indexPath.row].name
        
        cell.imageEvent.image = self.events[indexPath.row].image
        
        //cell.localHorarioEvento.text = self.events[indexPath.row].date
            
        cell.descricao.text = self.events[indexPath.row].descricao
        
        
        
//        cell.titleLabel?.text = self.data![indexPath.row]
//        
//        cell.imageLabel = UIImageView(image: UIImage(named: "teste"))
//        
//        cell.subtitleLabel.text = self.data![indexPath.row]
        
        return cell
    }

    
}
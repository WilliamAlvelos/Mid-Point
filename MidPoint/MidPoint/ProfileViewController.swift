//
//  ProfileViewController.swift
//  MidPoint
//
//  Created by William Alvelos on 14/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate,UITableViewDataSource
{
    
    //ganbs para ver se esta funfando enquanto nao recebo o Usuario

    var event:Event = Event(name: "Role")
    
    var data: [Event] = [Event(name: "rolezin")]
    
    var navItem: UINavigationItem?
    
    var travado: Bool = false
    
    var searchAparecendo: Bool = true
    
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var tableView: UITableView!

    @IBOutlet var gestureView: UIView!
    
    @IBOutlet var tabBar: UITabBar!
    
     override func viewDidLoad() {
        
        
        
        data.append(event)
        data.append(event)
        data.append(event)
        
        navItem = self.navigationItem
        
        navItem?.title = "Você"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
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
        
        
        self.tabBar.addGestureRecognizer(swipeUP)
        
        self.tabBar.addGestureRecognizer(swipeDown)
        
    }

    
    

    
    override func viewWillAppear(animated: Bool) {
        searchBar.center.y -= view.bounds.height
        
        
        animateTable()
        
        UIView.animateWithDuration(0.8, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.searchBar.center.y += self.view.bounds.height
            
            self.view.layoutIfNeeded()
            
            }, completion: nil)
    }
    
    func DownSwipeSearch(gesture: UISwipeGestureRecognizer){
        if(searchAparecendo == false){
            UIView.animateWithDuration(0.8, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.searchBar.center.y += self.view.bounds.height/5
                
                }, completion: nil)
                searchAparecendo = true
        }
    }
    func UpSwipeSearch(gesture: UISwipeGestureRecognizer){
        
        if(searchAparecendo == true){
            UIView.animateWithDuration(0.8, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.searchBar.center.y -= self.view.bounds.height/5
                
                }, completion: nil)
            searchAparecendo = false
        }
    }

    func DownSwipe(gesture: UISwipeGestureRecognizer){
        if(travado == true){
            
            UIView.animateWithDuration(0.8, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.tableView.center.y += self.view.bounds.width/1.55
                self.tabBar.center.y += self.view.bounds.width/1.55
                
                //self.view.backgroundColor = UIColor(red: 0, green:0 , blue: 255, alpha: 1)
                
                self.view.layoutIfNeeded()
                }, completion: nil)
            
            travado = false
        }
    }
    func UpSwipe(gesture: UISwipeGestureRecognizer){
        
        println("cima")
        
        if(travado == false){
            
            UIView.animateWithDuration(0.8, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.tableView.center.y -= self.view.bounds.width/1.55
                self.tabBar.center.y -= self.view.bounds.width/1.55
                //self.view.backgroundColor = UIColor(red: 0, green:0 , blue: 255, alpha: 1)
                
                self.view.layoutIfNeeded()
                }, completion: nil)
            
            travado = true
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
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 300;
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:CustomCellProfile = self.tableView.dequeueReusableCellWithIdentifier("CustomCellProfile") as! CustomCellProfile
        
        
        cell.titleEvent.text = self.data[indexPath.row].name
        
//        cell.titleLabel?.text = self.data![indexPath.row]
//        
//        cell.imageLabel = UIImageView(image: UIImage(named: "teste"))
//        
//        cell.subtitleLabel.text = self.data![indexPath.row]
        
        return cell
    }

    
}
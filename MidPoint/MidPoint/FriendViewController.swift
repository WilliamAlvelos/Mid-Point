//
//  FriendViewController.swift
//  MidPoint
//
//  Created by William Alvelos on 09/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation
import UIKit

class FriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    //receber um amigo para monstrar o perfil dele
    var friend:Friend?
    
    var evento: Event?
    //Outlets
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var viewGesture: UIView!
    @IBOutlet var buttonImage: UIButton!
    @IBOutlet var nameFriend: UILabel!
    @IBOutlet var localFriend: UILabel!
    
    @IBOutlet var barraFriend: UIToolbar!
    
    
    //ganbs para ver se esta funfando enquanto nao recebo o amigo
    var favoritos: [String] = ["pizza", "balada", "shopping","pizza", "balada", "shopping","pizza", "balada", "shopping","pizza", "balada", "shopping","pizza", "balada", "shopping","pizza", "balada", "shopping","pizza", "balada", "shopping","pizza", "balada", "shopping"]
    var avaliacoes: [String] = ["ruin", "lixo", "pior" ,"ruin", "lixo", "pior","ruin", "lixo", "pior","ruin", "lixo", "pior","ruin", "lixo", "pior","ruin", "lixo", "pior","ruin", "lixo", "pior","ruin", "lixo", "pior"]
    
    var data: [String]?
    
    var travado: Bool?
    
    var navItem:UINavigationItem?
    
    
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        data = favoritos
        travado = false

        
        
        // Create a reference to a Firebase location
        var myRootRef = Firebase(url:"https://<YOUR-FIREBASE-APP>.firebaseio.com")
        // Write data to Firebase
        myRootRef.setValue("Do you have data? You'll love Firebase.")
        
        

        navItem = self.navigationItem
        
        nameFriend.text = friend?.name
        //localFriend.text = friend?.location as? String
        
        buttonImage.layer.cornerRadius = buttonImage.bounds.size.width/2
        buttonImage.layer.borderWidth = 0
        buttonImage.layer.masksToBounds = true
        
        
        var swipeUP:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("UpSwipe:"))
        swipeUP.direction = UISwipeGestureRecognizerDirection.Up
        
        var swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("DownSwipe:"))
        
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        
        self.viewGesture.addGestureRecognizer(swipeUP)
        
        self.viewGesture.addGestureRecognizer(swipeDown)
        
        
        self.view.addGestureRecognizer(swipeUP)
        
        self.view.addGestureRecognizer(swipeDown)
        
        
    }
    
    
    func UpSwipe(gesture: UISwipeGestureRecognizer){
        
        if(travado == false){
            
            navItem!.title = "amigo"
            
            UIView.animateWithDuration(0.8, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.tableView.center.y -= self.view.bounds.width/1.55
                self.viewGesture.center.y -= self.view.bounds.width/1.55
//                self.buttonImage.center.x -= self.view.bounds.height/5
//                self.buttonImage.center.y -= self.view.bounds.width/8
                
                self.view.backgroundColor = UIColor(red: 0, green:0 , blue: 255, alpha: 1)
                
                self.view.layoutIfNeeded()
                }, completion: nil)
            
            travado = true
        }
        
    }
    
    func DownSwipe(gesture: UISwipeGestureRecognizer){
        if(travado == true){
            
            navItem!.title = " "
            
            UIView.animateWithDuration(0.8, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.tableView.center.y += self.view.bounds.width/1.55
                self.viewGesture.center.y += self.view.bounds.width/1.55
//                self.buttonImage.center.x += self.view.bounds.height/5
//                self.buttonImage.center.y += self.view.bounds.width/8
                self.view.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
                self.view.layoutIfNeeded()
                }, completion: nil)
        
            travado = false
        }
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
        
        return 150;
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data!.count
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:CustomCellFriend = self.tableView.dequeueReusableCellWithIdentifier("CustomCellFriend") as! CustomCellFriend
        
        cell.titleLabel?.text = self.data![indexPath.row]
        
        cell.imageLabel = UIImageView(image: UIImage(named: "teste"))

        cell.subtitleLabel.text = self.data![indexPath.row]
        
        return cell
    }
    
    
    @IBAction func TwitterFriend(sender: AnyObject) {
        var twitterURLWeb: NSURL?
        var twitterURL: NSURL?
        
        if(friend?.userNameTwitter != nil){
            twitterURL = NSURL(string: "twitter://user?screnn_name+" + friend!.userNameTwitter!)!
            twitterURLWeb = NSURL(string: "https://twitter.com/" + friend!.userIdFacebook!)!
            
        }else{
            //error twitter
        }
        
        if(twitterURL != nil || twitterURLWeb != nil){
        
            if(UIApplication.sharedApplication().canOpenURL(twitterURL!)){
                //twitter installed
                UIApplication.sharedApplication().openURL(twitterURL!)
            }else{
                UIApplication.sharedApplication().openURL(twitterURLWeb!)
            }

        }
        
    }
    @IBAction func favoritos(sender: AnyObject) {
        data = favoritos
        animateTable()
        
    }
    @IBAction func avaliacao(sender: AnyObject) {
        data = avaliacoes
        animateTable()
    }
    
    @IBAction func FacebookFriend(sender: AnyObject) {
        var fbURLWeb: NSURL? = NSURL(string: "https://www.facebook.com/RiotGames")!
        var fbURLid: NSURL? = NSURL(string: "fb://profile/001023123123")!
        
        
        
        if(friend?.userNameFacebook != nil){
            fbURLWeb = NSURL(string: "https://www.facebook.com/" + friend!.userNameFacebook!)!
        }
        if(friend?.userIdFacebook != nil){
            fbURLid = NSURL(string: "fb://profile/" + friend!.userIdFacebook!)!
        }else{
            //error FACEBOOK
        
        }
        
        
        if(fbURLid != nil && fbURLWeb != nil){
        
            if(UIApplication.sharedApplication().canOpenURL(fbURLid!)){
                //Facebook installed
                UIApplication.sharedApplication().openURL(fbURLid!)
            }else{
                UIApplication.sharedApplication().openURL(fbURLWeb!)
            }
        }
    
    }
    

    

}
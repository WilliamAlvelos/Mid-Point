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
    //Outlets
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var buttonImage: UIButton!
    @IBOutlet var nameFriend: UILabel!
    @IBOutlet var localFriend: UILabel!
    
    //ganbs para ver se esta funfando enquanto nao recebo o amigo
    var favoritos: [String] = ["pizza", "balada", "shopping"]
    var avaliacoes: [String] = ["ruin", "lixo", "pior"]
    
    var data: [String]?
    
    
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        data = favoritos
        
        
        nameFriend.text = friend?.name
        localFriend.text = friend?.location as? String
        
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
        
        return 50;
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data!.count
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel?.text = self.data![indexPath.row]
        
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
        tableView.reloadData()
        
    }
    @IBAction func avaliacao(sender: AnyObject) {
        data = avaliacoes
        tableView.reloadData()
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
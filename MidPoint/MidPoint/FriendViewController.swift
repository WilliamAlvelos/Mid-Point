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
    var favoritos: [String] = ["puteiro", "balada", "biqueira"]
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
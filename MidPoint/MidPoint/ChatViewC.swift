//
//  ChatViewController.swift
//  MidPoint
//
//  Created by William Alvelos on 13/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation
import UIKit

class ChatViewC: UIViewController{

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var text: UITextField!
    
    // Create a reference to a Firebase location
    var myRootRef = Firebase(url:"https://midpoint.firebaseio.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        myRootRef.observeEventType(.Value, withBlock: {
            snapshot in
            println("\(snapshot.key) -> \(snapshot.value)")
        })
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    @IBAction func send(sender: AnyObject) {

        // Write data to Firebase
        myRootRef.setValue("William")
    }
    
}

//
//  ProfileViewController.swift
//  MidPoint
//
//  Created by William Alvelos on 14/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController//, UITableViewDelegate, //UITableViewDataSource 
{
    
     var tableView: UITableView!
    
    //ganbs para ver se esta funfando enquanto nao recebo o Usuario
    var favoritos: [String] = ["pizza", "balada", "shopping","pizza", "balada", "shopping","pizza", "balada", "shopping","pizza", "balada", "shopping","pizza", "balada", "shopping","pizza", "balada", "shopping","pizza", "balada", "shopping","pizza", "balada", "shopping"]
    var avaliacoes: [String] = ["ruin", "lixo", "pior" ,"ruin", "lixo", "pior","ruin", "lixo", "pior","ruin", "lixo", "pior","ruin", "lixo", "pior","ruin", "lixo", "pior","ruin", "lixo", "pior","ruin", "lixo", "pior"]
    
    var data: [String]?
    
    var navItem: UINavigationItem?
    
    var travado: Bool?

    @IBOutlet var gestureView: UIView!
    
    
     override func viewDidLoad() {
        
        navItem = self.navigationItem
        
        navItem?.title = "Você"
        
//        tableView.delegate = self
//        tableView.dataSource = self
        
        
    }
    
}
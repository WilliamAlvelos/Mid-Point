////
////  ConversasTableViewController.swift
////  MidPoint
////
////  Created by William Alvelos on 15/07/15.
////  Copyright (c) 2015 FDJ. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//
//
//
//class ConversasTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate{
//    
//    
//    //var data:[Conversas]?
//    
//    
//    func animateTable() {
//        tableView.reloadData()
//        
//        let cells = tableView.visibleCells()
//        let tableHeight: CGFloat = tableView.bounds.size.height
//        
//        for i in cells {
//            let cell: UITableViewCell = i as! UITableViewCell
//            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
//        }
//        
//        var index = 0
//        
//        for a in cells {
//            let cell: UITableViewCell = a as! UITableViewCell
//            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: nil, animations: {
//                cell.transform = CGAffineTransformMakeTranslation(0, 0);
//                }, completion: nil)
//            
//            index += 1
//        }
//    }
//    
//    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        
//        return 150;
//        
//    }
//    
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data!.count
//    }
//    
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        println("You selected cell #\(indexPath.row)!")
//    }
//    
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var cell:CustomCellFriend = self.tableView.dequeueReusableCellWithIdentifier("CustomCellFriend") as! CustomCellFriend
//        
//        cell.titleLabel?.text = self.data![indexPath.row]
//        
//        cell.imageLabel = UIImageView(image: UIImage(named: "teste"))
//        
//        cell.subtitleLabel.text = self.data![indexPath.row]
//        
//        return cell
//    }
//    
//
//    
//
//}

//
//  TransitionManager.swift
//  MidPoint
//
//  Created by William Alvelos on 07/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation
import UIKit

class TransitionManager: NSObject {

    func changeView(indentifier: String, animated: Bool, view: UIViewController){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier(indentifier) as! UIViewController
        view.presentViewController(nextViewController, animated:animated, completion:nil)
    }
    
    init(indentifier: String, animated: Bool, view: UIViewController){
        view.presentViewController(TransitionManager.creatView(indentifier), animated:animated, completion:nil)
    }
    
    
    class func creatView(identifier:String)->UIViewController{
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier(identifier) as! UIViewController
        return nextViewController
    }
    
    
}
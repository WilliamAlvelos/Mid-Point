//
//  activityCell.swift
//  MidPoint
//
//  Created by William Alvelos on 31/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation

class activityCell {
    
    
    var boxView = UIView()
    
    
    init(view:UIView, inverse: Bool) {
        
        
        view.alpha = 0.5
        
        var activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.color = Colors.Rosa
        activityView.startAnimating()
        
        
        
        boxView = UIView(frame: CGRect(x: view.frame.midX-25, y: view.frame.midY-50, width: 50, height: 50))
        boxView.backgroundColor = Colors.Azul
        boxView.alpha = 0.8
        boxView.layer.cornerRadius = 10
        
        boxView.addSubview(activityView)
        
        
        if(inverse){
            activityView.color = Colors.Azul
            boxView.backgroundColor = Colors.Rosa
        }
        
        
        view.addSubview(boxView)
    }
    
    func removeActivityViewWithName(view: UIView){
        view.alpha = 1
        boxView.removeFromSuperview()
    }
    
    
    

}
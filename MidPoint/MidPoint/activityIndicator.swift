//
//  activityIndicator.swift
//  MidPoint
//
//  Created by William Alvelos on 30/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation

class activityIndicator {
    
    
    static var boxView = UIView()
    
    
    class func activityViewWithName(view:UIViewController, texto: String) {
        boxView = UIView(frame: CGRect(x: view.view.frame.midX - 90, y: view.view.frame.midY - 25, width: 180, height: 50))
        boxView.backgroundColor = Colors.Azul
        boxView.alpha = 0.8
        boxView.layer.cornerRadius = 10
        
        var activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.color = Colors.Rosa
        activityView.startAnimating()
        
        var textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        textLabel.textColor = Colors.Rosa
        textLabel.text = texto
        
        boxView.addSubview(activityView)
        boxView.addSubview(textLabel)
        
        view.view.addSubview(boxView)
    }
    
    
    class func removeActivityViewWithName(){
        boxView.removeFromSuperview()
    }
    
    
    
}

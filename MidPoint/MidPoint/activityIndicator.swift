//
//  activityIndicator.swift
//  MidPoint
//
//  Created by William Alvelos on 30/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation

class activityIndicator {
    
    
    var boxView = UIView()
    
    
    init(view:UINavigationController, texto: String, inverse: Bool) {

        
        var activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.color = Colors.Rosa
        activityView.startAnimating()
        
        var textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        textLabel.textColor = Colors.Rosa
        textLabel.text = texto
        
        

        
        boxView = UIView(frame: CGRect(x: view.view.frame.midX - (textLabel.frame.width/2 + 25), y: view.view.frame.midY - 30, width: 60 + textLabel.frame.width, height: 50))
        boxView.backgroundColor = Colors.Azul
        boxView.alpha = 0.8
        boxView.layer.cornerRadius = 10
        
        boxView.addSubview(activityView)
        boxView.addSubview(textLabel)
        
        
        if(inverse){
            textLabel.textColor = Colors.Azul
            activityView.color = Colors.Azul
            boxView.backgroundColor = Colors.Rosa
        }
        
        
        view.view.addSubview(boxView)
    }
    
    func removeActivityViewWithName(){
        boxView.removeFromSuperview()
    }
    
    
    
}

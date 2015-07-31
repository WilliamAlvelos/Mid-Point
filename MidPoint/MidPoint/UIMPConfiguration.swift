//
//  UIMPConfiguration.swift
//  MidPoint
//
//  Created by Joao Sisanoski on 7/30/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation


class UIMPConfiguration {
    class func configureTextField(textField: UITextField, text: String){
        textField.attributedPlaceholder = NSAttributedString(string:text,
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
       

    }
    class func addBottomLineToView(view: UIView, bottomSize: CGFloat){
        let calayer = CALayer()
        calayer.frame = CGRectMake(0, view.frame.size.height-bottomSize, view.frame.size.width, bottomSize)
        calayer.backgroundColor = UIColor.whiteColor().CGColor
        view.layer.addSublayer(calayer)
    }
    class func addBorderToView(view : UIView, color : UIColor, width: Float, corner : Float){
        
                view.layer.borderWidth = CGFloat(width)
        view.layer.borderColor = color.CGColor
        view.layer.cornerRadius = CGFloat(corner)
    }
    class func addColorAndFontToButton(button:UIButton, color : UIColor, fontName: String, fontSize : CGFloat){
        button.tintColor = color
        button.titleLabel?.font = UIFont(name: fontName, size: fontSize)
    }
    class func configureNavigationBar(navigation:UINavigationBar, color : UIColor){
        navigation.barTintColor = color
        navigation.translucent = false
        navigation.tintColor = color
    }
     class func addColorAndFontToLabel(label:UILabel, color : UIColor, fontName: String, fontSize : CGFloat){
        label.textColor = color
        label.font = UIFont(name: fontName, size: fontSize)
    }
}
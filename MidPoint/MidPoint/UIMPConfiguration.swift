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
        UIMPConfiguration.addBottomLineToView(textField, bottomSize: 0.5)
        textField.textColor = Colors.Rosa

    }
    class func configureTextField(textField: UITextField, text: String, color: UIColor){
        textField.attributedPlaceholder = NSAttributedString(string:text,
            attributes:[NSForegroundColorAttributeName: color])
        UIMPConfiguration.addBottomLineToView(textField, bottomSize: 0.5, color: color)
        textField.textColor = color
        
    }
    class func addBorderAndMakeRounded(view: UIView, color: UIColor, width: Float){
        UIMPConfiguration.addBorderToView(view, color: color, width: width, corner: Float(view.bounds.size.width/2))
    }
    class func addBottomLineToView(view: UIView, bottomSize: CGFloat){
        let calayer = CALayer()
        calayer.frame = CGRectMake(0, view.frame.size.height-bottomSize, view.frame.size.width, bottomSize)
        calayer.backgroundColor = UIColor.whiteColor().CGColor
        view.layer.addSublayer(calayer)

    }
    class func addBottomLineToView(view: UIView, bottomSize: CGFloat, color: UIColor){
        let calayer = CALayer()
        calayer.frame = CGRectMake(0, view.frame.size.height-bottomSize, view.frame.size.width, bottomSize)
        calayer.backgroundColor = color.CGColor
        view.layer.addSublayer(calayer)
        
    }
    class func addBorderToView(view : UIView, color : UIColor, width: Float, corner : Float){
        view.layer.masksToBounds = true
        view.layer.borderWidth = CGFloat(width)
        view.layer.borderColor = color.CGColor
        view.layer.cornerRadius = CGFloat(corner)
    }
    class func addColorAndFontToButton(button:UIButton, color : UIColor, fontName: String, fontSize : CGFloat){
        button.tintColor = color
        button.titleLabel?.font = UIFont(name: fontName, size: fontSize)
    }
    class func configureNavigationBar(navigation:UINavigationBar, backgroundColor : UIColor, tintColor : UIColor, fontColor : UIColor){
        navigation.barTintColor = backgroundColor
        navigation.tintColor = fontColor
        var attributes = [
            NSForegroundColorAttributeName: fontColor,
        ]
        navigation.titleTextAttributes = attributes
    }
     class func addColorAndFontToLabel(label:UILabel, color : UIColor, fontName: String, fontSize : CGFloat){
        label.textColor = color
        label.font = UIFont(name: fontName, size: fontSize)
    }
    class func viewRounded(view : UIView){
        view.layer.cornerRadius = view.bounds.size.width/2
        view.layer.borderWidth = 0
        view.layer.masksToBounds = true
    }
    
}
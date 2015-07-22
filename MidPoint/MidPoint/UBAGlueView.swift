//
//  UBAGlueView.swift
//  MidPoint
//
//  Created by Danilo Mative on 17/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import UIKit

class UBAGlueView: UIImageView {



    var buttonSpacement: CGFloat!
    var standardHeight: CGFloat!
    
    var angle: Double!
    
    convenience init(glueImageView:UIImageView!) {
        self.init()
        
        angle = 0.0
        standardHeight = glueImageView.frame.size.height
        
        frame = glueImageView.frame
        image = glueImageView.image
        
        backgroundColor = UIColor.clearColor()
    }
    
    
    
    func attachToButtons(button1:UBAButton,button2:UBAButton) {
        
        
        //Determine the view rotation
        var newAngle: Double
        
        var diffX = button2.frame.origin.x - button1.frame.origin.x
        var diffY = button2.frame.origin.y - button1.frame.origin.y
        
        if diffX == 0.0 {
            newAngle = M_PI
        }
            
        else if diffY == 0.0 {
            newAngle = M_PI / 2.0
        }
            
        else {
            newAngle = (M_PI / 2.0) + atan(Double(diffY / diffX))
        }
        
        var transform: CGAffineTransform?
        
        //Rotates, if the angle has changed
        if newAngle != angle {
            
            angle = newAngle
            
            transform = CGAffineTransformMakeRotation(CGFloat(angle))
        }
        
        //Calculates the new view center
        var moveAngle = angle + (3.0 * M_PI / 2.0)
        
        if button1.movementType == UBMovement.RightVerticalMovement {
            moveAngle = moveAngle + M_PI
        }
        
        var distance = sqrt((diffX * diffX) + (diffY * diffY))

        var centerX = cos(moveAngle) * Double(distance / 2.0)
        
        var centerY = sin(moveAngle) * Double(distance / 2.0)
        
        center.x = button2.center.x - CGFloat(centerX)
        center.y = button2.center.y - CGFloat(centerY)
        
        
        //Calculates the new height of the view
        var centerXDiff = button2.center.x - button1.center.x
        var centerYDiff = button2.center.y - button1.center.y
        
        var centerDistance = sqrt((centerXDiff * centerXDiff)+(centerYDiff * centerYDiff))
        
        var factor = centerDistance / buttonSpacement
        factor = (standardHeight * factor) / self.frame.size.height
        
        //transform =
        if transform != nil {
        self.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.0, factor), transform!)
        }
        
        else {
            self.transform = CGAffineTransformMakeScale(1.0, factor)
        }
        
        
        //self.frame.size.height = standardHeight * factor
        
    }
    
}

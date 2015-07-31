//
//  UBAButton.swift
//  MidPoint
//
//  Created by Danilo Mative on 10/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import UIKit


enum UBMovement {
    case LeftVerticalMovement
    case RightVerticalMovement
    case HorizontalMovement
    case LeftRadianMovement
    case RightRadianMovement
}

protocol UBAButtonTouch {
    
    func buttonWasTouched(index:Int!)
    func touchStopped(index:Int!)
    
}

class UBAButton: UIButton {
    
    //MARK: parameters from UBA
    
    var buttonSelector:Selector!
    var buttonTarget:AnyObject!
    
    var buttonClicked:Bool!
    
    //radius of the U shape
    var uRadius: CGFloat!
    
    //Positions of limit from U shape
    var yVerticalLimit: CGFloat!
    var xLeftLimit: CGFloat!
    var xRightLimit: CGFloat!
    
    //index of the button in the array of superview (UBAView)
    var buttonIndex: Int!
    
    //MARK: values of positioning
    
    //number of movements being executed
    var movementsExecuting: Int!
    
    //current movement type
    var movementType: UBMovement!
    
    //position on the circle, when it is in the radian part of the U shape
    var positionOnCircle: CGFloat!
    
    //delegate of the touches evetnts
    var delegate = UBAButtonTouch?()
    
    //MARK: init
    convenience init(buttonIndex: Int!) {
        self.init()
        movementsExecuting = 0
        self.buttonIndex = buttonIndex
        movementType = UBMovement.LeftVerticalMovement
        positionOnCircle = 0.0
        buttonClicked = false
    }
    
    //MARK: touches functions
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        buttonClicked = true
        
        delegate?.buttonWasTouched(buttonIndex)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        //That means that the button was clicked
        if buttonClicked == true {
            
            if buttonSelector != nil {
                var timer = NSTimer.scheduledTimerWithTimeInterval(0.0, target: buttonTarget, selector: buttonSelector!, userInfo: nil, repeats: false)
                
                let mainLoop = NSRunLoop.mainRunLoop()
                mainLoop.addTimer(timer, forMode: NSDefaultRunLoopMode)
            }
            
        }
        
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        //delegate?.touchStopped(buttonIndex)
    }
    
    //MARK: button functions
    
    func distanceToButton(button:UBAButton)->CGFloat {
        
        var distance: CGFloat = 0.0
        
        if movementType == button.movementType {
            
            distance = distanceToButtonInBlock(button)
        }
            
        else {
            
            //not
            var inFront = buttonInFront(button)
            var currentType: UBMovement!
            
            if inFront == true {
                currentType = buttonTypeByInteger(integerFromButtonType(movementType) + 1)
            }
            
            else {
                currentType = buttonTypeByInteger(integerFromButtonType(movementType) - 1)
            }
        
            distance = distance + movementBlockDistance(inFront, type: nil)
            
            while true {
                
                if currentType == button.movementType {
                    
                    distance = distance - button.movementBlockDistance(!inFront, type: nil)

                    break
                }
                
                distance = distance + movementBlockDistance(inFront, type: currentType)
                
                if inFront == true {
                    currentType = buttonTypeByInteger(integerFromButtonType(currentType) + 1)
                }
                    
                else {
                    currentType = buttonTypeByInteger(integerFromButtonType(currentType) - 1)
                }
            }
        }
        
        return distance
        
    }
    
    func moveButtonBy(distance: CGFloat, decelerationRate: Double!) {
        
        buttonClicked = false
        
        movementsExecuting = movementsExecuting + 1
        
        var moveDistance = distance
        
        if movementType == UBMovement.LeftVerticalMovement {
            
            let newY = self.frame.origin.y + (moveDistance / CGFloat(decelerationRate))
            
            //Don't let the button leave the minimum y decided by the U Animation
            if newY < 0.0 {
                self.frame.origin.y = 0.0
            }
                
            else if newY > yVerticalLimit {
                
                movementType = UBMovement.LeftRadianMovement
                
                moveDistance = moveDistance - (yVerticalLimit - self.frame.origin.y)
                self.frame.origin.y = yVerticalLimit
                
            }
                
            else {
                self.frame.origin.y = newY
            }
            
        }
        
        if movementType == UBMovement.LeftRadianMovement {
            
            positionOnCircle = positionOnCircle + moveDistance
            
            var angle = ((positionOnCircle / circlePerimeter()) * CGFloat(M_PI / 2)) + CGFloat(M_PI)
            
            if positionOnCircle < 0.0 {
                
                self.frame.origin.x = xLeftLimit - uRadius
                self.frame.origin.y = yVerticalLimit
                
                movementType = UBMovement.LeftVerticalMovement
                
                let aux = positionOnCircle
                positionOnCircle = 0.0
                
                moveButtonBy(aux, decelerationRate: decelerationRate)
                
                movementsExecuting = movementsExecuting - 1
                
                return
            }
                
                
            else if positionOnCircle > circlePerimeter() {
                
                movementType = UBMovement.HorizontalMovement
                
                self.frame.origin.x = xLeftLimit
                self.frame.origin.y = yVerticalLimit + uRadius
                
                moveDistance = positionOnCircle - circlePerimeter()
                positionOnCircle = 0.0
            }
                
            else {
                
                self.frame.origin.x = xLeftLimit + uRadius * cos(angle)
                self.frame.origin.y = yVerticalLimit - uRadius * sin(angle)
                
            }
            
        }
        
        if movementType == UBMovement.HorizontalMovement {
            
            let newX = self.frame.origin.x + (moveDistance / CGFloat(decelerationRate))
            
            if newX < xLeftLimit {
                
                movementType = UBMovement.LeftRadianMovement
                moveDistance = moveDistance + (self.frame.origin.x - xLeftLimit)
                
                self.frame.origin.x = xLeftLimit
                
                positionOnCircle = circlePerimeter()
                
                moveButtonBy(moveDistance, decelerationRate: decelerationRate)
                
                movementsExecuting = movementsExecuting - 1
                
                return
            }
                
            else if newX > xRightLimit {
                
                movementType = UBMovement.RightRadianMovement
                moveDistance = moveDistance - (xRightLimit - self.frame.origin.x)
                
                self.frame.origin.x = xRightLimit - self.frame.size.width
            }
                
                //Set the new X
            else {
                self.frame.origin.x = newX
            }
            
        }
        
        
        if movementType == UBMovement.RightRadianMovement {
            
            positionOnCircle = positionOnCircle + moveDistance
            
            var angle = ((positionOnCircle / circlePerimeter()) * CGFloat(M_PI / 2)) + CGFloat((3.0 * M_PI) / 2.0)
            
            if positionOnCircle < 0.0 {
                
                self.frame.origin.x = xRightLimit
                self.frame.origin.y = yVerticalLimit + uRadius
                
                movementType = UBMovement.HorizontalMovement
                
                let aux = positionOnCircle
                positionOnCircle = 0.0
                
                moveButtonBy(aux, decelerationRate: decelerationRate)
                
                movementsExecuting = movementsExecuting - 1
                
                return
            }
                
                
            else if positionOnCircle > circlePerimeter() {
                
                movementType = UBMovement.RightVerticalMovement
                
                self.frame.origin.x = xRightLimit + uRadius
                self.frame.origin.y = yVerticalLimit
                
                moveDistance = positionOnCircle - circlePerimeter()
                positionOnCircle = 0.0
            }
                
            else {
                
                self.frame.origin.x = xRightLimit + uRadius * cos(angle)
                self.frame.origin.y = yVerticalLimit - uRadius * sin(angle)
                
            }
            
        }
        
        if movementType == UBMovement.RightVerticalMovement {
            
            let newY = self.frame.origin.y - (moveDistance / CGFloat(decelerationRate))
            
            //Don't let the button leave the minimum y decided by the U Animation
            if newY < 0.0 {
                self.frame.origin.y = 0.0
            }
                
            else if newY > yVerticalLimit {
                
                movementType = UBMovement.RightRadianMovement
                
                moveDistance = moveDistance - (yVerticalLimit - self.frame.origin.y)
                self.frame.origin.y = yVerticalLimit
                
                positionOnCircle = circlePerimeter()
                
                moveButtonBy(moveDistance, decelerationRate: decelerationRate)
                
                movementsExecuting = movementsExecuting - 1
                
                return
            }
                
            else {
                self.frame.origin.y = newY
            }
            
        }
        
        movementsExecuting = movementsExecuting - 1
        
    }
    
    func movementBlockDistance(forward:Bool!, type:UBMovement?)->CGFloat {
        
        
        if type != nil {
            
            if type == UBMovement.LeftVerticalMovement || type == UBMovement.RightVerticalMovement {
                if forward == true {
                    return yVerticalLimit
                }
                
                return -yVerticalLimit
            }
            
            if type == UBMovement.LeftRadianMovement || type == UBMovement.RightRadianMovement {
                if forward == true {
                    return circlePerimeter()
                }
                
                return -circlePerimeter()
            }
            
            if type == UBMovement.HorizontalMovement {
                if forward == true {
                    return xRightLimit - xLeftLimit
                }
                
                return -(xRightLimit - xLeftLimit)
            }
        }
            
        else {
            
            if movementType == UBMovement.LeftVerticalMovement {
                
                if forward == true {
                    return yVerticalLimit - frame.origin.y
                }
                
                return -frame.origin.y
            }
            
            if movementType == UBMovement.LeftRadianMovement || movementType == UBMovement.RightRadianMovement {
                
                if forward == true {
                    return circlePerimeter() - positionOnCircle
                }
                
                return -positionOnCircle
            }
            
            if movementType == UBMovement.HorizontalMovement {
                
                if forward == true {
                    return xRightLimit - frame.origin.x
                }
                
                return -(frame.origin.x - xLeftLimit)
            }
            
            if movementType == UBMovement.RightVerticalMovement {
                
                if forward == true {
                    return frame.origin.y
                }
                
                return -(yVerticalLimit - frame.origin.y)
            }
            
        }
        
        return 0.0
        
    }
    
    //MARK: auxiliar private functions
    
    private func circlePerimeter() ->CGFloat {
        return (2.0 * CGFloat(M_PI) * uRadius) / 4.0
    }
    
    
    private func buttonTypeByInteger(integer:Int)->UBMovement? {
        if integer == 1 {
            return UBMovement.LeftVerticalMovement
        }
        if integer == 2 {
            return UBMovement.LeftRadianMovement
        }
        if integer == 3 {
            return UBMovement.HorizontalMovement
        }
        if integer == 4 {
            return UBMovement.RightRadianMovement
        }
        if integer == 5 {
            return UBMovement.RightVerticalMovement
        }
        
        //That's bad
        return nil
    }
    
    private func integerFromButtonType(type:UBMovement)->Int {
        
        if type == UBMovement.LeftVerticalMovement {
            return 1
        }
        if type == UBMovement.LeftRadianMovement {
            return 2
        }
        if type == UBMovement.HorizontalMovement {
            return 3
        }
        if type == UBMovement.RightRadianMovement {
            return 4
        }
        if type == UBMovement.RightVerticalMovement {
            return 5
        }
        
        //That's bad
        return 0
    }
    
    private func distanceToButtonInBlock(button:UBAButton)->CGFloat {
        
        var distance: CGFloat = 0.0
        
        if movementType != button.movementType {
            NSLog("This function can't be called if the two buttons doesn't have the same types.")
            
            return distance
        }
        
        if movementType == UBMovement.LeftVerticalMovement {
            distance = button.frame.origin.y - frame.origin.y
        }
        
        if movementType == UBMovement.LeftRadianMovement || movementType == UBMovement.RightRadianMovement {
            distance = button.positionOnCircle - positionOnCircle
        }
        
        if movementType == UBMovement.HorizontalMovement {
            distance = button.frame.origin.x - frame.origin.x
        }
        
        if movementType == UBMovement.RightVerticalMovement {
            distance = button.frame.origin.y - frame.origin.y
            distance = -distance
        }
        
        return distance
        
    }
    
    
    private func buttonInFront(button:UBAButton)->Bool {
        
        var selfButton = integerFromButtonType(movementType)
        var otherButton = integerFromButtonType(button.movementType)
        
        if selfButton > otherButton {
            return false
        }
        
        else if otherButton > selfButton {
            return true
        }
        
        else {
            
            var distance = distanceToButtonInBlock(button)
            
            if distance > 0.0 {
                return true
            }
            
            else {
                return false
            }
            
        }
    }

}

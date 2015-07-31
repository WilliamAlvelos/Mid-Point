//
//  UBAView.swift
//  MidPoint
//
//  Created by Danilo Mative on 10/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//
//
//-----------------------------//
//
//  U Buttons Animation View
//
//-----------------------------//
//
//  Points of the U Animation
//
//
//
//  [A]               [F]
//   |                 |
//   |                 |
//   |                 |
//   |                 |
//  (1)               (5)
//   |                 |
//   |                 |
//   |                 |
//  [B]               [E]
//   |                 |
//  (2)-[C]--(3)--[D]-(4)
//
//
//
//  1 - Vertical Movement
//  2 - Radian Movement
//  3 - Horizontal Movement
//
//  The U trajectory is treated like a linear trajectory, but when reached certain points,
//  their movements change to match the U's shape
//
//
//---------------------------//
//

import UIKit
import CoreGraphics

enum JunctionAvailable {
    case NotAvailable
    case SoonAvailable
    case IsAvailable
}

class UBAView: UIView, UIGestureRecognizerDelegate, UBAButtonTouch {
    
    //** SETTINGS **:
    
    // -> Factor of minimum Glue width, based on the circle diameter
    let minimumGlueWidthFactor:CGFloat = 0.6
    
    // -> Space factor, that separates the buttons
    let spaceFactor = 0.5
    
    // -> Factor for the radius of the rounded parts of the U shape
    let radiusFactor:CGFloat = 1.0
    
    // -> Factor of the border spacement
    let borderFactor: CGFloat = 0.33
    
    
    //Parameters
    
    //Current index of junction
    var junctionIndex: Int!
    
    //The glue image view
    var glueImageView: UIImageView!
    
    //Glue views array
    var glueArray = [UBAGlueView]()
    
    //radius of the glue circle
    var glueCircleRadius: CGFloat!
    
    //state of the junction availability
    var junctionAvailable:JunctionAvailable!
    
    //button that is currently being touched. If none is being touched,
    // this value is -1
    var activeButton: Int!
    
    //the start y coordinate that allows the button to move horizontally
    var yHorizontalMove: Double!
    
    //Size of the buttons, based on the width
    var buttonSize: CGFloat!
    
    //The height limit of the U animation
    var heightLimit: Double!
    
    //The speed of the buttons junction
    var junctionSpeed: Double!
    
    //Buttons speed
    var buttonSpeed: Double!
    
    //Array of buttons in the animation
    var buttonArray = [UBAButton]()
    
    //Quantity of buttons. MAX: 6
    var buttonsQuantity: Int!
    
    //space between the Y position of the buttons
    var buttonSpacement: CGFloat!
    
    //Timers for junctions and glue performs
    var junctionAvailableTimer:NSTimer?
    var junctionTimer: NSTimer!
    var glueTimer: NSTimer!
    
    
    convenience init(buttonsQuantity:Int!) {
        self.init()
        junctionAvailable = .IsAvailable
        self.buttonsQuantity = buttonsQuantity
        activeButton = -1
        heightLimit = 0.6
        junctionSpeed = 1.0
        buttonSpeed = 1.0
        junctionIndex = 0
        
    }
    
    func prepareAnimationOnView(view:UIView!, navigation: CGSize) {
        
        //Rect of view
        let animationWidth = view.frame.size.width
        let animationY = CGFloat(Double(view.frame.size.height) - (Double(view.frame.size.height) * heightLimit))
        let animationHeight = CGFloat(Double(view.frame.size.height) * heightLimit)
        
        self.frame = CGRectMake(0.0, animationY, animationWidth, animationHeight)
        
        //Size of the buttons, based on the vertical space of the U
        var p = Double(buttonsQuantity) * 2.0
        let size = CGFloat(Double(animationHeight) / p)
        
        //Border space of the buttons
        let border = size * borderFactor
        
        var buttonFrame = CGRectMake(border, view.frame.height/2, size, size)
        let spacement = CGFloat(Double(size) * spaceFactor)
        
        //Radius of the rounded part of the U
        let radius = size * radiusFactor
        
        //Points of the U shape
        let pointA = CGPointMake(buttonFrame.origin.x, buttonFrame.origin.y + self.frame.size.height/2 + navigation.height)
        let pointB = CGPointMake(border, self.frame.size.height - radius - border - size + self.frame.size.height/2 + navigation.height)
        let pointC = CGPointMake(border + radius, self.frame.size.height - border - size + self.frame.size.height/2 + navigation.height)
        let pointD = CGPointMake(self.frame.size.width - border - radius - size, pointC.y)
        let pointE = CGPointMake(self.frame.size.width - border - size, pointB.y)
        let pointF = CGPointMake(pointE.x, pointA.y )
        
        //Space between the buttons y origin
        buttonSpacement = size + spacement
        
        //Radius of the great circle, that creates the glues between the buttons
        glueCircleRadius = (buttonFrame.size.height + buttonSpacement) / 2.0
        
        buttonSize = size
        
        for var x = 0; x < buttonsQuantity; x++ {
            
            //Init button with frame, index and delegate
            var button = UBAButton(buttonIndex: x)
            button.frame = buttonFrame
            button.layer.cornerRadius = button.frame.size.height / 2.0
            button.delegate = self
            
            //Set the U bounds to the movement
            button.yVerticalLimit = pointB.y
            button.xLeftLimit = pointC.x
            button.xRightLimit = pointD.x
            button.uRadius = radius
            
            //@ TEST-ONLY
            button.backgroundColor = Colors.Azul
            
            //Insert the button on the array and in the view
            buttonArray.append(button)
            view.addSubview(button)
            
            //The frame for the next button
            buttonFrame.origin.y = buttonFrame.origin.y + size + spacement
        }
        
        //Pan gesture for button movement. This pan only moves the button if the user started the
        // touch inside one of the buttons
        var panGesture = UIPanGestureRecognizer(target: self, action: Selector("fingerMoved:"))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        
        //Prepare the glues
        //prepareGlues()
        
        //self.hidden = true
       // view.addSubview(self)
        
        //Starts the timer for junction
        junctionTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("buttonJunction"), userInfo: nil, repeats: true)

        //Starts the glue timer
        glueTimer = NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: Selector("redrawGlues"), userInfo: nil, repeats: true)
    }
    
    
    func addSelectorToButton(index:Int!, target:AnyObject!, selector:Selector!, image:String) {
        
        if buttonArray.count <= index {
            return
        }
        
        buttonArray[index].buttonSelector = selector
        buttonArray[index].buttonTarget = target
        buttonArray[index].setImage(UIImage(named: image), forState: UIControlState.Normal)
    }
    
    
    //Pan gesture to move the buttons
    func fingerMoved(recognizer:UIPanGestureRecognizer) {
        
        if junctionAvailableTimer?.valid == true {
            junctionAvailableTimer?.invalidate()
            junctionAvailableTimer = nil
        }
        
        junctionIndex = activeButton
        junctionAvailable = .NotAvailable
        
        if activeButton >= 0 {
            
            let translation = recognizer.translationInView(self)
            
            var distance: CGFloat = 0.0
            
            let yLimit = buttonArray[activeButton].yVerticalLimit
            let xLeft = buttonArray[activeButton].xLeftLimit
            let xRight = buttonArray[activeButton].xRightLimit
            
            var currentLocation = recognizer.locationInView(self)
            
            if currentLocation.y < 0.0 {
                return
            }
            
            // Area 1
            if currentLocation.x < xLeft && currentLocation.y <= yLimit {
                distance = translation.y
            }
            
            // Area 2
            else if currentLocation.x < xLeft && currentLocation.y > yLimit {
                distance = translation.x + translation.y
            }
            
            // Area 3
            // * If wanted to lock in the upper part the horizontal movement, add [ && currentLocation.y <= yLimit ] *
            else if currentLocation.x >= xLeft && currentLocation.x < xRight {
                distance = translation.x
            }
            
            // Area 4
            else if currentLocation.x >= xRight && currentLocation.y > yLimit {
                distance = -translation.y
                distance = distance + translation.x
            }
            
            // Area 5
            else if currentLocation.x > xRight && currentLocation.y <= yLimit {
                distance = -translation.y
            }
            
            //Settings of how the decelerations happens
            for var x = buttonArray.count - 1; x >= 0; x-- {
                
                var button = buttonArray[x]
                var diff = abs(Double(x - activeButton)) + 1.0
                var decelarate = buttonSpeed * diff
                
                if distance > 0.0 && x < activeButton {
                    
                    button.moveButtonBy(distance, decelerationRate: decelarate)
                    
                }
                
                else if distance <= 0.0 && x > activeButton {
                    
                    button.moveButtonBy(distance, decelerationRate: decelarate)
                }
                
                else {
                    button.moveButtonBy(distance, decelerationRate: 1.0)
                }
            }
            
            recognizer.setTranslation(CGPointZero, inView: self)
            
            //Junction will be soon available
            junctionAvailable = .SoonAvailable
            
            if junctionAvailableTimer == nil || junctionAvailableTimer?.valid == false {
                junctionAvailableTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("junctionIsNowAvailable"), userInfo: nil, repeats: true)
            }
            
        }
        
        
    }
    
    func junctionIsNowAvailable() {
        
        junctionAvailable = .IsAvailable
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        activeButton = -1
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        activeButton = -1
    }
    
    
    func buttonWasTouched(index: Int!) {
        activeButton = index
    }
    
    func touchStopped(index: Int!) {
        activeButton = -1
    }
    
    func buttonJunction() {
        
        var button: UBAButton!
        var index: Int = -1
        
        if junctionAvailable != .IsAvailable {
            return
        }
        
        index = junctionIndex
        button = buttonArray[junctionIndex]
        
        if button.movementsExecuting <= 0 {
            
            //Spread to others buttons
            
            for var x = index + 1; x < buttonArray.count; x++ {
                
                startJunctionOnButton(buttonArray[x],toButton: button, arrayDistance: x - index)
            }
            
            for var y = index - 1; y >= 0; y-- {
                
                startJunctionOnButton(buttonArray[y],toButton: button, arrayDistance: y - index)
            }
            
        }
        
        junctionIndex = junctionIndex + 1
        
        if junctionIndex >= buttonArray.count {
            junctionIndex = 0
        }
        
    }
    
    func startJunctionOnButton(button:UBAButton!, toButton:UBAButton!, arrayDistance:Int!) {

        
        var distanceNeeded = buttonSpacement * CGFloat(-arrayDistance)
        
        //The distance the [button] need to reach the [toButton]
        var currentDistance = button.distanceToButton(toButton)
        
        var moveDistance = currentDistance - distanceNeeded
        var currentIndex = button.buttonIndex
        
        if moveDistance < 1.0 && moveDistance > -1.0 {
            return
        }
        
        UIView.animateWithDuration(0.3 * junctionSpeed, animations: { () -> Void in
            button.moveButtonBy(moveDistance, decelerationRate: 1.0)
        })
    }
    
    
    func redrawGlues() {
        
//        for var number = 0; number < glueArray.count; number++ {
//            
//            var glue = glueArray[number]
//            
//            var button1 = buttonArray[number]
//            var button2 = buttonArray[number + 1]
//            
//            glue.attachToButtons(button1, button2: button2)            
//        }
        
    }
    
    func prepareGlues() {
        
        /* First, lets prepare the template for the glue.
           This template is constructed with two arcs, side
           to side, inverse to the other, so it looks like a
           glue for the buttons */
        
        var glueImage = UIImage()
        
        var size = CGSizeMake(CGFloat(buttonSize), (glueCircleRadius * 2.0))
        var rect = CGRectMake(0, 0, size.width, size.height)
        
        var center = CGPointMake(CGFloat(buttonSize / 2.0), size.height / 2.0)
        
        var leftCircleRect = CGRectMake(0, 0, glueCircleRadius * 2.0, glueCircleRadius * 2.0)
        var rightCircleRect = CGRectMake(leftCircleRect.size.width + (buttonSize * minimumGlueWidthFactor), 0, glueCircleRadius * 2.0, glueCircleRadius * 2.0)
        
        var leftCenter = CGPointMake(center.x - glueCircleRadius, center.y)
        var rightCenter = CGPointMake(center.x + glueCircleRadius, center.y)
        
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        var leftPath = UIBezierPath(arcCenter: leftCenter, radius: glueCircleRadius, startAngle: CGFloat(M_PI / 4.0), endAngle: CGFloat((7.0 * M_PI) / 4.0), clockwise: false)
        UIColor.blueColor().setStroke()
        leftPath.lineWidth = buttonSize * minimumGlueWidthFactor
        leftPath.stroke()
        
        var rightPath = UIBezierPath(arcCenter: rightCenter, radius: glueCircleRadius, startAngle: CGFloat(3.0 * M_PI / 4.0), endAngle: CGFloat((5.0 * M_PI) / 4.0), clockwise: true)
        UIColor.blueColor().setStroke()
        rightPath.lineWidth = buttonSize * minimumGlueWidthFactor
        rightPath.stroke()
    
        glueImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        glueImageView = UIImageView(frame: rect)
        glueImageView.image = glueImage
        glueImageView.backgroundColor = UIColor.clearColor()
        
        //--> Template done, now for the adjustments:
        
        
        //** ADJUSTMENTS TO THE GLUE SIZE **//
        let heightAdjust:CGFloat = 0.85
        let widthAdjust:CGFloat = 0.86
        let yAdjust:CGFloat = 0.37
        
        glueImageView.frame.size.height = glueImageView.frame.size.height * heightAdjust
        glueImageView.frame.size.width = glueImageView.frame.size.width * widthAdjust
        glueImageView.frame.origin.x = buttonArray.first!.frame.origin.x + ((buttonSize - glueImageView.frame.size.width) / 2.0)
        glueImageView.frame.origin.y = buttonArray.first!.frame.origin.y + ((buttonSize / 2.0) * yAdjust)
        
        //To test the adjustments, uncomment the line below
        
        //self.addSubview(glueImageView)
        
        
    
        
        /* Creating polar coordinates for the x and y of the
        glue view to attach the origin to the center of the
        circle button */
        
        var xDiff = abs(glueImageView.frame.origin.x - buttonArray.first!.center.x)
        
        var yDiff = abs(buttonArray.first!.center.y - glueImageView.frame.origin.y)
        
        var distance = sqrt((xDiff * xDiff) + (yDiff * yDiff))
        
        /*** THIS IS SET MANUALLY BY KNOWING THE CURRENTLY QUADRANT.
        IF THE QUADRANT CHANGES, PLEASE CHANGE THIS ALSO ***/
        var anchorAngle = (M_PI / 2.0) + Double(atan(xDiff / yDiff))
        
        
        //Creating all the glues
        for var y = 0; y < buttonArray.count - 1; y++ {
            
            //New UBAGlueView
            var newGlue = UBAGlueView(glueImageView: glueImageView)
            
            //Tells the button the standard button spacement
            newGlue.buttonSpacement = buttonSpacement
            
            //Add to the glue array
            glueArray.append(newGlue)
            
            self.addSubview(newGlue)
        }
        
        //Bring the buttons to front
        for var x = 0; x < buttonArray.count; x++ {
            self.bringSubviewToFront(buttonArray[x])
        }
        
        
    }
 
}

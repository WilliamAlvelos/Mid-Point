//
//  ETBScrollView.swift
//  MidPoint
//
//  Created by Danilo Mative on 24/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//
//
//--------------------------------//
//
//  Expansive ToolBar ScrollView
//
//--------------------------------//
//
//
//

import UIKit

class ETBScrollView: UIScrollView, UIScrollViewDelegate {

    
    private let alphaZeroFactor:CGFloat = 1.5
    
    //Expanded size factor of the frame
    private let expansionFactor:CGFloat = 0.6
    
    //Extra expansion from scrollView frame
    private let extraExpansionFactor:CGFloat = 0.13
    
    //Deceleration Start factor form frame
    private let decelerationStartFactor:CGFloat = 0.01
    
    //Factor of the toolbar height when not expanded
    private let toolbarHeightFactor:CGFloat = 0.13
    
    //Factor of side button spacement
    private let toolbarButtonSpacementFactor: CGFloat = 0.1
    
    private let toolbarButtonSpacementBorderFactor: CGFloat = 0.6
    
    //The deceleration value
    private let deceleration:CGFloat = 2.0
    
    //The toolbar sub
    var bounceViews = [UIView]()
    var bounceFrames = [CGRect]()
    
    //Limit of negative Y
    private var yLimit: CGFloat!
    var yBarLock: CGFloat!
    private var yDeceleration: CGFloat!
    
    var buttonsQuantity:Int!
    var buttonsImage = [UIImage]()
    var toolbarButtons = [UIButton]()
    var insideSubviewsFrame = [CGRect]()
    
    var insideToolbarView: UIView!
    var toolbarView: UIView!
    
    //Changeable properties
    var toolbarBackgroundColor:UIColor!
    var profileImage:UIImage!
    var profileName:String!
    var profileLocation:String!
    
    
    convenience init(numberOfButtons:Int!, images:[UIImage]) {
        self.init()
        
        if numberOfButtons <= 0 {
            buttonsQuantity = 3
        }
        
        else {
            buttonsQuantity = numberOfButtons
        }
        
        buttonsImage = images
        toolbarBackgroundColor = UIColor.blackColor()
        profileName = "Nome"
        profileLocation = "Brazil"
        profileImage = UIImage(named:"b_search.png")
    }
    
    
    func addSelectorToButton(buttonIndex:Int!,target:AnyObject!, selector:Selector) {
        
        if toolbarButtons.count <= buttonIndex {
            return
        }
        
        toolbarButtons[buttonIndex].addTarget(target, action: selector, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func prepareScrollViewWithContent(content:UIView!,frame:CGRect) {
        
        //Adjusting frames of scrollview
        self.frame = frame
        
        self.contentSize = CGSizeMake(self.frame.size.width, (self.frame.size.height * expansionFactor) + content.frame.size.height)
        yLimit = -(self.frame.size.height * extraExpansionFactor)
        delegate = self
        
        //Inside Toolbar View
        let insideToolbarFrame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height * expansionFactor)
        insideToolbarView = UIView(frame:insideToolbarFrame)
        insideToolbarView.backgroundColor = toolbarBackgroundColor
        
        //Custom views of inside toolbar
        var imageView = UIImageView()
        imageView.frame.size.width = self.frame.size.width / 3.0
        imageView.frame.size.height = imageView.frame.size.width
        imageView.layer.cornerRadius = imageView.frame.size.width / 2.0
        imageView.image = profileImage
        imageView.center = insideToolbarView.center
        imageView.frame.origin.y = imageView.frame.origin.y - (insideToolbarView.frame.size.height / 6.0)
        imageView.tag = 3
        insideToolbarView.addSubview(imageView)
        
        var nameLabel = UILabel()
        nameLabel.text = profileName
        nameLabel.textAlignment = NSTextAlignment.Center
        nameLabel.font = UIFont(name: "Avenir-Black", size: imageView.frame.size.height / 6.0)
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.sizeToFit()
        nameLabel.center.x = insideToolbarView.center.x
        nameLabel.frame.origin.y = imageView.frame.origin.y + imageView.frame.size.height + (nameLabel.frame.size.height / 2.0)
        nameLabel.tag = 1
        insideToolbarView.addSubview(nameLabel)
        
        var locationLabel = UILabel()
        locationLabel.text = profileLocation
        locationLabel.textAlignment = NSTextAlignment.Center
        locationLabel.font = UIFont(name: "Avenir", size: imageView.frame.size.height / 7.0)
        locationLabel.textColor = UIColor.whiteColor()
        locationLabel.sizeToFit()
        locationLabel.center.x = insideToolbarView.center.x
        locationLabel.frame.origin.y = nameLabel.frame.origin.y + nameLabel.frame.size.height + (locationLabel.frame.size.height / 3.0)
        locationLabel.tag = 2
        insideToolbarView.addSubview(locationLabel)
        
        //** Insert in the array to know the original frame. This is linked to the view tag **
        insideSubviewsFrame.append(CGRectZero)
        insideSubviewsFrame.append(nameLabel.frame)
        insideSubviewsFrame.append(locationLabel.frame)
        insideSubviewsFrame.append(imageView.frame)
        
        bounceViews.append(imageView)
        bounceFrames.append(imageView.frame)
        
        //Toolbar
        toolbarView = UIView()
        toolbarView.frame.size.height = self.frame.size.height * toolbarHeightFactor
        toolbarView.frame.size.width = self.frame.size.width
        toolbarView.frame.origin.y = insideToolbarView.frame.size.height - toolbarView.frame.size.height
        toolbarView.backgroundColor = UIColor.clearColor()
        
        //The y values that makes the bar lock above the view
        yBarLock = toolbarView.frame.origin.y
        yDeceleration = self.frame.size.height * decelerationStartFactor
        
        //Creates the buttons for the toolbar
        var border = self.frame.size.width * toolbarButtonSpacementBorderFactor
        var spacement = self.frame.size.width * toolbarButtonSpacementFactor
        var buttonWidth = self.frame.size.width - (spacement * CGFloat(buttonsQuantity + 1))
        buttonWidth = buttonWidth / CGFloat(buttonsQuantity)
        
        var buttonSize = CGSizeMake(buttonWidth, toolbarView.frame.size.height)
        buttonSize.height *= toolbarButtonSpacementBorderFactor
        buttonSize.width *= toolbarButtonSpacementBorderFactor
        
        var buttonCenter = CGPointMake(spacement + buttonWidth / 2.0, toolbarView.frame.size.height / 2.0)
        
        //var buttonRect = CGRectMake(spacement, 0.0, buttonWidth, toolbarView.frame.size.height)
        
        for var x = 0; x < buttonsQuantity; x++ {
            
            var button = UIButton()
            button.frame.size = buttonSize
            button.center = buttonCenter
            
            //var button = UIButton(frame: buttonRect)
            
            if x < buttonsImage.count {
                button.setImage(buttonsImage[x], forState: .Normal)
            }
            
            toolbarView.addSubview(button)
            toolbarButtons.append(button)
            
            buttonCenter.x = buttonCenter.x + spacement + buttonWidth
            
            //buttonRect.origin.x = buttonRect.origin.x + buttonWidth
        }
        
        //Add the views to the scrollview
        self.addSubview(insideToolbarView)
        self.addSubview(toolbarView)
        
        content.frame.origin.y = insideToolbarView.frame.size.height
        self.addSubview(content)
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        //Deceleration part
        changeYDeceleration(scrollView.contentOffset.y)
        
        //Toolbar locking part
        if scrollView.contentOffset.y >= yBarLock {
            toolbarView.frame.origin.y = scrollView.contentOffset.y
            self.addSubview(toolbarView)
        }
            
        else {
            toolbarView.frame.origin.y = yBarLock
        }
        
        
        //Bounce up limit part
        if scrollView.contentOffset.y < yLimit {
            scrollView.contentOffset.y = yLimit
        }
        
        //Bounce resize part
        if scrollView.contentOffset.y < 0.0 {
            bounceResize(-scrollView.contentOffset.y)
        }
        
    }
    
    func fixResize() {
        
        for var x = 0; x < bounceViews.count; x++ {
            bounceViews[x].frame = bounceFrames[x]
        }
        
    }
    
    func bounceResize(value:CGFloat) {
        
        for var x = 0; x < bounceViews.count; x++ {
            
            var size = bounceFrames[x].size
            size.height += value
            size.width += value
            
            var origin = bounceFrames[x].origin
            origin.y = origin.y - value
            origin.x = origin.x - (value / 2.0)
            
            bounceViews[x].frame.size = size
            bounceViews[x].frame.origin = origin
        }
    }
    
    func changeYDeceleration(value:CGFloat!) {
        
        for var x = 0; x < insideToolbarView.subviews.count; x++ {
            
            
            var total = toolbarView.frame.origin.y - yDeceleration
            var distance = value - yDeceleration
            
            
            var index = insideToolbarView.subviews[x].tag
            
            var originalX = insideSubviewsFrame[index].origin.x
            var originalY = insideSubviewsFrame[index].origin.y
            var originalWidth = insideSubviewsFrame[index].size.width
            var originalHeight = insideSubviewsFrame[index].size.height
            
            var newY = originalY + (distance / deceleration)
            
            var originalDistance = toolbarView.frame.origin.y - (originalY + (originalHeight / 1.5))
            var newDistance = toolbarView.frame.origin.y - (newY + (originalHeight / 1.5))
            
            var alpha = newDistance / originalDistance
            
            var view = insideToolbarView.subviews[x] as! UIView
            
            if value <= yDeceleration {
                view.frame = insideSubviewsFrame[index]
                view.alpha = 1.0
            }
            
            else {
                
                view.frame = CGRectMake(originalX, newY, originalWidth, originalHeight)
                view.alpha = alpha
                
                insideToolbarView.addSubview(view)
            }
            
        }
    }
    
}

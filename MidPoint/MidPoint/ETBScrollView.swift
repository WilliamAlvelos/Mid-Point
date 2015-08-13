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

protocol ETBNavigationTitle {
    
    func shouldDisplayTitle(title:String!)
    func shouldHideTitle()
    
}


class ETBScrollView: UIScrollView, UIScrollViewDelegate {

    
    var ETBNavigationDelegate = ETBNavigationTitle?()
    
    private let alphaZeroFactor:CGFloat = 1.5
    
    //Expanded size factor of the frame
    private let expansionFactor:CGFloat = 0.6
    
    //Extra expansion from scrollView frame
    private let extraExpansionFactor:CGFloat = 0.13
    
    //Deceleration Start factor form frame
    private let decelerationStartFactor:CGFloat = 0.01
    
    private let toolbarBottomSpaceFactor: CGFloat = 0.35
    
    //Factor of the toolbar height when not expanded
    private let toolbarHeightFactor:CGFloat = 0.1
    
    //Factor of side button spacement
    private let toolbarButtonSpacementFactor: CGFloat = 0.0
    private let toolbarButtonSpacementBorderFactor: CGFloat = 0.47
    private let offsideSpaceToolbarFactor: CGFloat = 0.3
    
    //The deceleration value
    private let deceleration:CGFloat = 2.0
    
    //Maximum blur alpha value
    private let blurAlphaMax: CGFloat = 0.75
    
    //The toolbar sub
    var bounceViews = [UIView]()
    var bounceFrames = [CGRect]()
    
    //Toolbar background image
    var toolbarBackgroundImage: UIImage!
    
    //Limit of negative Y
    private var yLimit: CGFloat!
    var yBarLock: CGFloat!
    var navigationBarHeight: CGFloat!
    var superviewNavigationBar: UINavigationBar?
    private var yDeceleration: CGFloat!
    
    var buttonsQuantity:Int!
    var buttonsImage = [UIImage]()
    var toolbarButtons = [UIButton]()
    var insideSubviewsFrame = [CGRect]()
    
    var insideToolbarView: UIView!
    var insideToolbarBackground: UIImageView!
    var toolbarView: UIView!
    
    //Changeable properties
    var toolbarBackgroundColor:UIColor!
    var profileImage:UIImage!
    var profileName:String!
    var profileLocation:String!
    
    //Factor for background image inside toolbar
    var factorToWidth: CGFloat!
    
    //Blur effect
    var blurEffectViews = [UIVisualEffectView]()
    var blurQuantity:Int = 2
    var currentBlur:Int = 0
    
    //Views z position boolean
    var shouldBeBehind = false
    
    //Content View
    var contentView: UIView!
    var contentScrollView: UIScrollView!
    
    //Locking content scrollview
    var yLockContentScrollView: CGFloat!
    
    //Current button active
    var currentButtonIndex: Int!
    
    //Title that should display in the navigation bar
    var navigationTitle: String!
    
    var shouldDisplayTitle = false
    
    var displayTitleY: CGFloat!
    
    
    convenience init(numberOfButtons:Int!, images:[UIImage], backgroundImage:UIImage?) {
        self.init()
        
        if numberOfButtons <= 0 {
            buttonsQuantity = 3
        }
        
        else {
            buttonsQuantity = numberOfButtons
        }
        
        navigationBarHeight = 0.0
        
        
        if backgroundImage == nil {
            toolbarBackgroundImage = UIImage()
        }
        
        else {
            toolbarBackgroundImage = backgroundImage
        }
        
        currentButtonIndex = 0
        buttonsImage = images
        toolbarBackgroundColor = UIColor.blackColor()
        profileName = "Sem Nome"
        profileLocation = "Local Desconhecido"
        profileImage = UIImage()
        self.decelerationRate = 0.4
        self.showsVerticalScrollIndicator = false
    }
    
    //This function adds a selector to a specific button in the toolbar
    func addSelectorToButton(buttonIndex:Int!,target:AnyObject!, selector:Selector) {
        
        if toolbarButtons.count <= buttonIndex {
            return
        }
        
        toolbarButtons[buttonIndex].addTarget(target, action: selector, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    
    //This function prepares the ETBScrollView with a content view, the frame and, if has one, the navigation bar of the view that will receive the ETB.
    func prepareScrollViewWithContentView(content:UIView!,frame:CGRect,navigationBar:UINavigationBar?) {
        
        
        //Prepare the navigation to be transparent, in case of having one
        if navigationBar != nil {
            navigationBarHeight = navigationBar?.frame.size.height
            
            superviewNavigationBar = navigationBar
            
            superviewNavigationBar?.translucent = true
            superviewNavigationBar?.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
            superviewNavigationBar?.shadowImage = UIImage()
            superviewNavigationBar?.backgroundColor = UIColor.clearColor()
            
            let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            superviewNavigationBar?.titleTextAttributes = titleDict as [NSObject : AnyObject]
        }
    
        
        
        //Adjusting frame of scrollview
        self.frame = frame
        
        
        //Setting the content size of the scrollview, to fit the inside toolbar part and the content view
        self.contentSize = CGSizeMake(self.frame.size.width, (self.frame.size.height * expansionFactor) + content.frame.size.height)
        
        
        //sets the scrollview delegate to self
        delegate = self
        
        
        //Inside Toolbar View creation and frames
        let insideToolbarFrame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height * expansionFactor)
        insideToolbarView = UIView(frame:insideToolbarFrame)
        insideToolbarView.backgroundColor = toolbarBackgroundColor
        
        
        //Inside toolbar background image preparation
        insideToolbarBackground = UIImageView(frame:insideToolbarFrame)
        insideToolbarBackground.image = toolbarBackgroundImage
        insideToolbarView.addSubview(insideToolbarBackground)
        
        
        //Factor for image increasement
        factorToWidth = insideToolbarBackground.frame.size.width / insideToolbarBackground.frame.size.height
        
        
        //Current blur quantity
        currentBlur = blurQuantity
        
        //Prepares the blur views
        for var x = 0; x < blurQuantity; x++ {
            var blur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
            var blurView = UIVisualEffectView(effect: blur)
            blurView.frame.size = insideToolbarBackground.frame.size
            //This view is made bigger than the imageview for the moment when the image is going to increase its size
            blurView.frame.size.height *= 1.5
            blurView.frame.size.width *= 1.5
            blurView.alpha = blurAlphaMax
            insideToolbarBackground.addSubview(blurView)
            blurEffectViews.append(blurView)
        }
        
        
        //**---- The part below is still in development------ **
        
        //Blue mask for the background image.
        var blueMask = UIView()
        blueMask.backgroundColor = Colors.Azul
        blueMask.frame.size = insideToolbarBackground.frame.size
        blueMask.alpha = 0.6
        //insideToolbarBackground.addSubview(blueMask)
        
        //** ---The part above is still in development ---**
        
        
        //------------------- Custom views of inside toolbar below -------------------//
        var imageView = UIImageView()
        imageView.frame.size.height = self.frame.size.height / 5.0
        imageView.frame.size.width = imageView.frame.size.height
        imageView.image = profileImage
        imageView.center = insideToolbarView.center
        // ** Change the divisor to change the imageView position and the others subviews of the inside toolbar
        imageView.frame.origin.y = imageView.frame.origin.y - (insideToolbarView.frame.size.height / 10.0)
        imageView.tag = 3
        imageView.layer.cornerRadius = imageView.frame.size.width / 2.0
        imageView.clipsToBounds = true
        
        if UIDevice.currentDevice().name.rangeOfString("iPad") != nil {
            imageView.frame.origin.y -= imageView.frame.origin.y / 3.0
        }
        
        insideToolbarView.addSubview(imageView)
        
        var nameLabel = UILabel()
        nameLabel.text = profileName
        nameLabel.textAlignment = NSTextAlignment.Center
        nameLabel.font = UIFont(name: "OpenSans-Semibold", size: imageView.frame.size.height / 7.5)
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.sizeToFit()
        nameLabel.center.x = insideToolbarView.center.x
        nameLabel.frame.origin.y = imageView.frame.origin.y + imageView.frame.size.height + (nameLabel.frame.size.height / 2.0)
        nameLabel.tag = 1
        insideToolbarView.addSubview(nameLabel)
        
        var locationLabel = UILabel()
        locationLabel.text = profileLocation
        locationLabel.textAlignment = NSTextAlignment.Center
        locationLabel.font = UIFont(name: "OpenSans-Light", size: imageView.frame.size.height / 8.0)
        locationLabel.textColor = UIColor.whiteColor()
        locationLabel.sizeToFit()
        locationLabel.center.x = insideToolbarView.center.x
        locationLabel.frame.origin.y = nameLabel.frame.origin.y + nameLabel.frame.size.height + (locationLabel.frame.size.height / 3.0)
        locationLabel.tag = 2
        insideToolbarView.addSubview(locationLabel)
        
        var starButton = UIButton(frame: CGRect(x: 0.0, y: imageView.frame.origin.y + imageView.frame.size.height - (imageView.frame.size.height / 4.0), width: imageView.frame.size.height / 4.0, height: imageView.frame.size.height / 4.0))
        
        starButton.frame.origin.x = imageView.frame.origin.x - (imageView.frame.size.height / 4.0)
        starButton.setBackgroundImage(UIImage(named: "favorito_blue"), forState: UIControlState.Normal)
        insideToolbarView.addSubview(starButton)
        
        var addFriendButton = UIButton(frame: CGRectMake(imageView.frame.origin.x + imageView.frame.size.width, starButton.frame.origin.y, starButton.frame.size.width, starButton.frame.size.height))
        addFriendButton.setBackgroundImage(UIImage(named: "add_user_green"), forState: UIControlState.Normal)
        insideToolbarView.addSubview(addFriendButton)
        
        //------------------------------------------------------------------------//
        
        
        
        //Toolbar creation and frames
        toolbarView = UIView()
        toolbarView.frame.size.height = self.frame.size.height * toolbarHeightFactor
        toolbarView.frame.size.width = self.frame.size.width
        toolbarView.frame.origin.y = insideToolbarView.frame.size.height - toolbarView.frame.size.height - (toolbarView.frame.size.height * toolbarBottomSpaceFactor)
        toolbarView.backgroundColor = UIColor.clearColor()
        
        
        //The y value that makes the bar lock above the view
        yBarLock = toolbarView.frame.origin.y - navigationBarHeight
        
        
        
        
        //--------------- Creates the buttons for the toolbar -------------//
        
        var border = self.frame.size.width * toolbarButtonSpacementBorderFactor
        var spacement = self.frame.size.width * toolbarButtonSpacementFactor
        var buttonWidth = self.frame.size.width - (offsideSpaceToolbarFactor * self.frame.size.width) - (spacement * CGFloat(buttonsQuantity + 1))
        buttonWidth = buttonWidth / CGFloat(buttonsQuantity)
        
        var buttonSize = CGSizeMake(buttonWidth, buttonWidth)
        buttonSize.height *= toolbarButtonSpacementBorderFactor
        buttonSize.width *= toolbarButtonSpacementBorderFactor
        
        let offsideSpace = (offsideSpaceToolbarFactor * self.frame.size.width) / 2.0
        
        var buttonCenter = CGPointMake(offsideSpace + spacement + buttonWidth / 2.0, toolbarView.frame.size.height / 2.0)
        
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
        }
        
        //------------------------------------------------------------------------//
        
        
        //Creates the Scrollview content
        contentScrollView = UIScrollView(frame: CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height - toolbarView.frame.size.height - navigationBarHeight))
        contentScrollView.scrollEnabled = false
        contentScrollView.contentSize = content.frame.size
        contentScrollView.backgroundColor = Colors.Rosa
        content.frame.origin = CGPointZero
        content.backgroundColor = Colors.Rosa
        contentScrollView.addSubview(content)
    
        
        //Add the views to the scrollview
        self.addSubview(insideToolbarView)
        self.addSubview(contentScrollView)
        self.addSubview(toolbarView)
        
        
        //Y limit for pushing the view, showing the image. This value will change if the superview has a navigationBar
        yLimit = 0.0
        
        
        //Title that will be setted to the navigation title
        navigationTitle = profileName

    }
    
    
    
    //MARK: ScrollView Delegate
    
    //This function will make changes to all the views by the scrollview offset point
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        
        //Changes the yLimit to the sudden movement of the navigation bar
        if yLimit == 0.0 && navigationBarHeight != 0.0 {
            
            //New yLimit for pushing the inside toolbar
            yLimit = scrollView.contentOffset.y
            
            //changes the y that shows the navigation title
            displayTitleY = yLimit + navigationBarHeight * 0.5
            
            //changes the toolbar
            toolbarView.frame.origin.y += yLimit
            yBarLock = toolbarView.frame.origin.y
            
            // Adjust the contentScrollView and its y lock
            contentScrollView.frame.origin.y = toolbarView.frame.origin.y + toolbarView.frame.size.height + (toolbarView.frame.size.height * toolbarBottomSpaceFactor)
            yLockContentScrollView = yBarLock + toolbarView.frame.size.height * toolbarBottomSpaceFactor
        }
        
        
        
        if scrollView.contentOffset.y >= displayTitleY && shouldDisplayTitle == false {
            
            shouldDisplayTitle = true
            ETBNavigationDelegate?.shouldDisplayTitle(navigationTitle)
            
        }
            
        else if scrollView.contentOffset.y < displayTitleY && shouldDisplayTitle == true {
            
            shouldDisplayTitle = false
            ETBNavigationDelegate?.shouldHideTitle()
        }
        
        
        
        insideToolbarView.frame.origin.y = scrollView.contentOffset.y
        
        //Toolbar locking part
        if scrollView.contentOffset.y + navigationBarHeight >= yBarLock {
            toolbarView.frame.origin.y = scrollView.contentOffset.y + navigationBarHeight
            
            //Using the main scrollview to scroll the contentScrollView
            var newY = scrollView.contentOffset.y + navigationBarHeight - yBarLock
            newY = newY * 0.4
            contentScrollView.contentOffset.y = newY
            
            if scrollView.contentOffset.y + navigationBarHeight >= yLockContentScrollView {
                contentScrollView.frame.origin.y = toolbarView.frame.origin.y + toolbarView.frame.size.height
            }
        }
            
        else {
            toolbarView.frame.origin.y = yBarLock
            
            contentScrollView.frame.origin.y = toolbarView.frame.origin.y + toolbarView.frame.size.height + (toolbarView.frame.size.height * toolbarBottomSpaceFactor)
            contentScrollView.contentOffset.y = 0.0
        }
        
        
        //Content ScrollView locking part
        
        
        /* This 'if' means that the scrollview is being pushed down
        and it needs to start to show the background image of the user */
        if scrollView.contentOffset.y < yLimit {
            
            var distance = (toolbarView.frame.size.height / 1.5)
            var alphaValue = 1.0 - (abs(scrollView.contentOffset.y - yLimit) / (toolbarView.frame.size.height / 1.5))
            
            for subview in insideToolbarView.subviews as! [UIView] {
                subview.alpha = alphaValue
            }
            
            toolbarView.alpha = alphaValue
            insideToolbarBackground.alpha = 1.0
            
            if alphaValue > blurAlphaMax {
                alphaValue = blurAlphaMax
            }
            
            for blurView in blurEffectViews {
                blurView.alpha = alphaValue
            }
        }
        
        else {
            
            alphaSubviews(scrollView.contentOffset.y)

            for blurView in blurEffectViews {
                blurView.alpha = blurAlphaMax
            }
            
            toolbarView.alpha = 1.0
            
        }
        
        //Makes the background image increase its size
        if toolbarView.frame.origin.y + toolbarView.frame.size.height + (toolbarView.frame.size.height * toolbarBottomSpaceFactor) > insideToolbarView.frame.origin.y + insideToolbarView.frame.size.height {
            
            var centerX = insideToolbarBackground.center.x
            insideToolbarBackground.frame.size.height = abs(insideToolbarView.frame.origin.y - (toolbarView.frame.origin.y + toolbarView.frame.size.height + (toolbarView.frame.size.height * toolbarBottomSpaceFactor)))
            insideToolbarBackground.frame.size.width = insideToolbarBackground.frame.size.height * factorToWidth
            insideToolbarBackground.center.x = centerX
            
        }
        
        else {
            
            var centerX = insideToolbarBackground.center.x
            insideToolbarBackground.frame.size.height = insideToolbarView.frame.size.height
            insideToolbarBackground.frame.size.width = insideToolbarBackground.frame.size.height * factorToWidth
            insideToolbarBackground.center.x = centerX
        }
        
    }

    
    func alphaSubviews(distance:CGFloat!) {
        
        let pointY = self.convertPoint(toolbarView.frame.origin, toView:insideToolbarView).y
        
        for subview in insideToolbarView.subviews as! [UIView] {
            
            let border = subview.frame.origin.y + subview.frame.size.height
            let alphaValue = (pointY - border) / (toolbarView.frame.size.height / 4.0)
            
            subview.alpha = alphaValue
        }
        
        insideToolbarBackground.alpha = 1.0
    }
    
    
    //    func fixResize() {
    //
    //        for var x = 0; x < bounceViews.count; x++ {
    //            bounceViews[x].frame = bounceFrames[x]
    //        }
    //
    //    }
    
    //    func bounceResize(value:CGFloat) {
    //
    //        for var x = 0; x < bounceViews.count; x++ {
    //
    //            var size = bounceFrames[x].size
    //            size.height += value
    //            size.width += value
    //
    //            var origin = bounceFrames[x].origin
    //            origin.y = origin.y - value
    //            origin.x = origin.x - (value / 2.0)
    //
    //            bounceViews[x].frame.size = size
    //            bounceViews[x].frame.origin = origin
    //        }
    //    }
    
//    func changeYDeceleration(value:CGFloat!) {
//        
//        for var x = 0; x < insideToolbarView.subviews.count; x++ {
//            
//            
//            var total = toolbarView.frame.origin.y - yDeceleration
//            var distance = value - yDeceleration
//            
//            
//            var index = insideToolbarView.subviews[x].tag
//            
//            var originalX = insideSubviewsFrame[index].origin.x
//            var originalY = insideSubviewsFrame[index].origin.y
//            var originalWidth = insideSubviewsFrame[index].size.width
//            var originalHeight = insideSubviewsFrame[index].size.height
//            
//            var newY = originalY + (distance / deceleration)
//            
//            var originalDistance = toolbarView.frame.origin.y - (originalY + (originalHeight / 1.5))
//            var newDistance = toolbarView.frame.origin.y - (newY + (originalHeight / 1.5))
//            
//            var alpha = newDistance / originalDistance
//            
//            var view = insideToolbarView.subviews[x] as! UIView
//            
//            if value <= yDeceleration {
//                view.frame = insideSubviewsFrame[index]
//                view.alpha = 1.0
//            }
//            
//            else {
//                
//                view.frame = CGRectMake(originalX, newY, originalWidth, originalHeight)
//                view.alpha = alpha
//                
//                insideToolbarView.addSubview(view)
//            }
//            
//        }
//    }
    
}

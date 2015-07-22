//
//  OCView.swift
//  MidPoint
//
//  Created by Danilo Mative on 20/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//
//  Open-Content View
//
//
import UIKit


class OCView: UIView, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    let halfOpenDuration = 0.4
    let intervalOpen = 0.02
    
    var animationState:Int!
    var leftOpen: Bool!
    var rightOpen: Bool!
    
    var insideImagesArray = [UIImage]()
    
    
    var rollingCover: UIView!
    var leftCover: UIImageView!
    var insideScrollView: UIScrollView!
    var rollingInside: UIView!
    
    var testArray = [UIImage]()
    var tempView: UIView!
    
    convenience init(mainImage:UIImage!, insideImages:[UIImage]!, frame:CGRect!) {
        self.init()
        
        self.frame = frame
        
        var stdFrame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)
        
        animationState = 0
        
        //Copy the array of images
        insideImagesArray = insideImages
        
        //Separate the images in two images
        var mainSeparatedImages = separateViewInImageParts(mainImage, quantity: 2, horizontally: true)
        
        var leftImage = mainSeparatedImages[0]
        var rightImage = mainSeparatedImages[1]
        
        //Prepare the right image view of the rolling cover
        var rightImageView = UIImageView()
        rightImageView.image = rightImage
        rightImageView.frame = stdFrame
        rightImageView.frame.size.width = rightImageView.frame.size.width / 2.0
        rightImageView.frame.origin.x = rightImageView.frame.size.width
        
        println(rightImageView.frame.size.height)
        
        //Rolling cover
        rollingCover = UIView(frame: stdFrame)
        rollingCover.addSubview(rightImageView)
        
        //Left cover
        leftCover = UIImageView()
        leftCover.image = leftImage
        leftCover.frame = stdFrame
        leftCover.frame.size.width = leftCover.frame.size.width / 2.0
        
        //ScrollView, that is below the cover views
        insideScrollView = UIScrollView(frame: stdFrame)
        insideScrollView.contentSize = CGSizeMake(frame.size.height * CGFloat(insideImagesArray.count), frame.size.height)
        insideScrollView.delegate = self
        
        var scrollRect = CGRectMake(0.0, 0.0, frame.size.height, frame.size.height)
        
        
        //View that will be used to generate pictures
        //tempView = UIView(frame: stdFrame)
        
        //Add all the images in the scrollView
        for var x = 0; x < insideImagesArray.count; x++ {
            var imageView = UIImageView()
            imageView.image = insideImagesArray[x]
            imageView.frame = scrollRect
            
            scrollRect.origin.x += imageView.frame.size.width
            
            insideScrollView.addSubview(imageView)
            
        }
        
        //Take a picture of the scroll View
        var fullScrollPicture = takePictureOfView(insideScrollView)
        //Separates the picture in two
        var array = separateViewInImageParts(fullScrollPicture, quantity: 2, horizontally: true)
        
        //Add the first picture to the rolling inside
        rollingInside = UIView(frame: stdFrame)
        var leftInside1 = UIImageView(frame: leftCover.frame)
        leftInside1.image = array.first
        leftInside1.frame = leftCover.frame
        leftInside1.frame.size.width = leftCover.frame.size.width / 2.0
        
        var leftInside2 = UIImageView(frame: leftInside1.frame)
        leftInside2.image = array.last
        leftInside2.frame.origin.x = leftInside1.frame.size.width
        
        rollingInside.addSubview(leftInside1)
        rollingInside.addSubview(leftInside2)
        
        insideScrollView.layer.zPosition = -1.0
        rollingInside.layer.zPosition = 60.0
        rollingCover.layer.zPosition = 60.0
        leftCover.layer.zPosition = 70.0
        
        self.addSubview(insideScrollView)
        self.addSubview(rollingCover)
        self.addSubview(leftCover)
        
        self.backgroundColor = UIColor.blackColor()
        
        //Add the left swipe gesture recognizer
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("openContent"))
        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        
        leftSwipe.delegate = self
        
        self.addGestureRecognizer(leftSwipe)
        
    }
    
    func openContent() {
        
        if animationState == 0 {
            
            animationState = 1
            callNextAnimation()
        }
    }
    
    func closeContent() {
        
        if animationState == 3 {
            animationState = 4
            callNextAnimation()
        }
    }
    

    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        animationState = animationState + 1
        callNextAnimation()
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView.contentOffset.x < 0.0 {
            closeContent()
        }
    }
    
    
    private func callNextAnimation() {
        
        // Will open
        if animationState == 1 {
            
            var firstOpen = CABasicAnimation(keyPath: "transform.rotation.y")
            firstOpen.duration = halfOpenDuration
            firstOpen.fromValue = 0.0
            firstOpen.toValue = M_PI / 2.0
            firstOpen.delegate = self
            
            var rf = rollingCover.frame
            var rif = rollingInside.frame
            
            rollingCover.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI / 2.0), 0.0, 1.0, 0.0)
            rollingCover.layer.addAnimation(firstOpen, forKey: "firstOpen")
        }
        
        if animationState == 2 {
            
            rollingCover.removeFromSuperview()
            
            leftCover.layer.zPosition = 50.0
            
            var secondOpen = CABasicAnimation(keyPath: "transform.rotation.y")
            secondOpen.duration = halfOpenDuration
            secondOpen.fromValue = (2.0 * M_PI) - (M_PI / 2.0)
            secondOpen.toValue = 2.0 * M_PI
            secondOpen.delegate = self
            
            self.addSubview(rollingInside)
            
            rollingInside.layer.transform = CATransform3DMakeRotation(0.0, 0.0, 1.0, 0.0)
            rollingInside.layer.addAnimation(secondOpen, forKey: "open")
        }
        
        // Its open!
        if animationState == 3 {
            
            rollingInside.removeFromSuperview()
            leftCover.removeFromSuperview()
        }
        
        // Will close
        if animationState == 4 {
            self.addSubview(leftCover)
            self.addSubview(rollingInside)
            
            var firstClose = CABasicAnimation(keyPath: "transform.rotation.y")
            firstClose.duration = halfOpenDuration
            firstClose.fromValue = 0.0
            firstClose.toValue = -(M_PI / 2.0)
            firstClose.delegate = self
            
            rollingInside.layer.transform = CATransform3DMakeRotation(CGFloat(-(M_PI / 2.0)), 0.0, 1.0, 0.0)
            rollingInside.layer.addAnimation(firstClose, forKey: "firstClose")
        }
        
        if animationState == 5 {
            
            leftCover.layer.zPosition = 70.0
            
            rollingInside.removeFromSuperview()
            self.addSubview(rollingCover)
            self.bringSubviewToFront(leftCover)
            
            var secondClose = CABasicAnimation(keyPath: "transform.rotation.y")
            secondClose.duration = halfOpenDuration
            secondClose.fromValue = (M_PI / 2.0)
            secondClose.toValue = 0.0
            secondClose.delegate = self
            
            rollingCover.layer.transform = CATransform3DMakeRotation(0.0, 0.0, 1.0, 0.0)
            rollingCover.layer.addAnimation(secondClose, forKey: "secondClose")
            
        }
        
        // Its close!
        if animationState == 6 {
            animationState = 0
        }

    }
    
    
    
    private func takePictureOfView(view:UIView!)->UIImage {
        
        UIGraphicsBeginImageContextWithOptions(view.frame.size, view.opaque, 0.0)
        
        view.layer.renderInContext(UIGraphicsGetCurrentContext())
        
        var image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
        
    }
    
    
    private func separateViewInImageParts(image:UIImage!,quantity:Int!,horizontally:Bool)->[UIImage] {
        
        var imageArray = [UIImage]()
        
        var number = CGFloat(quantity)
        
        var rect: CGRect
        
        if horizontally == true {
            rect = CGRectMake(0, 0, image.size.width / number, image.size.height)
        }
        
        else {
            rect = CGRectMake(0, 0, image.size.width, image.size.height / number)
        }
        
        for var x = 0; x < quantity; x++ {
            
            var imageRef = CGImageCreateWithImageInRect(image.CGImage, rect)
            var newImage = UIImage(CGImage: imageRef)!
            
            imageArray.append(newImage)
            
            if horizontally == true {
                rect.origin.x += rect.size.width
            }
            
            else {
                rect.origin.y += rect.size.height
            }
        }
        
        return imageArray
    }

}

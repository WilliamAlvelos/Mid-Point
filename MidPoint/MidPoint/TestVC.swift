//
//  TestVC.swift
//  MidPoint
//
//  Created by Danilo Mative on 24/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import UIKit

class TestVC: UIViewController {

    
    var ocView: OCView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //ETBScrollView Test ---------------------
        
//        self.view.backgroundColor = UIColor.blackColor()
//        
//        var b = UIView(frame:self.view.frame)
//        b.backgroundColor = UIColor.redColor()
//        
//        var a = ETBScrollView(numberOfButtons: 3, images: [UIImage()])
//        
//        a.prepareScrollViewWithContent(b, frame: self.view.frame)
//        
//        self.view.addSubview(a)
        
        
        //UBA Test --------------------
        
        var uba = UBAView(buttonsQuantity: 3)
        uba.prepareAnimationOnView(self.view)
        
        
        //OCView Test --------------------------
        
        var main = UIImage(named: "test.png")
        var images = [UIImage]()
        
        for var x = 0.3; x < 1.0; x = x + 0.2 {
            
            var newImage = getImageWithColor(UIColor(red: 0.8, green: 0.2, blue: CGFloat(x), alpha: 1.0), size: CGSizeMake(100.0,100.0))
            images.append(newImage)
            
        }
        
        var rect = CGRectMake(0, 350, self.view.frame.size.width, self.view.frame.size.height / 3.0)
        ocView = OCView(mainImage: main, insideImages: images, frame: rect)
        
        self.view.addSubview(ocView)
        
        
        
        
    }
    
    
    //For OCView test
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        var rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  GradientProgressView.swift
//  MidPoint
//
//  Created by William Alvelos on 27/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    
    private let progressLayer: CAShapeLayer = CAShapeLayer()
    
    private var progressLabel: UILabel
    
    required init(coder aDecoder: NSCoder) {
        progressLabel = UILabel()
        super.init(coder: aDecoder)
        createProgressLayer()
        createLabel()
    }
    
    override init(frame: CGRect) {
        progressLabel = UILabel()
        super.init(frame: frame)
        createProgressLayer()
        createLabel()
    }
    
    func createLabel() {
        progressLabel = UILabel(frame: CGRectMake(0.0, 0.0, CGRectGetWidth(frame), 60.0))
        progressLabel.textColor = UIColor(red: 19/255, green: 16/255, blue: 70/255, alpha: 1)
        progressLabel.textAlignment = .Center
        progressLabel.text = "Loading.."
        progressLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 40.0)
        progressLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(progressLabel)
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: progressLabel, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: progressLabel, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
    }
    
    private func createProgressLayer() {
        let startAngle = CGFloat(M_PI_2)
        let endAngle = CGFloat(M_PI * 2 + M_PI_2)
        let centerPoint = CGPointMake(CGRectGetWidth(frame)/2 , CGRectGetHeight(frame)/2)
        
        var gradientMaskLayer = gradientMask()
        progressLayer.path = UIBezierPath(arcCenter:centerPoint, radius: CGRectGetWidth(frame)/2 - 30.0, startAngle:startAngle, endAngle:endAngle, clockwise: true).CGPath
        progressLayer.backgroundColor = UIColor(red: 19/255, green: 16/255, blue: 70/255, alpha: 1).CGColor
        progressLayer.fillColor = nil
        progressLayer.strokeColor = UIColor.whiteColor().CGColor
        progressLayer.lineWidth = 4.0
        progressLayer.strokeStart = 0.0
        progressLayer.strokeEnd = 0.0
        
        gradientMaskLayer.mask = progressLayer
        layer.addSublayer(gradientMaskLayer)
    }
    
    private func gradientMask() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        
        gradientLayer.locations = [0.0, 1.0]
        
//        255,20,147
        
        let colorTop: AnyObject = UIColor(red: 223/255, green: 34/255, blue: 140/255, alpha: 1).CGColor
        let colorBottom: AnyObject = UIColor(red: 255.0/255.0, green: 200.0/255.0, blue: 235.0/255.0, alpha: 1.0).CGColor
        let arrayOfColors: [AnyObject] = [colorTop, colorBottom]
        gradientLayer.colors = arrayOfColors
        

        
        return gradientLayer
    }
    
    func hideProgressView() {
        progressLayer.strokeEnd = 0.0
        progressLayer.removeAllAnimations()
        progressLabel.text = "Load content"
    }
    
    func animateProgressView(valueFinal: Float) {
        
        var percent: Int = Int(valueFinal * 100.0)
        
        progressLabel.textColor = UIColor(red: 223/255, green: 34/255, blue: 96/255, alpha: 1)
        
        progressLabel.text = String(format: "Loading %d %%", percent)
        
        progressLayer.strokeEnd = CGFloat(valueFinal)
        
        self.backgroundColor = UIColor(red: 19/255, green: 16/255, blue: 70/255, alpha: 1)
        
        progressLayer.strokeStart = CGFloat(0.0)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = CGFloat(0.0)
        animation.toValue = CGFloat(valueFinal)
        animation.duration = 0.2
        animation.delegate = self
        animation.removedOnCompletion = false
        animation.additive = false
        animation.fillMode = kCAFillModeBackwards
        progressLayer.addAnimation(animation, forKey: "strokeEnd")
    }
    
    
    
    func animateProgressView() {
        progressLabel.text = "Loading..."
        progressLayer.strokeEnd = 0.0
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = CGFloat(0.0)
        animation.toValue = CGFloat(0.5)
        animation.delegate = self
        animation.removedOnCompletion = false
        animation.additive = true
        animation.fillMode = kCAFillModeForwards
        progressLayer.addAnimation(animation, forKey: "strokeEnd")
    }
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        
        //progressLabel.text = "Done"
    }
}

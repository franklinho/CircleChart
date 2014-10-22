//
//  ViewController.swift
//  AnimationTests
//
//  Created by Franklin Ho on 10/20/14.
//  Copyright (c) 2014 Franklin Ho. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    let arcValues = [100,50,50]
    
    var colorValues : [UIColor]?
    
    var arcSize : Double?
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        colorValues = [UIColor.blueColor, UIColor.redColor, UIColor.orangeColor,UIColor.greenColor,UIColor.yellowColor, UIColor.cyanColor, UIColor.magentaColor, UIColor.purpleColor]

        arcSize = degreesToRadians(300)

        // Sample
        let radius = 100.0
        let franklinCenter = CGPointMake(CGFloat(self.screenSize.width/2.0) , CGFloat(self.screenSize.height/2) - CGFloat(radius))
        var arcStart = 3/4 * M_PI
        var arcEnd = 1.5 * M_PI


        self.createArc(franklinCenter, radius: radius, startAngle: arcStart, endAngle: M_PI/3, color: UIColor.grayColor().CGColor)
//        
//        self.createAnimatedArc(franklinCenter,radius: radius, startAngle: arcStart, endAngle: arcEnd, color: UIColor.blueColor().CGColor, duration: 1, beginTime: 0)
//        self.createAnimatedArc(franklinCenter,radius: radius, startAngle: arcEnd, endAngle: M_PI/3, color: UIColor.redColor().CGColor, duration: 1.0, beginTime: 1.0)

        self.animateArcs(arcValues, radius: radius, center: franklinCenter)
        
        

        
    }
    
    func animateArcs(arcValues:Array<Int>, radius: Double, center: CGPoint) {
        var sum = arcValues.reduce(0,+)
        println("Sum: \(sum)")
        var currentOffset = 0
        var currentStartAngle : Double?
        var currentEndAngle : Double?
        var currentDelay : Double = 0
        
        for var i = 0; i < arcValues.count; i++ {
            var duration = Double(CGFloat(arcValues[i])/CGFloat(sum))
            println("Duration: \(duration)")
            
            if currentEndAngle == nil {
                currentStartAngle = degreesToRadians(120)
            } else {
                currentStartAngle = currentEndAngle
            }
            
            println ("ArcSize: \(self.arcSize!)")
            println("ArcStart: \(currentStartAngle!)")
            println ("Portion: \(self.arcSize! * duration)")
//            println("TargetArcEnd: \(currentStartAngle! + self.arcSize! * duration)")

            
            if (CGFloat(self.arcSize!) * CGFloat(duration) + CGFloat(currentStartAngle!)) > CGFloat(M_PI*2) {
                currentEndAngle = Double((CGFloat(self.arcSize!) * CGFloat(duration) + CGFloat(currentStartAngle!)) - CGFloat(M_PI*2))
            } else {
                currentEndAngle = Double((CGFloat(self.arcSize!) * CGFloat(duration) + CGFloat(currentStartAngle!)))
            }

            println("Real end angle: \(currentEndAngle!)")
            
            
            var currentDelaySeconds = currentDelay as Double
            
            var time = dispatch_time(DISPATCH_TIME_NOW, Int64(currentDelay * Double(NSEC_PER_SEC)))
            
            
            
            var currentColor : CGColor?

            if i % 2 == 0 {
                currentColor = UIColor.blueColor().CGColor
            } else {
                currentColor = UIColor.redColor().CGColor
            }

            
            println("Current Delay: \(currentDelay)")
            self.createAnimatedArc(center, radius: radius, startAngle: currentStartAngle!, endAngle: currentEndAngle!, color: currentColor!, duration: duration, beginTime: currentDelay, z: CGFloat(-1 * i))


            
            



            
            currentDelay += duration
            
            

            

        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createArc(center: CGPoint, radius: Double, startAngle : Double, endAngle : Double, color : CGColor) {
        
        
        
        
        var arc = CAShapeLayer()
        arc.lineCap = kCALineCapRound
        arc.zPosition = -20
        
        
        
        
        arc.path = UIBezierPath(arcCenter: center, radius:
            CGFloat(radius), startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true).CGPath
        
        arc.fillColor = UIColor.whiteColor().CGColor
        arc.strokeColor = color
        arc.lineWidth = 10
        
        arc.strokeEnd = CGFloat(1.5 * M_PI)
        
        self.view.layer.addSublayer(arc)
        
        
    }

    
    
    func createAnimatedArc(center: CGPoint, radius: Double, startAngle : Double, endAngle : Double, color : CGColor, duration: Double, beginTime: Double, z: CGFloat) {

        
        
        
        var arc = CAShapeLayer()
        
        arc.zPosition = z
        
        
        arc.path = UIBezierPath(arcCenter: center, radius:
            CGFloat(radius), startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true).CGPath
        
        arc.fillColor = UIColor.clearColor().CGColor
        arc.strokeColor = color
        arc.lineCap = kCALineCapRound

        arc.lineWidth = 20
        
        var originalStrokeEnd = 0
        
        arc.strokeStart = 0
        arc.strokeEnd = 0
    

        
        var arcAnimation = CABasicAnimation(keyPath:"strokeEnd")
        arcAnimation.fromValue = NSNumber(double: 0)
        arcAnimation.toValue = NSNumber(double: 1)
        
        arcAnimation.duration = duration
        arcAnimation.beginTime = CFTimeInterval(CACurrentMediaTime() + beginTime)
        arcAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)


        arc.addAnimation(arcAnimation, forKey: "drawCircleAnimation")
        self.view.layer.addSublayer(arc)



        let delay = (duration + beginTime - 0.07) * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            var finalArc = CAShapeLayer()
            finalArc.zPosition = z
            finalArc.lineCap = kCALineCapRound
            finalArc.path = UIBezierPath(arcCenter: center, radius:
            CGFloat(radius), startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true).CGPath
        
            finalArc.fillColor = UIColor.clearColor().CGColor
            finalArc.strokeColor = color
            finalArc.lineWidth = 20
            
            var originalStrokeEnd = 0
            
            finalArc.strokeStart = 0
            finalArc.strokeEnd = 1
            self.view.layer.addSublayer(finalArc)
        })


    }
    
    

    func degreesToRadians(degrees: Double) -> Double {
        return degrees / 180.0 * M_PI
    }

    func radiansToDegrees(radians: Double) -> Double {
        return radians * (180.0 / M_PI)
    }
}


//
//-(void)animateThreeAnimation:(CALayer*)layer animation:(CABasicAnimation*)firstOne animation:(CABasicAnimation*)secondOne animation:(CABasicAnimation*)thirdOne{
//    firstOne.beginTime=0.0;
//    secondOne.beginTime=firstOne.duration;
//    thirdOne.beginTime=firstOne.duration+secondOne.duration;
//    
//    [layer addAnimation:firstOne forKey:@"firstAnim"];
//    [layer addAnimation:secondOne forKey:@"secondAnim"];
//    [layer addAnimation:thirdOne forKey:@"thirdAnim"];
//}
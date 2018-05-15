//
//  ViewController.swift
//  CMMotionDemo
//
//  Created by Simon on 2018/5/15.
//  Copyright © 2018年 sunshixiang. All rights reserved.
//

import UIKit
import CoreMotion

let ballWidth:CGFloat = 50

class ViewController: UIViewController,UIAccelerometerDelegate {

    var ball:UIImageView!
    var speedX:UIAccelerationValue = 0
    var speedY:UIAccelerationValue = 0
    var motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        //放一个小球在屏膜中央
        ball = UIImageView(image: UIImage(named: "ball"))
        ball.bounds = CGRect(x: 0, y: 0, width: ballWidth, height: ballWidth)
        ball.center = self.view.center
        self.view.addSubview(ball)
        
        motionManager.accelerometerUpdateInterval = 1/60
        
        if motionManager.isAccelerometerAvailable {
            let queue = OperationQueue.current
            
            motionManager.startAccelerometerUpdates(to: queue!) { (accelerometerData, error) in
                //动态设置小球位置
                self.speedX += accelerometerData!.acceleration.x
                self.speedY += accelerometerData!.acceleration.y
                
                var posX = self.ball.center.x + CGFloat(self.speedX)
                var posY = self.ball.center.y - CGFloat(self.speedY)
                
                //碰到边框反弹处理
                if posX <= ballWidth/2.0 {
                    posX = ballWidth/2.0
                    //碰到左边的边框后以0.4倍的速度反弹
                    self.speedX *= -0.2
                }else if posX >= self.view.bounds.size.width - ballWidth/2.0 {
                    posX = self.view.bounds.size.width - ballWidth/2.0
                    //碰到右边的边框后以0.4倍的速度反弹
                    self.speedX *= -0.2
                }
                
                if posY <= ballWidth/2.0 {
                    posY = ballWidth/2.0;
                    self.speedY *= -0.2
                }else if posY > self.view.bounds.size.height - ballWidth/2.0{
                    posY = self.view.bounds.size.height - ballWidth/2.0;
                    //碰到下面的边框以1.5倍的速度反弹
                    self.speedY *= -0.6
                }
                self.ball.center = CGPoint(x:posX, y:posY)
            }
        }
    }
}


//
//  RouletteView.swift
//  SmartHanYang
//
//  Created by ㅇㅈㅇ on 2018. 6. 15..
//  Copyright © 2018년 graph. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AudioToolbox

class RouletteViewController: UIViewController {
    
    var fromAngle: Double = 0.0
    
    
    @IBOutlet weak var rotateButton: UIButton!

    @IBOutlet weak var rotateImage: UIImageView!
    
    @IBOutlet var rotateResultView: UIView!
    @IBOutlet weak var rotateResultText: UITextField!
    @IBOutlet weak var backButton: UIButton!
    
    
    func stopAnimationForView(_ myView: UIView) {
        
        //Get the current transform from the layer's presentation layer
        //(The presentation layer has the state of the "in flight" animation)
        let transform = myView.layer.presentation()?.transform
        
        //Set the layer's transform to the current state of the transform
        //from the "in-flight" animation
        myView.layer.transform = transform!
        
        //Now remove the animation
        //and the view's layer will keep the current rotation
        myView.layer.removeAllAnimations()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //viewDidAppear , ViewWillAppear
        // Do any additional setup after loading the view, typically from a nib.
        
        
        rotateImage.layer.bounds.size.width = 400
        rotateImage.layer.bounds.size.height = rotateImage.layer.bounds.size.width
        
        
        
        let roulette = Roulette(frame: CGRect(x: rotateImage.layer.position.x , y: rotateImage.layer.position.y , width: rotateImage.layer.bounds.size.width, height: rotateImage.layer.bounds.size.height))
        
        rotateImage.image = roulette.asImage()
        
        rotateImage.layer.cornerRadius = 0.5 * rotateImage.bounds.size.width
        rotateImage.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func rotate(_ sender: Any) {
        let random = arc4random()
        
        let toAngle: Double = .pi * (Double(random) / Double(UINT32_MAX) * 14.0 + 6.0) // 6 ~ 20 random float number
        
        //        UIView.animate(withDuration: 0.5, animations: ({
        //            self.rotateImage.transform = CATransform3DGetAffineTransform(CATransform3DMakeRotation(CGFloat(Float.pi), 0.0, 0.0, 1.0))
        //        }))
        //
        //        UIView.animate(withDuration: 0.5, delay: 0.55, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in self.rotateImage.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI * 2))
        //        }, completion: nil)
        
        //        UIView.animate(withDuration: 0.5) {
        //            self.rotateImage.transform = self.rotateImage.transform.rotated(by: CGFloat.pi)
        //        }
        //
        //        rotateView(targetView: rotateImage, duration: 0.5)
        let rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
        //rotationAnimation.fromValue = NSNumber(value: .pi * 0.5)
        rotationAnimation.fromValue = NSNumber(value: self.fromAngle)
        rotationAnimation.toValue = NSNumber(value: toAngle)
        rotationAnimation.duration = 4.0
        rotationAnimation.repeatCount = 1
        rotationAnimation.isCumulative = true
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        self.rotateImage.layer.add(rotationAnimation, forKey: "rotationAnimation")
        
        
        
        let timer1 = Timer.scheduledTimer(withTimeInterval: 3.999, repeats: false) { (timer) in
            print("interval")
            print(texts.count - 1 - Int((fmod(toAngle, M_PI * 2) / (2 * M_PI) ) * Double(texts.count)))
            print(texts[texts.count - 1 - Int((fmod(toAngle, M_PI * 2) / (2 * M_PI) ) * Double(texts.count))])
            
            let transform = self.rotateImage.layer.presentation()?.transform
            self.rotateImage.layer.transform = transform!
            self.rotateImage.layer.removeAllAnimations()
            
            self.rotateButton.isEnabled = true
            self.fromAngle = fmod(toAngle, M_PI * 2) / (2 * M_PI)
        
            self.rotateResultText.text = texts[texts.count - 1 - Int((fmod(toAngle, M_PI * 2) / (2 * M_PI) ) * Double(texts.count))]
            self.view.addSubview(self.rotateResultView)
            self.rotateResultView.center = self.view.center
        }
        
        
        rotateButton.isEnabled = false
        print("rotate")
        
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.rotateResultView.removeFromSuperview()
    }
    
    
    @IBAction func resetButton(_ sender: Any) {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        //Get the current transform from the layer's presentation layer
        //(The presentation layer has the state of the "in flight" animation)
        let transform = rotateImage.layer.presentation()?.transform
        
        //Set the layer's transform to the current state of the transform
        //from the "in-flight" animation
        rotateImage.layer.transform = transform!
        
        //Now remove the animation
        //and the view's layer will keep the current rotation
        rotateImage.layer.removeAllAnimations()
        print("reset")
    }
}

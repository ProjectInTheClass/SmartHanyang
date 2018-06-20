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

    @IBOutlet weak var rotateButton: UIButton!
    
    var fromAngle: Double = 0.0

    @IBOutlet weak var centerView: UIView!
    
    @IBOutlet var rotateResultView: UIView!
    @IBOutlet weak var rotateResultText: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var resultLabel:UILabel!
    
    var roulette: Roulette?
    var ticks:[AVAudioPlayer] = []
    var tickIndex = 0
    
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
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.white
        super.viewWillAppear(animated)
        
        
        roulette = Roulette(texts:MealDataManager.shared.getMeals().map({ (m) -> String in
            return m.name
        }), frame: self.view.frame)
        
        if let r = roulette {
            self.centerView.insertSubview(r, at: 0)
            
            r.layer.bounds.size.width = self.view.frame.width*0.9
            r.layer.bounds.size.height = self.view.frame.width*0.9
            r.layer.position = CGPoint(x:self.view.frame.width*0.5, y:self.view.frame.width*0.5)
            r.drawView()
        }
        
        rotateButton.layer.cornerRadius = 0.5 * rotateButton.bounds.size.width
        
        updateResultLabel(str: "오늘의 식사는 무엇일까!")
        
        if let sound = NSDataAsset(name: "tick") {
            do {
                try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try! AVAudioSession.sharedInstance().setActive(true)
                for _ in 0...4 {
                    let tick = try AVAudioPlayer(data: sound.data, fileTypeHint:".wav")
                    ticks.append(tick)
                }
            }
            catch {
                print("error initializing AVAudioPlayer")
            }
        }
    }
    
    func playTick()
    {
        ticks[tickIndex].stop()
        ticks[tickIndex].play()
        tickIndex = (tickIndex+1)%ticks.count
    }
    
    @IBAction func rotate(_ sender: Any) {
        let random = arc4random()
        
        let toAngle: Double = .pi * (Double(random) / Double(UINT32_MAX) * 14.0 + 6.0) // 6 ~ 20 random float number
        
        let rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
        //rotationAnimation.fromValue = NSNumber(value: .pi * 0.5)
        rotationAnimation.fromValue = NSNumber(value: self.fromAngle)
        rotationAnimation.toValue = NSNumber(value: toAngle)
        rotationAnimation.duration = 4.0
        rotationAnimation.repeatCount = 1
        rotationAnimation.isCumulative = true
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        var prevIndex = 0
        
        self.roulette!.layer.add(rotationAnimation, forKey: "rotationAnimation")
        let t = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { (t) in
            let transform = self.roulette!.layer.presentation()?.transform
            
            let angle = Double(atan2(transform!.m12, transform!.m11))+Double.pi*2;
            let newIndex = self.roulette!.texts.count - 1 - Int((fmod(angle, Double.pi * 2) / (2 * Double.pi) ) * Double(self.roulette!.texts.count))
            if prevIndex != newIndex {
                let text = self.roulette!.texts[newIndex]
                self.updateResultLabel(str: text)
                self.playTick()
                prevIndex = newIndex
            }
        }
        
        playTick()
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        _ = Timer.scheduledTimer(withTimeInterval: 3.999, repeats: false) { (timer) in
            
            self.roulette!.layer.removeAllAnimations()
            
            let transform = self.roulette!.layer.presentation()?.transform
            self.roulette!.layer.transform = transform!
            
            self.rotateButton.isEnabled = true
            
            let angle = Double(atan2(transform!.m12, transform!.m11))+Double.pi*2;
            self.fromAngle = angle
        
            let text = self.roulette!.texts[self.roulette!.texts.count - 1 - Int((fmod(angle, Double.pi * 2) / (2 * Double.pi) ) * Double(self.roulette!.texts.count))]
            self.updateResultLabel(str: text)
            t.invalidate()
            
        }
        
        
        rotateButton.isEnabled = false
        print("rotate")
    }
    
    func updateResultLabel(str:String)
    {
        
        let strokeTextAttributes = [
            NSAttributedStringKey.strokeColor : UIColor.gray,
            NSAttributedStringKey.foregroundColor : UIColor.black,
            NSAttributedStringKey.strokeWidth : -3.0,
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 30)]
            as [NSAttributedStringKey : Any]
        
        resultLabel.attributedText = NSAttributedString(string: str, attributes: strokeTextAttributes)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.rotateResultView.removeFromSuperview()
    }
    
}

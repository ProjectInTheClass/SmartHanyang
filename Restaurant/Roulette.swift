//
//  Roulette.swift
//  SmartHanYang
//
//  Created by ㅇㅈㅇ on 2018. 6. 15..
//  Copyright © 2018년 graph. All rights reserved.
//

import Foundation
import UIKit

let exTexts1: [String] = ["학생식당", "행원파크", "제2학생생활관", "교직원식당", "알촌", "우리국밥", "술루루루루루","MapleStory", "PC방"]
let exTexts2: [String] = ["7080술집", "한양플라자", "몰라아아아아아아아ㅏ!"]



class Roulette: UIImageView {
    var texts: [String] = exTexts1
    var path: UIBezierPath!
    
    override init(frame: CGRect) {
        texts = [String]()
        super.init(frame: frame)
    }
    
    init(texts:[String], frame: CGRect) {
        self.texts = texts
        super.init(frame: frame)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        texts = Array<String>()
        super.init(coder: aDecoder)
    }
    
    public func drawView() {
        
        self.createRectangle()
        self.createPieces(texts: texts)
        self.createRing()
    }
    
    func createRectangle() {
        path = UIBezierPath()
        path.move(to: CGPoint(x:0.0, y:0.0))
        path.addLine(to: CGPoint(x:0.0, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: 0.0))
        path.close()
        
        UIColor.purple.setFill()
        path.fill()
    }
    
    func createRing() {
        
        let roulette_bg = UIImage(named: "roulette_bg")
        if let bg = roulette_bg {
            self.image = bg
        }
        
    }
    
    func getSize() -> CGFloat {
        return self.frame.size.width
    }
    func getCenter() -> CGPoint {
        return CGPoint(x:self.frame.size.width*0.5, y:self.frame.size.height * 0.5)
    }
    
    func createRotateTexts(text: String, angle: Float, unitAngle: Float) {
        let size = getSize()
        let center = getCenter()
        
        let textLayer = CATextLayer()
        textLayer.string = text
        textLayer.fontSize = size*0.09 / CGFloat(max(Double(text.count), 8)/8)
        textLayer.foregroundColor = UIColor.darkGray.cgColor
        
        
        textLayer.frame = CGRect(x: 0, y:0 /** CGFloat(sin(angle))*/, width: size, height: size * 0.1)
        textLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        textLayer.position = center
        
        let t = CATransform3DMakeTranslation(size*0.7, 0, 0)
        let r = CATransform3DMakeRotation(CGFloat(angle), 0.0, 0.0, 1.0)
        let s = CATransform3DMakeScale(0.5, 0.5, 1)
        textLayer.transform = CATransform3DConcat(CATransform3DConcat(t, r), s)
        self.layer.addSublayer(textLayer)
        
    }
    
    func drawWithBasePoint(basePoint: CGPoint, andAngle angle: CGFloat, andAttributes attributes: [String: AnyObject]) {
        
    }
    
    func createPieces(texts: [String]) {
        let number: Int = texts.count
        let size = getSize()
        let unitAngle: Float = Float.pi * 2 / Float(number)
        //start from up postion to clockwise ... -0.5 * pi//
        var angle: Float = -.pi * 0.5
        var textAngle = unitAngle / 2 - .pi * 0.5
        
        
        for i in 0..<number {
            
            let a = textAngle + unitAngle*0.5
            
            path = UIBezierPath()
            path.move(to: CGPoint(x:size*0.5,y:size*0.5))
            path.addLine(to: CGPoint(x: size*0.5 + size*CGFloat(cos(a))*0.4, y: size*0.5 +  size*CGFloat(sin(a))*0.4))
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = UIColor.lightGray.mul(n: 1.2).cgColor
            shapeLayer.lineWidth = 1
            
            self.layer.insertSublayer(shapeLayer, at: 0)
            
            createRotateTexts(text: texts[i], angle: textAngle, unitAngle: unitAngle)
            
            angle += unitAngle
            textAngle += unitAngle
        }
    }
}


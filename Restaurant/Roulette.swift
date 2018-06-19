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

var texts: [String] = restaurantsForRoulette.names

class Roulette: UIView {
    
    var path: UIBezierPath!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        
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
        
        UIColor.clear.setFill()
        path.fill()
    }
    
    
    
    func createRing() {
        path = UIBezierPath()
        var smallerSize = self.frame.size.width
        if(smallerSize > self.frame.size.height) {
            smallerSize = self.frame.size.height
        }
        
        path.addArc(withCenter: CGPoint(x: smallerSize / 2, y: smallerSize / 2), radius: smallerSize / 2, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        
        UIColor.white.setStroke()
        path.lineWidth = 3.0
        path.stroke()
    }
    
    
    
    func createRotateTexts(text: String, angle: Float, unitAngle: Float) {
        var smallerSize = self.frame.size.width
        if(smallerSize > self.frame.size.height) {
            smallerSize = self.frame.size.height
        }
        
        var textAngle = angle
        var textLayer = CATextLayer()
        textLayer.string = text
        textLayer.fontSize = 20.0
        textLayer.foregroundColor = UIColor.white.cgColor
        
        
        textLayer.frame = CGRect(x: (smallerSize / 2) /* CGFloat(cos(angle))*/, y: (smallerSize / 2) /** CGFloat(sin(angle))*/, width: smallerSize / 3, height: 25)
        textLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        textLayer.position = CGPoint(x: smallerSize / 2, y: smallerSize / 2)
        let t = CATransform3DMakeTranslation(smallerSize / 3, 0, 0)
        let r = CATransform3DMakeRotation(CGFloat(angle), 0.0, 0.0, 1.0)
        textLayer.transform = CATransform3DConcat(t, r)
        self.layer.addSublayer(textLayer)
        
    }
    
    func drawWithBasePoint(basePoint: CGPoint, andAngle angle: CGFloat, andAttributes attributes: [String: AnyObject]) {
        
    }
    
    func createPieces(texts: [String]) {
        let number: Int = texts.count
        var smallerSize = self.frame.size.width
        if(smallerSize > self.frame.size.height) {
            smallerSize = self.frame.size.height
        }
        let unitAngle: Float = Float.pi * 2 / Float(number)
        //start from up postion to clockwise ... -0.5 * pi//
        var angle: Float = -.pi * 0.5
        var textAngle = unitAngle / 2 - .pi * 0.5
        
        
        for i in 0..<number {
            path = UIBezierPath()
            path.move(to: CGPoint(x: smallerSize / 2, y: smallerSize / 2))
            path.addArc(withCenter: CGPoint(x: smallerSize / 2, y: smallerSize / 2), radius: smallerSize / 2, startAngle: CGFloat(angle), endAngle: CGFloat(angle + unitAngle), clockwise: true)
            path.close()
            
            Easy.GetGoodColor(n: i).setFill()
            path.fill()
            
            createRotateTexts(text: texts[i], angle: textAngle, unitAngle: unitAngle)
            
            angle += unitAngle
            textAngle += unitAngle
        }
    }
    
}

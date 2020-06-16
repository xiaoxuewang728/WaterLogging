//
//  ProgressView.swift
//  WaterLogging
//
//  Created by WangXiaoxue on 6/16/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

class ProgressView: UIView {

    private struct Constants {
        static let lineWidth: CGFloat = 8.0
        static let arcWidth: CGFloat = 80.0
        static var halfOfLineWidth : CGFloat {
            return lineWidth / 2
        }
    }
    var percentage: Double = 0.0 {
        didSet{
            if percentage <= 1.0 {
                setNeedsDisplay()
                print(percentage)
            } else {
                percentage = 1.0
            }
        }
    }

    private let outlineColor: UIColor = UIColor.cyan
    private let counterColor: UIColor = UIColor.lightGray

    override func draw (_ rec: CGRect){

        let center = CGPoint (x:bounds.width / 2, y:bounds.height / 2)
        let radius: CGFloat = max(bounds.width,bounds.height)
        let startAngle: CGFloat = 3 * .pi / 4
        let endAngle: CGFloat = .pi / 4
        let path = UIBezierPath(arcCenter: center,
                                radius: radius / 2 - Constants.arcWidth / 2,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)

        path.lineWidth = Constants.arcWidth
        counterColor.setStroke()
        path.stroke()

        //Outline
        let angleDifference: CGFloat = 2  * .pi - startAngle + endAngle
        let arcLenthPerGlass = angleDifference
        let outlineEndAngle = arcLenthPerGlass * CGFloat(percentage) + startAngle

        let outlinePath = UIBezierPath(arcCenter: center,
                                       radius: bounds.width / 2 - Constants.halfOfLineWidth,
                                       startAngle: startAngle,
                                       endAngle: outlineEndAngle,
                                       clockwise: true)
        outlinePath.addArc(withCenter: center,
                           radius: bounds.width / 2 - Constants.arcWidth + Constants.halfOfLineWidth,
                           startAngle: outlineEndAngle,
                           endAngle: startAngle,
                           clockwise: false)

        outlinePath.close()

        outlineColor.setStroke()
        outlinePath.lineWidth  = Constants.lineWidth
        outlinePath.stroke()
    }
}

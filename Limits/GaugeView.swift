//
//  GaugeView.swift
//  Limits
//
//  Created by Michael Epstein on 3/16/16.
//  Copyright © 2016 Michael Epstein. All rights reserved.
//

import Foundation

import UIKit


@IBDesignable
public class GaugeView : UIView {
	
	@IBInspectable
	public var value: CGFloat = 1.0 {
		didSet {
			if value > 1.0 {
				value = 1.0
			}
			else if value < 0 {
				value = 0
			}
			setNeedsDisplay()
		}
	}
	
	/// Colors
	@IBInspectable public var circleFillColor: UIColor = Cache.circleFillColor
	@IBInspectable public var circleStrokeColor: UIColor = Cache.circleStrokeColor
	@IBInspectable public var arcStrokeColor: UIColor = Cache.arcStrokeColor
	
	/// Stroke widths
	@IBInspectable public var circleStrokeWidth: CGFloat = 6
	@IBInspectable public var arcStrokeWidth: CGFloat = 10
	
	//// Cache
	private struct Cache {
		static let circleFillColor: UIColor = UIColor(red: 0.524, green: 0.524, blue: 0.524, alpha: 0.350)
		static let circleStrokeColor: UIColor = UIColor(red: 0.732, green: 0.732, blue: 0.732, alpha: 1.000)
		static let arcStrokeColor: UIColor = UIColor(red: 0.000, green: 0.553, blue: 1.000, alpha: 1.000)
	}
	
	public override func drawRect(rect: CGRect) {
		drawCircleGauge(frame: rect)
	}
	
	//// Drawing Methods
	private func drawCircleGauge(frame frame: CGRect = CGRectMake(30, 19, 100, 100)) {
		
		//// General Declarations
		
		//// Variable Declarations
		let endAngle: CGFloat = value >= 1 ? 0.1 : 360 * (1 - value)
		let startAngle: CGFloat = 0
		
		//// Circle Drawing
		let circlePath = UIBezierPath(ovalInRect: CGRectMake(frame.minX + circleStrokeWidth, frame.minY + circleStrokeWidth, frame.width - (2 * circleStrokeWidth), frame.height - (2 * circleStrokeWidth)))
		circleFillColor.setFill()
		circlePath.fill()
		circleStrokeColor.setStroke()
		circlePath.lineWidth = circleStrokeWidth
		circlePath.stroke()
		
		
		//// Arc Drawing
		let arcRect = CGRectMake(frame.minX + circleStrokeWidth, frame.minY + circleStrokeWidth, frame.width - (2 * circleStrokeWidth), frame.height - (2 * circleStrokeWidth))
		let arcPath = UIBezierPath()
		arcPath.addArcWithCenter(CGPointMake(0.0, 0.0), radius: arcRect.width / 2, startAngle: -startAngle * CGFloat(M_PI)/180, endAngle: -endAngle * CGFloat(M_PI)/180, clockwise: true)
		
		var arcTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(arcRect), CGRectGetMidY(arcRect))
		arcTransform = CGAffineTransformScale(arcTransform, 1, arcRect.height / arcRect.width)
		arcPath.applyTransform(arcTransform)
		
		arcStrokeColor.setStroke()
		arcPath.lineWidth = arcStrokeWidth
		arcPath.stroke()
	}
}
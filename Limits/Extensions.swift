//
//  Extensions.swift
//  Limits
//
//  Created by Michael Epstein on 3/16/16.
//  Copyright © 2016 Michael Epstein. All rights reserved.
//

import Foundation
import UIKit
import SwiftlySalesforce
import BRYXBanner

extension UIColor {
	
	/**
	From: https://www.hackingwithswift.com/example-code/uicolor/how-to-convert-a-hex-color-to-a-uicolor
	*/
	public convenience init?(hexString: String) {
		
		let r, g, b, a: CGFloat
		
		if hexString.hasPrefix("#") {
			let start = hexString.startIndex.advancedBy(1)
			let hexColor = hexString.substringFromIndex(start)
			
			if hexColor.characters.count == 8 {
				let scanner = NSScanner(string: hexColor)
				var hexNumber: UInt64 = 0
				
				if scanner.scanHexLongLong(&hexNumber) {
					r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
					g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
					b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
					a = CGFloat(hexNumber & 0x000000ff) / 255
					
					self.init(red: r, green: g, blue: b, alpha: a)
					return
				}
			}
		}
		
		return nil
	}
}

extension Banner {
	
	public convenience init(error: ErrorType, title: String = "Error", onDismiss: (() -> ())? = nil) {
		
		let msg: String
		if let s = (error as NSError?)?.userInfo[NSLocalizedDescriptionKey] as? String {
			msg = s
		}
		else if let s = (error as? SwiftlySalesforce.Error)?.description {
			msg = s
		}
		else {
			msg = String(error)
		}
		let subtitle = "\(msg)\n(Tap to dismiss)"
		self.init(title: title, subtitle: subtitle, image: nil, backgroundColor: UIColor(hexString: "#CC0000FF")!)
		self.didDismissBlock = onDismiss
	}
}

extension NSDateFormatter {
	
	public static func timestampFormatter() -> NSDateFormatter {
		let formatter = NSDateFormatter()
		formatter.timeZone = NSTimeZone()
		formatter.dateStyle = .ShortStyle
		formatter.timeStyle = .MediumStyle
		return formatter
	}
}
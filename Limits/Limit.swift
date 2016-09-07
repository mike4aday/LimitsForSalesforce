//
//  Limit.swift
//  Limits
//
//  Created by Michael Epstein on 3/15/16.
//  Copyright © 2016 Michael Epstein. All rights reserved.
//

import Foundation
import UIKit


public struct Limit {
	
	let name: String
	let max: Int
	let remaining: Int
	
	public var remainingFraction: Float {
		return Float(remaining) / Float(max)
	}
	
	public var maximum: Int {
		return max
	}
}


// MARK: - Extension that handles presenting Limit-related information
extension Limit {
	
	typealias LimitInfo = (name: String, label: String, description: String, units: String?)
	
	enum LimitState {
		
		case High, Medium, Low
		
		static let lowValueColor: UIColor = UIColor(hexString: "#FF2D55FF")!
		static let mediumValueColor: UIColor = UIColor(hexString: "#FFCC00FF")!
		static let highValueColor: UIColor = UIColor(hexString: "#4CD964FF")!
		
		var color: UIColor {
			switch self {
			case .High :
				return LimitState.highValueColor
			case .Medium:
				return LimitState.mediumValueColor
			case .Low:
				return LimitState.lowValueColor
			}
		}
	}
	
	var state: LimitState {
		if remainingFraction < 0.33 {
			return .Low
		}
		else if remainingFraction < 0.66 {
			return .Medium
		}
		else {
			return .High
		}
	}

	var label: String? {
		return Limit.info?[name]?.label
	}
	
	var description: String? {
		return Limit.info?[name]?.description
	}
	
	public var units: String? {
		return Limit.info?[name]?.units
	}
	
	var percentString: String {
		return "\(Int(round(remainingFraction*100)))%"
	}
	
	var usageString: String {
		let unitsString = units == nil ? "" : " \(units!)"
		//TODO: localize
		return "\(remaining) of \(max)\(unitsString) remaining"
	}
	
	
	/**
	Localized limit information from plist file
	*/
	static var info: [String: LimitInfo]? = {
		
		guard let path = NSBundle.mainBundle().pathForResource("Limits", ofType: "plist"), ary = NSArray(contentsOfFile: path) else {
			NSLog("Unable to read Limits.plist")
			return nil
		}
		
		var retVal = [String: LimitInfo]()
		for item in ary {
			let units: String? = item["units"] as? String
			if let name = item["name"] as? String, label = item["label"] as? String, desc = item["description"] as? String {
				retVal[name] =  (name: name, label: label, description: desc, units: units)
			}
		}
		return retVal
	}()
}
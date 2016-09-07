//
//  Site.swift
//  Limits
//
//  Created by Michael Epstein on 6/25/16.
//  Copyright © 2016 Michael Epstein. All rights reserved.
//

import Foundation


public struct Site {
	
	enum LimitName {
		case dailyBandwidthLimit
		case dailyRequestTimeLimit
	}
	
	let name: String
	let masterLabel: String
	let dailyBandwidthLimit: Limit
	let dailyRequestTimeLimit: Limit
	
	init?(fromJSON JSON: [String: AnyObject]) {
		
		guard let
			name = JSON["Name"] as? String,
			masterLabel = JSON["MasterLabel"] as? String,
			dailyBandwidthMax = JSON["DailyBandwidthLimit"] as? Int,
			dailyBandwidthUsed = JSON["DailyBandwidthUsed"] as? Double,
			dailyRequestTimeMax = JSON["DailyRequestTimeLimit"] as? Int,
			dailyRequestTimeUsed = JSON["DailyRequestTimeUsed"] as? Double
		else {
			return nil
		}
		self.name = name 
		self.masterLabel = masterLabel
		self.dailyBandwidthLimit = Limit(name: "DailyBandwidthLimit", max: dailyBandwidthMax, remaining: dailyBandwidthMax - Int(round(dailyBandwidthUsed)))
		self.dailyRequestTimeLimit = Limit(name: "DailyRequestTimeLimit", max: dailyRequestTimeMax, remaining: dailyRequestTimeMax - Int(round(dailyRequestTimeUsed)))
	}
}
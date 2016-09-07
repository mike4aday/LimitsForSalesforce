//
//  LimitTableViewCell.swift
//  Limits
//
//  Created by Michael Epstein on 3/16/16.
//  Copyright © 2016 Michael Epstein. All rights reserved.
//

import UIKit
import Foundation

@IBDesignable
class LimitTableViewCell: UITableViewCell {
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var percentLabel: UILabel!
	@IBOutlet weak var usageLabel: UILabel!
	@IBOutlet weak var gaugeView: GaugeView!
	
	var limit: Limit! {
		
		didSet {
			titleLabel.text = limit.label ?? limit.name
			percentLabel.text = limit.percentString
			usageLabel.text = limit.usageString
			gaugeView.value = CGFloat(limit.remainingFraction)
			gaugeView.arcStrokeColor = limit.state.color
		}
	}
}

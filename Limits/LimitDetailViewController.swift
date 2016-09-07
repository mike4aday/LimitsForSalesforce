//
//  LimitDetailViewController.swift
//  Limits
//
//  Created by Michael Epstein on 3/17/16.
//  Copyright © 2016 Michael Epstein. All rights reserved.
//

import UIKit

class LimitDetailViewController: UIViewController {

	
	var limit: Limit!
		
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var usageLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		titleLabel.text = limit.label
		descriptionLabel.text = limit.description
		usageLabel.text = limit.usageString
	}
}

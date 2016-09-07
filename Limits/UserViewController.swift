//
//  UserViewController.swift
//  Limits
//
//  Created by Michael Epstein on 3/19/16.
//  Copyright © 2016 Michael Epstein. All rights reserved.
//

import UIKit
import SwiftlySalesforce
import PromiseKit
import BRYXBanner

class UserViewController: UIViewController {

	@IBOutlet weak var usernameLabel: UILabel!
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		if let user = Model.sharedInstance.userCache.data {
			self.usernameLabel.text = user.username
		}
		else {
			firstly {
				Model.sharedInstance.userCache.refresh()
			}.then {
				self.usernameLabel.text = Model.sharedInstance.userCache.data?.username
			}.error {
				(error) -> () in
				self.usernameLabel.text = "(Unable to load username)"
				Banner(error: error, title: "Error loading user information").show(duration: 2.40)
			}
		}
	}
}

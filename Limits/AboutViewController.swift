//
//  AboutViewController.swift
//  Limits
//
//  Created by Michael Epstein on 3/19/16.
//  Copyright © 2016 Michael Epstein. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

	@IBAction func twitterButtonTapped(sender: AnyObject) {
		if let url = NSURL(string: "twitter://mike4aday") {
			UIApplication.sharedApplication().openURL(url)
		}
	}
}

//
//  AppDelegate.swift
//  Limits
//
//  Created by Michael Epstein on 3/13/16.
//  Copyright © 2016 Michael Epstein. All rights reserved.
//

import UIKit
import SwiftlySalesforce
import PromiseKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LoginViewPresentable {

	var window: UIWindow?
	let consumerKey = "<YOUR CONSUMER KEY HERE>"
	let redirectURL = NSURL(string: "limits://authorized")!


	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		
		// Swiftly Salesforce config
		OAuth2Manager.sharedInstance.configureWithConsumerKey(consumerKey, redirectURL: redirectURL)
		OAuth2Manager.sharedInstance.authenticationDelegate = self
		
		// Background fetch config
		application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
		let settings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Badge, categories: nil)
		UIApplication.sharedApplication().registerUserNotificationSettings(settings)
		
		return true
	}
	
	func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
		handleRedirectURL(url)
		return true
	}

	func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
		
		guard let _ = application.currentUserNotificationSettings()?.types.contains([.Badge]) else {
			application.applicationIconBadgeNumber = 0
			completionHandler(.Failed)
			return
		}
		
		// Refresh model and update badge
		when(Model.sharedInstance.limitCache.refresh(), Model.sharedInstance.siteCache.refresh()).then {
			
			() -> () in
			
			guard let orgLimits = Model.sharedInstance.limitCache.data, sites = Model.sharedInstance.siteCache.data else {
				application.applicationIconBadgeNumber = 0
				completionHandler(.Failed)
				return
			}
			
			// Count low org limits
			var n = (orgLimits.filter { $0.state == Limit.LimitState.Low }).count
			
			// Add low Site limits
			for site in sites {
				if site.dailyBandwidthLimit.state == .Low {
					n += 1
				}
				if site.dailyRequestTimeLimit.state == .Low {
					n += 1
				}
			}
			
			// Update badge
			application.applicationIconBadgeNumber = n
			
			completionHandler(.NewData)
			
		}.error {
			(error) -> () in
			application.applicationIconBadgeNumber = 0
			completionHandler(.Failed)
		}
	}
}


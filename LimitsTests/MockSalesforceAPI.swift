//
//  MockSalesforceAPI.swift
//  Limits
//
//  Created by Michael Epstein on 7/9/16.
//  Copyright © 2016 Michael Epstein. All rights reserved.
//

import Foundation
import PromiseKit


internal class MockSalesforceAPI {
	
	static let sharedInstance = MockSalesforceAPI()
	
	
	func readLimits() -> Promise<AnyObject> {
		
		return Promise<AnyObject> {
			
			(fulfill, reject) -> () in
			
			guard let path = NSBundle.mainBundle().pathForResource("MockLimits", ofType: "json"),
				jsonData = NSData(contentsOfFile: path),
				jsonResult = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary else {
					
					reject(NSError(domain: "MockSalesforceAPI", code: 101, userInfo: nil))
					return
			}
			fulfill(jsonResult)
		}
	}
	
	func readSites() -> Promise<AnyObject> {
		
		return Promise<AnyObject> {
			
			(fulfill, reject) -> () in
			
			guard let path = NSBundle.mainBundle().pathForResource("MockSites", ofType: "json"),
				jsonData = NSData(contentsOfFile: path),
				jsonResult = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary else {
					
				reject(NSError(domain: "MockSalesforceAPI", code: 100, userInfo: nil))
				return
			}
			fulfill(jsonResult)
		}
	}
}
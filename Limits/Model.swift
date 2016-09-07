//
//  AppModel.swift
//  Limits
//
//  Created by Michael Epstein on 7/9/16.
//  Copyright © 2016 Michael Epstein. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftlySalesforce

public class Model {
	
	public static let sharedInstance = Model()

	public let limitCache: Cache<[Limit]>
	public let siteCache: Cache<[Site]>
	public let userCache: Cache<User>
	
	private init() {
		
		// Limit Cache
				
		let limitRetriever = {
			() -> Promise<AnyObject> in
			SalesforceAPI.Limits.request()
		}
		
		let limitResultHandler = {
			
			(result: AnyObject) throws -> [Limit] in
			
			guard let items = result as? [String: [String: Int]] else {
				// Server sent data that couldn't be parsed as limits
				throw NSError(domain: NSURLErrorDomain, code: NSURLError.BadServerResponse.rawValue, userInfo: nil)
			}
			var limits = [Limit]()
			for (name, values) in items {
				if let max = values["Max"], remaining = values["Remaining"] {
					limits.append(Limit(name: name, max: max, remaining: remaining))
				}
			}
			return limits.sort {  ($0.label ?? $0.name) < ($1.label ?? $1.name) }
		}
		
		limitCache = Cache<[Limit]>(retriever: limitRetriever, resultHandler: limitResultHandler)
		
		
		// Site Cache
		
		let siteRetriever = {
			() -> Promise<AnyObject> in
			SalesforceAPI.Query(soql: "SELECT Name,DailyBandwidthLimit,DailyBandwidthUsed,DailyRequestTimeLimit,DailyRequestTimeUsed,Description,MasterLabel,Status FROM Site WHERE Status = 'Active' ORDER BY MasterLabel ASC").request()
		}
		
		let siteResultHandler = {
			
			(result: AnyObject) throws -> [Site] in
			
			guard let records = result["records"] as? [[String: AnyObject]] else {
				throw NSError(domain: NSURLErrorDomain, code: NSURLError.BadServerResponse.rawValue, userInfo: nil)
			}
			var sites = [Site]()
			for record in records {
				if let site = Site(fromJSON: record) {
					sites.append(site)
				}
			}
			return sites
		}
		
		siteCache = Cache<[Site]>(retriever: siteRetriever, resultHandler: siteResultHandler)
		
		
		// User Cache
		
		let userRetriever = {
			() -> Promise<AnyObject> in
			SalesforceAPI.Identity.request()
		}
		
		let userResultHandler = {
			
			(result: AnyObject) throws -> User in
			
			guard let username = result["username"] as? String, displayName = result["display_name"] as? String else {
				throw NSError(domain: NSURLErrorDomain, code: NSURLError.BadServerResponse.rawValue, userInfo: nil)
			}
			return User(username: username, displayName: displayName)
		}
		
		userCache = Cache<User>(retriever: userRetriever, resultHandler: userResultHandler)
	}
	
	public func clear() {
		limitCache.clear()
		siteCache.clear()
		userCache.clear()
	}
}
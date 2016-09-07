//
//  Cache.swift
//  Limits
//
//  Created by Michael Epstein on 7/9/16.
//  Copyright © 2016 Michael Epstein. All rights reserved.
//

import Foundation
import PromiseKit


public class Cache<Data> {
	
	typealias Retriever = () -> Promise<AnyObject>
	typealias ResultHandler = (AnyObject) throws -> Data
	
	private(set) var data: Data? {
		didSet {
			timestamp = NSDate()
		}
	}
	
	private(set) var timestamp: NSDate?
	
	var isEmpty: Bool {
		return data == nil
	}
	
	// Closure used to retrieve data from Salesforce
	var retriever: Retriever
	
	// Closure that handles result from Salesforce
	var resultHandler: ResultHandler
	
	init(retriever: Retriever, resultHandler: ResultHandler) {
		self.retriever = retriever
		self.resultHandler = resultHandler
	}
	
	func clear() {
		data = nil
	}
	
	func refresh() -> Promise<Void> {
		
		return Promise<Void> {
			
			(fulfill, reject) -> () in
			
			retriever().then {
				(result) -> () in
				self.data = try self.resultHandler(result)
				fulfill()
			}.error {
				(error) -> () in
				reject(error)
			}
		}
	}
}
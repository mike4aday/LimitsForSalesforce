//
//  SiteTest.swift
//  Limits
//
//  Created by Michael Epstein on 7/11/16.
//  Copyright © 2016 Michael Epstein. All rights reserved.
//

import XCTest
import PromiseKit
@testable import Limits

class SiteTest: XCTestCase {
    
    override func setUp() {
		
		super.setUp()
		
		// Replace model caches' 'retriever' closures with mock version
		Model.sharedInstance.limitCache.retriever = {
			() -> Promise<AnyObject> in
			return MockSalesforceAPI.sharedInstance.readLimits()
		}
		Model.sharedInstance.siteCache.retriever = {
			() -> Promise<AnyObject> in
			return MockSalesforceAPI.sharedInstance.readSites()
		}
		
		// Reload model with mock data
		Model.sharedInstance.clear()
		let expectation = expectationWithDescription("Refresh")
		when(Model.sharedInstance.limitCache.refresh(), Model.sharedInstance.siteCache.refresh()).then {
			expectation.fulfill()
		}
		waitForExpectationsWithTimeout(2.0, handler: nil)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testSites() {
		
		guard let sites = Model.sharedInstance.siteCache.data else {
			XCTFail("No Sites loaded")
			return
		}
		
		XCTAssert(sites.count == 6)
		
		// Site 1
		var site = sites[0]
		XCTAssertEqual(site.name, "My_Site")
		XCTAssertEqual(site.masterLabel, "My Force.com Site")
		XCTAssertEqual(site.dailyBandwidthLimit.max, 40960)
		XCTAssertEqual(site.dailyBandwidthLimit.remaining, 40960 - Int(round(31206.3)))
		XCTAssertEqual(site.dailyRequestTimeLimit.max, 3600)
		XCTAssertEqual(site.dailyRequestTimeLimit.remaining, 3600 - Int(round(1011.3545654)))
		XCTAssertEqual(site.dailyRequestTimeLimit.name, "DailyRequestTimeLimit")
		XCTAssertEqual(site.dailyRequestTimeLimit.label, "Daily Request Time Limit")
		XCTAssertEqual(site.dailyBandwidthLimit.name, "DailyBandwidthLimit")
		XCTAssertEqual(site.dailyBandwidthLimit.label, "Daily Bandwidth Limit")
		
		site = sites[5]
		XCTAssertEqual(site.name, "Partners_21")
		XCTAssertEqual(site.masterLabel, "Partners 2")
		XCTAssertEqual(site.dailyBandwidthLimit.max, 40960)
		XCTAssertEqual(site.dailyBandwidthLimit.remaining, 40960 - Int(round(0.0)))
		XCTAssertEqual(site.dailyRequestTimeLimit.max, 3600)
		XCTAssertEqual(site.dailyRequestTimeLimit.remaining, 3600 - Int(round(0.0)))
		XCTAssertEqual(site.dailyRequestTimeLimit.name, "DailyRequestTimeLimit")
		XCTAssertEqual(site.dailyRequestTimeLimit.label, "Daily Request Time Limit")
		XCTAssertEqual(site.dailyBandwidthLimit.name, "DailyBandwidthLimit")
		XCTAssertEqual(site.dailyBandwidthLimit.label, "Daily Bandwidth Limit")
	}
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}

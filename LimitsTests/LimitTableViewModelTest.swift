//
//  LimitTableViewModelTest.swift
//  Limits
//
//  Created by Michael Epstein on 7/12/16.
//  Copyright © 2016 Michael Epstein. All rights reserved.
//

import XCTest
import PromiseKit
@testable import Limits

class LimitTableViewModelTest: XCTestCase {
    
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
    
	func testViewModel() {
		
		guard let limits = Model.sharedInstance.limitCache.data, sites = Model.sharedInstance.siteCache.data else {
			XCTFail("No limits or sites")
			return
		}
		
		let viewModel = LimitTableViewModel(orgLimits: limits, sites: sites)
		XCTAssertEqual(viewModel.table(stateFilter: nil).sections.count, 7)
		
		// Low limits
		var lowCount = 0
		for section in viewModel.table(stateFilter: nil).sections {
			for row in section.rows {
				if row.state == .Low {
					lowCount += 1
				}
			}
		}
		XCTAssertEqual(lowCount, viewModel.table(stateFilter: .Low).totalRows)
		XCTAssertEqual(viewModel.table(stateFilter: .Low).sections.count, 2)
		XCTAssertEqual(viewModel.table(stateFilter: .Low).sections[0].rows.count, 3)
		XCTAssertEqual(viewModel.table(stateFilter: .Low).sections[1].rows.count, 1)
		
		//TODO: test other sections
	}
}

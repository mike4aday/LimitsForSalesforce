//
//  LimitTests.swift
//  Limits
//
//  Created by Michael Epstein on 3/26/16.
//  Copyright © 2016 Michael Epstein. All rights reserved.
//

import XCTest
@testable import Limits

class LimitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
	func testHighLimitProperties() {
		
		// Given
		let limit = Limit(name: "SingleEmail", max: 1000, remaining: 985)
		
		// Then
		if case Limit.LimitState.High = limit.state {
			// Good
		}
		else {
			XCTFail()
		}
		XCTAssertEqual(limit.label, "Single Emails")
		XCTAssertNil(limit.units)
		XCTAssertEqual(limit.remainingFraction, 0.985)
		XCTAssertEqual(limit.percentString, "99%")
		XCTAssertEqual(limit.state.color, Limit.LimitState.highValueColor)
	}
	
	func testMediumLimitProperties() {
		
		// Given
		let limit = Limit(name: "SingleEmail", max: 1000, remaining: 659)
		
		// Then
		if case Limit.LimitState.Medium = limit.state {
			// Good
		}
		else {
			XCTFail()
		}
		XCTAssertEqual(limit.label, "Single Emails")
		XCTAssertNil(limit.units)
		XCTAssertEqual(limit.remainingFraction, 0.659)
		XCTAssertEqual(limit.percentString, "66%")
		XCTAssertEqual(limit.state.color, Limit.LimitState.mediumValueColor)
	}
}

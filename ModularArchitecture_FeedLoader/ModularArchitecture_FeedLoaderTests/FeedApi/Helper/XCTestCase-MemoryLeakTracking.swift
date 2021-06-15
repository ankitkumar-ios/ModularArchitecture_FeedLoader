//
//  XCTestCase-MemoryLeakTracking.swift
//  ModularArchitecture_FeedLoaderTests
//
//  Created by Ankit on 15/06/21.
//

import XCTest

extension XCTestCase {
	
	
	func trackForMemoryLeaks(_ instance: AnyObject, file:StaticString = #file, line:UInt = #line){
		addTeardownBlock { [weak instance] in
			XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak", file: file, line: line)
		}
	}
	
}

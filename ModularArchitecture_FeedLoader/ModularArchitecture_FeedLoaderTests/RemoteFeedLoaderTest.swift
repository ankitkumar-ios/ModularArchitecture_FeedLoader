//
//  RemoteFeedLoaderTest.swift
//  ModularArchitecture_FeedLoaderTests
//
//  Created by Ankit on 02/06/21.
//

import XCTest

class RemoteFeedLoader {
	func load() {
		HTTPClient.shared.requestedURL = URL.init(string: "https://new-url.com")
	}
}

class HTTPClient {
	static let shared = HTTPClient()
	private init() {}
	
	var requestedURL: URL?
}

class RemoteFeedLoaderTest: XCTestCase {

	func test_init_doesnotRequestDataFromURL(){
		let client = HTTPClient.shared
		let _ = RemoteFeedLoader()
		
		XCTAssertNil(client.requestedURL)
	}

	func test_load_requestDataFromURL(){
		let client = HTTPClient.shared
		
		let sut = RemoteFeedLoader()
		sut.load()
		
		XCTAssertNotNil(client.requestedURL)
	}
	
}

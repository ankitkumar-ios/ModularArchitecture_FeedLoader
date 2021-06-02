//
//  RemoteFeedLoaderTest.swift
//  ModularArchitecture_FeedLoaderTests
//
//  Created by Ankit on 02/06/21.
//

import XCTest

class RemoteFeedLoader {
	func load() {
		HTTPClient.shared.get(from:URL.init(string: "https://new-url.com")!)
	}
}

class HTTPClient {
	static var shared = HTTPClient()
	
	func get(from url: URL){}
	
}

class HTTPClientSpy: HTTPClient {
	var requestedURL: URL?

	override func get(from url: URL){
		requestedURL = url
	}

}


class RemoteFeedLoaderTest: XCTestCase {

	func test_init_doesnotRequestDataFromURL(){
		let client = HTTPClientSpy()
		HTTPClient.shared = client
		let _ = RemoteFeedLoader()
		
		XCTAssertNil(client.requestedURL)
	}

	func test_load_requestDataFromURL(){
		let client = HTTPClientSpy()
		HTTPClient.shared = client
		
		let sut = RemoteFeedLoader()
		sut.load()
		
		XCTAssertNotNil(client.requestedURL)
	}
	
}

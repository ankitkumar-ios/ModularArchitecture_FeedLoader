//
//  RemoteFeedLoaderTest.swift
//  ModularArchitecture_FeedLoaderTests
//
//  Created by Ankit on 02/06/21.
//

import XCTest

class RemoteFeedLoader {
	let client: HTTPClient
	init(client: HTTPClient) {
		self.client = client
	}
	
	func load() {
		client.get(from:URL.init(string: "https://new-url.com")!)
	}
}

protocol HTTPClient {
	func get(from url: URL)
}

class HTTPClientSpy: HTTPClient {
	var requestedURL: URL?

	func get(from url: URL){
		requestedURL = url
	}

}


class RemoteFeedLoaderTest: XCTestCase {

	func test_init_doesnotRequestDataFromURL(){
		let client = HTTPClientSpy()
		let _ = RemoteFeedLoader(client: client)
		
		XCTAssertNil(client.requestedURL)
	}

	func test_load_requestDataFromURL(){
		let client = HTTPClientSpy()
		let sut = RemoteFeedLoader(client: client)
		sut.load()
		
		XCTAssertNotNil(client.requestedURL)
	}
	
}

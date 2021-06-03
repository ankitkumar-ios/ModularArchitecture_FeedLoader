//
//  RemoteFeedLoaderTest.swift
//  ModularArchitecture_FeedLoaderTests
//
//  Created by Ankit on 02/06/21.
//

import XCTest
import ModularArchitecture_FeedLoader


class RemoteFeedLoaderTest: XCTestCase {

	func test_init_doesnotRequestDataFromURL(){
		let (_,client) = makeSUT()
		
		XCTAssertNil(client.requestedURL)
	}

	func test_load_requestsDataFromURL(){
		let url = URL(string:"https://new-given-url.com")!
		let (sut,client) = makeSUT(url: url)
		sut.load()
		
		XCTAssertEqual(client.requestedURL, url)
	}
	

	func test_loadTwice_requestsDataFromURLTwice(){
		let url = URL(string:"https://new-given-url.com")!
		let (sut,client) = makeSUT(url: url)
		sut.load()
		sut.load()
		
		XCTAssertEqual(client.requestedURLs, [url, url])
	}
	
	
	//MARK: - Helper
	private func makeSUT(url: URL = URL(string: "https://new-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
		let client = HTTPClientSpy()
		let sut = RemoteFeedLoader(url: url, client: client)
		return (sut, client)
	}
	
	private class HTTPClientSpy: HTTPClient {
		var requestedURL: URL?
		var requestedURLs = [URL]()
		
		func get(from url: URL){
			requestedURL = url
			requestedURLs.append(url)
		}

	}
	
}

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
		
		XCTAssertTrue(client.requestedURLs.isEmpty)
	}

	func test_load_requestsDataFromURL(){
		let url = URL(string:"https://new-given-url.com")!
		let (sut,client) = makeSUT(url: url)
		sut.load()
		
		XCTAssertEqual(client.requestedURLs, [url])
	}
	

	func test_loadTwice_requestsDataFromURLTwice(){
		let url = URL(string:"https://new-given-url.com")!
		let (sut,client) = makeSUT(url: url)
		sut.load()
		sut.load()
		
		XCTAssertEqual(client.requestedURLs, [url, url])
	}
	
	
	func test_load_deliversErrorOnClientError(){
		let (sut, client) = makeSUT()
		client.error = NSError.init(domain: "Test", code: 0, userInfo: nil)
		
		var capturedErrors = [RemoteFeedLoader.Error]()
		
		sut.load {capturedErrors.append($0)}
		
		XCTAssertEqual(capturedErrors, [.connectivityError])
	}
	
	//MARK: - Helper
	private func makeSUT(url: URL = URL(string: "https://new-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
		let client = HTTPClientSpy()
		let sut = RemoteFeedLoader(url: url, client: client)
		return (sut, client)
	}
	
	private class HTTPClientSpy: HTTPClient {
		var requestedURLs = [URL]()
		var error: Error?
		
		func get(from url: URL, completion: @escaping (Error)-> Void){
			if let error = error {
				completion(error)
			}
			requestedURLs.append(url)
		}

	}
	
}

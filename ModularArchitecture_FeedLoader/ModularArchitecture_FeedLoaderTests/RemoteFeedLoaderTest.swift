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
		sut.load{ _ in }
		
		XCTAssertEqual(client.requestedURLs, [url])
	}
	

	func test_loadTwice_requestsDataFromURLTwice(){
		let url = URL(string:"https://new-given-url.com")!
		let (sut,client) = makeSUT(url: url)
		sut.load{ _ in }
		sut.load{ _ in }
		
		XCTAssertEqual(client.requestedURLs, [url, url])
	}
	
	
	func test_load_deliversErrorOnClientError(){
		let (sut, client) = makeSUT()

		expect(sut, toCompleteWith: .failure(.connectivityError)) {
			let clientError = NSError.init(domain: "Test", code: 0, userInfo: nil)
			client.complete(with: clientError)
		}
	}
	
	
	func test_load_deliversErrorOnNo200HTTPResponse(){
		let (sut, client) = makeSUT()
		let samples = [199, 201, 300, 400, 500]
		
		samples.enumerated().forEach { index, code in
			expect(sut, toCompleteWith: .failure(.invalidData)) {
				let json = makeItemJSON([])
				client.complete(withStatusCode: code, data: json, at: index)
			}
		}
	}
	
	func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON(){
		let (sut, client) = makeSUT()

		expect(sut, toCompleteWith: .failure(.invalidData)) {
			let invalidJSON = Data("InvalidJSON".utf8)
			client.complete(withStatusCode: 200, data: invalidJSON)
		}
		
	}
	
	func test_load_deliverNoItemsOn200HTTPResponseWithEmptyJSONList(){
		let (sut, client) = makeSUT()

		expect(sut, toCompleteWith: .success([])) {
			let emptyListData = Data("{\"items\":[]}".utf8)
			client.complete(withStatusCode: 200, data: emptyListData)
		}
	}
	
	func test_load_deliveryItemsOn200HTTPResponseWithJSONItem(){
		let (sut, client) = makeSUT()
		
		let item1 = makeItem(id: UUID(), description: nil, location: nil, imageURL: URL.init(string: "https://a-url.com")!)
		let item2 = makeItem(id: UUID(), description: "a description", location: "a location", imageURL: URL.init(string: "https://another-url.com")!)
		
		
		
		expect(sut, toCompleteWith: .success([item1.model, item2.model])) {
			let json = makeItemJSON([item1.json, item2.json])
			client.complete(withStatusCode: 200, data: json)
		}
		
	}

	
	
	//MARK: - Helper
	private func makeSUT(url: URL = URL(string: "https://new-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
		let client = HTTPClientSpy()
		let sut = RemoteFeedLoader(url: url, client: client)
		return (sut, client)
	}
	
	private func makeItem(id: UUID, description:String?, location: String?,imageURL: URL) -> (model: FeedItem, json:[String: Any]){
		let item = FeedItem(id: id, description: description, location: location, imageURL: imageURL)
		let json = [
			"id": item.id.uuidString,
			"description": item.description,
			"location": item.location,
			"image": item.imageURL.absoluteString,
		].reduce(into: [String: Any]()) {(acc, e) in
			if let val = e.value {
				acc[e.key] = val
			}
		}
		
		return (item, json)
	}
	
	func makeItemJSON(_ items: [[String: Any]]) -> Data {
		let json = [ "items":items ]
		return try! JSONSerialization.data(withJSONObject: json)
	}
	
	private func expect(_ sut: RemoteFeedLoader, toCompleteWith result: RemoteFeedLoader.Result, when action: () -> Void, file: StaticString = #filePath, line:UInt = #line){
		
		var capturedResults: [RemoteFeedLoader.Result] = []
		sut.load {capturedResults.append($0)}
		
		action()
		XCTAssertEqual(capturedResults, [result], file: file, line: line)
	}
	
	private class HTTPClientSpy: HTTPClient {
		var messages = [(url: URL, completion:(HTTPClientResult)->Void)]()
		
		var requestedURLs: [URL] {
			return messages.map {$0.url}
		}
		
		func get(from url: URL, completion: @escaping (HTTPClientResult)-> Void){
			messages.append((url, completion ))
		}
		
		func complete(with error: Error, at index: Int = 0) {
			messages[index].completion(.failure(error))
		}
		
		func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
			let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)!
			messages[index].completion(.success(data, response))
		}

	}
	
}

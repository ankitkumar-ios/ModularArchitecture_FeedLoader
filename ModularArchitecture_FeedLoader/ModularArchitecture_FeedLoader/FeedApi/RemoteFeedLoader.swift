//
//  RemoteFeedLoader.swift
//  ModularArchitecture_FeedLoader
//
//  Created by Ankit on 03/06/21.
//

import Foundation

public enum HTTPClientResult {
	case success(Data, HTTPURLResponse)
	case failure(Error)
}

public protocol HTTPClient {
	func get(from url: URL, completion: @escaping (HTTPClientResult)->Void)
}


public final class RemoteFeedLoader {
	private let url: URL
	private let client: HTTPClient
	
	public enum Error: Swift.Error {
		case connectivityError
		case invalidData
	}
	
	public init(url: URL, client: HTTPClient) {
		self.url = url
		self.client = client
	}
	
	public func load(completion: @escaping (Error)-> Void) {
		client.get(from:url) { result in
			switch result {
				case .success:
					completion(.invalidData)
				case .failure:
					completion(.connectivityError)
			}			
		}
	}
}

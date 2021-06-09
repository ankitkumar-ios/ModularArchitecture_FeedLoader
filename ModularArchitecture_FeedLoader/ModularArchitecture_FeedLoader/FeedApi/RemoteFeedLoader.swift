//
//  RemoteFeedLoader.swift
//  ModularArchitecture_FeedLoader
//
//  Created by Ankit on 03/06/21.
//

import Foundation

public final class RemoteFeedLoader {
	private let url: URL
	private let client: HTTPClient
	
	public enum Error: Swift.Error {
		case connectivityError
		case invalidData
	}
	
	public enum Result: Equatable {
		case success([FeedItem])
		case failure(Error)
	}
	
	public init(url: URL, client: HTTPClient) {
		self.url = url
		self.client = client
	}
	
	public func load(completion: @escaping (Result)-> Void) {
		client.get(from:url) { result in
			switch result {
				case let .success(data, response):
					completion(FeedItemsMapper.map(data, from: response))
				case .failure:
					completion(.failure(.connectivityError))
			}			
		}
	}
	
}



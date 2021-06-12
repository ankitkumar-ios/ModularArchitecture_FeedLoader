//
//  FeedLoader.swift
//  ModularArchitecture_FeedLoader
//
//  Created by Ankit on 02/06/21.
//

import Foundation

public enum LoadFeedResult<Error: Swift.Error> {
	case success([FeedItem])
	case failure(Error)
}

protocol FeedLoader {
	associatedtype Error: Swift.Error
	func load(completion: @escaping(LoadFeedResult<Error>)->Void)
}

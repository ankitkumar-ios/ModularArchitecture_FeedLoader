//
//  FeedLoader.swift
//  ModularArchitecture_FeedLoader
//
//  Created by Ankit on 02/06/21.
//

import Foundation

public enum LoadFeedResult {
	case success([FeedItem])
	case failure(Error)
}

public protocol FeedLoader {
	func load(completion: @escaping(LoadFeedResult)->Void)
}

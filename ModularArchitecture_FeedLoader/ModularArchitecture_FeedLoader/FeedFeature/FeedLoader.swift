//
//  FeedLoader.swift
//  ModularArchitecture_FeedLoader
//
//  Created by Ankit on 02/06/21.
//

import Foundation

enum LoadFeedResult {
	case success([FeedItem])
	case error(Error)
}


protocol FeedLoader {
	func load(completion: @escaping(LoadFeedResult)->Void)
}

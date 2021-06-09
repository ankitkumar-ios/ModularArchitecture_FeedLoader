//
//  FeedItem.swift
//  ModularArchitecture_FeedLoader
//
//  Created by Ankit on 02/06/21.
//

import Foundation

public struct FeedItem: Equatable {
	let id: UUID
	let description: String?
	let location: String?
	let imageURL: URL
}

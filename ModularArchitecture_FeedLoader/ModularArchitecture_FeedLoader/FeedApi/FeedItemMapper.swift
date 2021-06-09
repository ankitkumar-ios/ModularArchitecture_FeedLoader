//
//  FeedItemMapper.swift
//  ModularArchitecture_FeedLoader
//
//  Created by Ankit on 09/06/21.
//

import Foundation

internal final class FeedItemsMapper{
	
	private struct Root: Decodable {
		let items:[Item]
		var feed:[FeedItem] {
			return items.map {$0.item }
		}
	}
	
	private struct Item: Decodable {
		let id: UUID
		let description: String?
		let location: String?
		let image: URL
		
		var item: FeedItem {
			FeedItem(id: id, description: description, location: location, imageURL: image)
		}
	}
	
	
	private static var OK_200: Int {return 200}
	

	internal static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result{
		guard response.statusCode == OK_200, let json = try? JSONDecoder().decode(Root.self, from: data) else {
			return .failure(.invalidData)
		}
		let items = json.items.map{$0.item}
		return .success(items)

	}

}

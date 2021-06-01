//
//  FeedViewController.swift
//  ModularArchitecture_FeedLoader
//
//  Created by Ankit on 01/06/21.
//

import UIKit
import SystemConfiguration


protocol FeedLoader {
	func loadFeed(completion:@escaping (([String]) -> Void))
}

class FeedViewController: UIViewController {
	
	var loader: FeedLoader?
	
	convenience init(loader: FeedLoader){
		self.init()
		self.loader = loader
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		guard let loader = loader else {return}

		loader.loadFeed { items in
			//updateUI
			print(items)
		}
		
		
		
	}
}






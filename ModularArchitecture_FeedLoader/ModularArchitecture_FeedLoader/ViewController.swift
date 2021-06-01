//
//  ViewController.swift
//  ModularArchitecture_FeedLoader
//
//  Created by Ankit on 01/06/21.
//

import UIKit

class ViewController: UIViewController {
	
	@IBAction func buttonClciked(_ sender: Any){
		openLoader()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}

	
	func openLoader() {
		let loader = RemoteWithLocalFallbackFeedLoader(remote: RemoteFeedLoader(), local: LocalFeedLoader())
		let vc = self.storyboard?.instantiateViewController(identifier: "FeedViewController") as! FeedViewController
		vc.loader = loader
		self.present(vc, animated: true, completion: nil)
	}

}


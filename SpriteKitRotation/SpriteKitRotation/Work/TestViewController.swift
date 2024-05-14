//
//  TestViewController.swift
//  SpriteKitRotation
//
//  Created by Don Mag on 4/25/24.
//

import UIKit
import SpriteKit
import GameplayKit

class TestViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .systemYellow

		if let v = view.subviews.first {
			v.removeFromSuperview()
		}
		
		let testScene = Test2Scene(size: view.frame.size)
		if let skView = view as? SKView {
			skView.presentScene(testScene)
			return
		}
		
	}
	
}


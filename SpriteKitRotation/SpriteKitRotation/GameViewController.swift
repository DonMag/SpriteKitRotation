//
//  GameViewController.swift
//  SpriteKitRotation
//
//  Created by Don Mag on 2/18/24.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
	
	var trainScene: TrainGameScene!
	var trainTwoScene: TrainTwoGameScene!
	var directionsScene: DirectionsScene!
	var creditsScene: CreditsScene!
	
	override func viewDidLoad() {
		super.viewDidLoad()
				
		// dark green background
		view.backgroundColor = UIColor(red: 0.0, green: 0.4, blue: 0.0, alpha: 1.0)
		
		if let v = view.subviews.first {
			v.removeFromSuperview()
		}

		trainScene = TrainGameScene(size: view.frame.size)
		trainTwoScene = TrainTwoGameScene(size: view.frame.size)
		directionsScene = DirectionsScene(size: view.frame.size)
		creditsScene = CreditsScene(size: view.frame.size)
		
		trainScene.showCallback = { [weak self] i in
			guard let self = self else { return }
			if i == 1 {
				self.showDirectionsScene()
			} else {
				self.showCreditsScene()
			}
		}
		
		trainTwoScene.showCallback = { [weak self] i in
			guard let self = self else { return }
			if i == 1 {
				self.showDirectionsScene()
			} else {
				self.showCreditsScene()
			}
		}
		
		directionsScene.backCallback = { [weak self] in
			guard let self = self else { return }
			self.showTrainScene()
		}
		
		creditsScene.backCallback = { [weak self] in
			guard let self = self else { return }
			self.showTrainScene()
		}
		
		trainScene.scaleMode = .resizeFill
		trainTwoScene.scaleMode = .resizeFill
		directionsScene.scaleMode = .resizeFill
		creditsScene.scaleMode = .resizeFill

	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		// here we know the actual view size
		trainScene.setupScene(size: view.frame.size)
		trainTwoScene.setupScene(size: view.frame.size)
		directionsScene.setupScene(size: view.frame.size)
		creditsScene.setupScene(size: view.frame.size)
		showTrainScene()
	}
	
	func showTrainScene() {
		guard let skView = view as? SKView else { return }
		let reveal = SKTransition.moveIn(with: .left, duration: 0.3)
		//skView.presentScene(trainScene, transition: reveal)
		skView.presentScene(trainTwoScene, transition: reveal)
	}
	func showDirectionsScene() {
		guard let skView = view as? SKView else { return }
		let reveal = SKTransition.moveIn(with: .right, duration: 0.3)
		skView.presentScene(directionsScene, transition: reveal)
	}
	func showCreditsScene() {
		guard let skView = view as? SKView else { return }
		let reveal = SKTransition.moveIn(with: .right, duration: 0.3)
		skView.presentScene(creditsScene, transition: reveal)
	}
	
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return .all
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
}


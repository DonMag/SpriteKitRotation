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
	
	var scene: SKScene!

	override func viewDidLoad() {
		super.viewDidLoad()
		
		// GameScene class uses a simple oval path,
		//	so any time the frame/path is updated, the
		//	animation will restart at the Zero-degree point
		//scene = GameScene(size: view.frame.size)

		// AdvGameScene class uses a custom MyEllipse class
		//	to generate an array of points forming an ellipse
		// When the frame/path is updated, we get the
		//	closest point on the current ellipse path, and
		//	re-generate the path so animation starts at that point
		scene = AdvGameScene(size: view.frame.size)

		scene.scaleMode = .resizeFill
		if let skView = view as? SKView {
			skView.presentScene(scene)
		}

	}

	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return .all
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
}


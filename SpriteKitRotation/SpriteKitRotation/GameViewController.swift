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
	
	var scene: GameScene!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		scene = GameScene(size: view.frame.size)
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


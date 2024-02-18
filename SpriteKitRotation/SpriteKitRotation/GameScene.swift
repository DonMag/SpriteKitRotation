//
//  GameScene.swift
//  SpriteKitRotation
//
//  Created by Don Mag on 2/18/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
	
	var spOval: SKShapeNode!
	var myTrain: SKSpriteNode!
	
	var trainPath: UIBezierPath!
	
	var currentSize: CGSize = .zero
	
	override func didMove(to view: SKView) {
		
		// ellipse frame will be set in updateFraming
		spOval = SKShapeNode(ellipseIn: .zero)
		spOval.lineWidth = 5
		spOval.strokeColor = .lightGray
		addChild(spOval)
		
		myTrain = SKSpriteNode(imageNamed: "arrow2")
		addChild(myTrain)
		
		updateFraming()
		startAnim()
		
	}
	
	override func didChangeSize(_ oldSize: CGSize) {
		if let v = self.view {
			// this can be called multiple times on device rotation,
			//	so we only want to update the framing and animation
			//	if the size has changed
			if currentSize != v.frame.size {
				currentSize = v.frame.size
				updateFraming()
				startAnim()
			}
		}
	}
	
	func updateFraming() {
		// self.view is optional, so safely unwrap
		guard let thisSKView = self.view else { return }
		
		let sz = thisSKView.frame.size
		
		// make the ellipse width equal to view width minus 120-points on each side
		let w: CGFloat = sz.width - 240.0
		
		// if view is wider than tall (landscape)
		//	set ellipse height to 30% of view height
		// else (portrait)
		//	set ellipse height to 38% of view height
		let h: CGFloat = sz.width > sz.height ? sz.height * 0.3 : sz.height * 0.38
		
		// center horizontally
		let x: CGFloat = (sz.width - w) * 0.5
		
		// put bottom of ellipse 40-points from bottom of view
		let y: CGFloat = 40.0
		
		let r: CGRect = .init(x: x, y: y, width: w, height: h)
		
		// create the "path to follow"
		trainPath = UIBezierPath(ovalIn: r).reversing()
		
		// update the visible oval
		spOval.path = trainPath.cgPath
	}
	
	func startAnim() {
		
		var trainAction = SKAction.follow(
			trainPath.cgPath,
			asOffset: false,
			orientToPath: true,
			speed: 200.0)
		trainAction = SKAction.repeatForever(trainAction)
		myTrain.run(trainAction, withKey: "myKey")
		
	}
	
	override func update(_ currentTime: TimeInterval) {
		// Called before each frame is rendered
	}
}

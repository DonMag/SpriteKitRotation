//
//  Test2Scene.swift
//  SpriteKitRotation
//
//  Created by Don Mag on 5/11/24.
//

import Foundation
import GameplayKit

class Test2Scene: SKScene {
	
	var trainPath: UIBezierPath!
	
	var shapeNodePath: SKShapeNode!
	var nodeTrain: SKSpriteNode!
	
	var txTrain: SKTexture!
	
	override func didMove(to view: SKView) {
		
		self.backgroundColor = .white
		
		guard let thisSKView = self.view else { return }
		
		guard let img = UIImage(named: "orientation1")
		else {
			fatalError("Could not load \"orientation\" image!")
		}
		
		txTrain = SKTexture(image: img)
		
		var trackRect = CGRect(x: 40.0,
							   y: 200.0,
							   width: 300.0,
							   height: 150.0)
		
		trackRect = CGRect(x: 0.0,
						   y: 0.0,
						   width: 300.0,
						   height: 150.0)
		
		trainPath = UIBezierPath(ovalIn: trackRect)
		print(trainPath.cgPath)

		shapeNodePath = SKShapeNode(path: trainPath.cgPath)
		shapeNodePath.lineWidth = 5
		shapeNodePath.strokeColor = .systemYellow
		addChild(shapeNodePath)
		
		nodeTrain = SKSpriteNode(texture: txTrain)
		addChild(nodeTrain)
		
		let viewRect = thisSKView.frame
		nodeTrain.position = .init(x: viewRect.midX, y: viewRect.midY)
		nodeTrain.position = .init(x: trackRect.midX, y: trackRect.midY)
		
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		if !nodeTrain.hasActions() {
			startAnim()
		} else {
			nodeTrain.isPaused.toggle()
		}
	}
	
	func startAnim() {
		var thisAction1 = SKAction.follow(
			trainPath.cgPath,
			asOffset: false,
			orientToPath: true,
			speed: 100.0)
		thisAction1 = SKAction.repeatForever(thisAction1)
		
		nodeTrain.run(thisAction1, withKey: "myKey")
	}
	
	var b: Bool = true
	override func update(_ currentTime: TimeInterval) {
		// we want to swap the train image if the animation
		//	has moved from top-half to bottom-half of ellipse
		//	and vice-versa
		let p = nodeTrain.position
		let r = trainPath.bounds

		if p.x > 299.0 && b {
			b = false
			nodeTrain.isPaused = true
		}
	}

}

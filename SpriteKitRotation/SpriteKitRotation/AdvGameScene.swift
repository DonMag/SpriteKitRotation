//
//  AdvGameScene.swift
//  SpriteKitRotation
//
//  Created by Don Mag on 2/19/24.
//

import UIKit

import SpriteKit
import GameplayKit

class AdvGameScene: SKScene {

	var ellipsePortrait: MyEllipse = MyEllipse()
	var ellipseLandscape: MyEllipse = MyEllipse()

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
		
		// setup "portrait" and "landscape" ellipses
		// 120 points gives us a point every 3-degrees
		let numPoints: Int = 120
		
		var sz: CGSize!
		var w: CGFloat!
		var h: CGFloat!
		var x: CGFloat!
		var y: CGFloat!
		
		var r: CGRect!
		var rectP: CGRect = .zero
		var rectL: CGRect = .zero
		
		if view.frame.width > view.frame.height {
			rectL.size = view.frame.size
			rectP.size = .init(width: view.frame.height, height: view.frame.width)
		} else {
			rectP.size = view.frame.size
			rectL.size = .init(width: view.frame.height, height: view.frame.width)
		}
		
		// create the "portrait" ellipse
		sz = rectP.size
		w = sz.width - 240.0
		h = sz.height * 0.38
		x = (sz.width - w) * 0.5
		y = 40.0
		r = .init(x: x, y: y, width: w, height: h)
		ellipsePortrait.generatePoints(in: r, numberOfPoints: numPoints)
		
		// create the "landscape" ellipse
		sz = rectL.size
		w = sz.width - 240.0
		h = sz.height * 0.30
		x = (sz.width - w) * 0.5
		y = 40.0
		r = .init(x: x, y: y, width: w, height: h)
		ellipseLandscape.generatePoints(in: r, numberOfPoints: numPoints)
		
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
		
		let curPos = myTrain.position
		
		let sz = thisSKView.frame.size
		
		// create the "path to follow"
		if sz.width > sz.height {
			let startIdx: Int = ellipsePortrait.closestIndex(to: curPos) ?? 0
			trainPath = ellipseLandscape.generatePath(startingAt: startIdx).reversing()
		} else {
			let startIdx: Int = ellipseLandscape.closestIndex(to: curPos) ?? 0
			trainPath = ellipsePortrait.generatePath(startingAt: startIdx).reversing()
		}
		
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

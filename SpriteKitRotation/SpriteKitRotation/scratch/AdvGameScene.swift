//
//  AdvGameScene.swift
//  SpriteKitRotation
//
//  Created by Don Mag on 2/19/24.
//

import UIKit

import SpriteKit
import GameplayKit

extension UIImage {
	
	func rotated(byDegrees degrees: CGFloat) -> UIImage? {
		let renderer = UIGraphicsImageRenderer(size: size)
		return renderer.image { context in
			// Translate and rotate the context
			context.cgContext.translateBy(x: size.width / 2, y: size.height / 2)
			context.cgContext.rotate(by: degrees * .pi / 180.0)
			
			// Draw the image into the context
			draw(in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
		}
	}

	func horizontallyMirrored() -> UIImage? {
		let renderer = UIGraphicsImageRenderer(size: size)
		return renderer.image { context in
			// Flip the context horizontally
			context.cgContext.translateBy(x: size.width, y: 0)
			context.cgContext.scaleBy(x: -1, y: 1)
			
			// Draw the image into the context
			draw(in: CGRect(origin: .zero, size: size))
		}
	}

}

class AdvGameScene: SKScene {

	var ellipsePortrait: MyEllipse = MyEllipse()
	var ellipseLandscape: MyEllipse = MyEllipse()

	var spOval: SKShapeNode!
	var myTrain: SKSpriteNode!
	
	var trainPath: UIBezierPath!
	
	var currentSize: CGSize = .zero
	
	var txRight: SKTexture!
	var txLeft: SKTexture!
	
	override func didMove(to view: SKView) {
		
		guard let imgR = UIImage(named: "train2")
		else {
			fatalError("Could not load train image!")
		}

		guard let imgRight = imgR.rotated(byDegrees: -90.0),
			  let imgLeft = imgRight.horizontallyMirrored()
		else {
			fatalError("Could not rotate train image!")
		}
		
		txRight = SKTexture(image: imgRight)
		txLeft = SKTexture(image: imgLeft)

		// ellipse frame will be set in updateFraming
		spOval = SKShapeNode(ellipseIn: .zero)
		spOval.lineWidth = 5
		spOval.strokeColor = .lightGray
		addChild(spOval)
		
		//myTrain = SKSpriteNode(imageNamed: "arrow2")
		//myTrain = SKSpriteNode(imageNamed: "train1")
		myTrain = SKSpriteNode(texture: txRight)
		
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
		super.didChangeSize(oldSize)
		if let v = self.view {
			print("old:", oldSize, "cur:", v.frame.size)
		}
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
			speed: 100.0)
		trainAction = SKAction.repeatForever(trainAction)
		myTrain.run(trainAction, withKey: "myKey")
		
	}
	
	var isFacingRight: Bool = true
	override func update(_ currentTime: TimeInterval) {
		let p = myTrain.position
		if p.y < trainPath.bounds.midY &&
			isFacingRight
		{
			isFacingRight = false
			myTrain.texture = txLeft
			
		}
		else 
		if p.y > trainPath.bounds.midY &&
			!isFacingRight
		{
			isFacingRight = true
			myTrain.texture = txRight
			
		}

	}
//	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//		print(trainPath.bounds)
//		isFacingRight.toggle()
//		print("r?", isFacingRight, isFacingRight ? "txLeft" : "txRight")
//		myTrain.texture = isFacingRight ? txRight : txLeft
//	}
}

//
//  Test1Scene.swift
//  SpriteKitRotation
//
//  Created by Don Mag on 4/25/24.
//

import Foundation
import GameplayKit

class Test1Scene: SKScene {
	
	var pthOcto1: UIBezierPath!
	var pthOcto2: UIBezierPath!
	
	var shapeNodeOcto1: SKShapeNode!
	var nodeArrow1: SKSpriteNode!
	
	var shapeNodeOcto2: SKShapeNode!
	var nodeArrow2: SKSpriteNode!
	
	var txArrow1: SKTexture!
	var txArrow2: SKTexture!
	
	override func didMove(to view: SKView) {

		self.backgroundColor = UIColor(white: 0.95, alpha: 1.0)

		guard let thisSKView = self.view else { return }
		
		guard let imgH = UIImage(named: "arrowH2"),
			  let imgV = UIImage(named: "arrowV2")
		else {
			fatalError("Could not load \"arrow\" images!")
		}
		
		txArrow1 = SKTexture(image: imgH)
		txArrow2 = SKTexture(image: imgV)

		let sz = thisSKView.frame.size

		let w: CGFloat = 270.0
		let h: CGFloat = 270.0
		let x: CGFloat = (sz.width - w) * 0.5
		let y: CGFloat = (sz.height - (h * 2.0 + 100.0)) * 0.5

		let oneThird: CGFloat = w / 3.0

		let myRect: CGRect = .init(x: x, y: y, width: w, height: h)
		
		let p1: CGPoint = .init(x: myRect.minX + oneThird, y: myRect.maxY)
		let p2: CGPoint = .init(x: myRect.maxX - oneThird, y: myRect.maxY)
		let p3: CGPoint = .init(x: myRect.maxX, y: myRect.maxY - oneThird)
		let p4: CGPoint = .init(x: myRect.maxX, y: myRect.minY + oneThird)
		let p5: CGPoint = .init(x: myRect.maxX - oneThird, y: myRect.minY)
		let p6: CGPoint = .init(x: myRect.minX + oneThird, y: myRect.minY)
		let p7: CGPoint = .init(x: myRect.minX, y: myRect.minY + oneThird)
		let p8: CGPoint = .init(x: myRect.minX, y: myRect.maxY - oneThird)
		
		pthOcto1 = UIBezierPath()

		var startPT: CGPoint = .zero
		var pt: CGPoint = .zero
		var pts: [CGPoint] = []
		
		pts = [p1, p2, p3, p4, p5, p6, p7, p8]
		
		startPT = pts.removeFirst()
		pthOcto1.move(to: startPT)
		while !pts.isEmpty {
			pt = pts.removeFirst()
			pthOcto1.addLine(to: pt)
		}
		pthOcto1.close()

		shapeNodeOcto1 = SKShapeNode(path: pthOcto1.cgPath)
		shapeNodeOcto1.lineWidth = 5
		shapeNodeOcto1.strokeColor = .systemYellow
		addChild(shapeNodeOcto1)

		nodeArrow1 = SKSpriteNode(texture: txArrow1)
		addChild(nodeArrow1)
		
		nodeArrow1.position = startPT

		// shift the path up
		if let p = pthOcto1.copy() as? UIBezierPath {
			pthOcto2 = p
		}
		pthOcto2.apply(CGAffineTransform(translationX: 0.0, y: h + 100.0))

		shapeNodeOcto2 = SKShapeNode(path: pthOcto2.cgPath)
		shapeNodeOcto2.lineWidth = 5
		shapeNodeOcto2.strokeColor = .systemOrange
		addChild(shapeNodeOcto2)
		
		nodeArrow2 = SKSpriteNode(texture: txArrow2)
		addChild(nodeArrow2)
		
		nodeArrow2.position = .init(x: startPT.x, y: startPT.y + h + 100.0)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if !nodeArrow1.hasActions() {
			startAnim()
		} else {
			nodeArrow1.isPaused.toggle()
			nodeArrow2.isPaused.toggle()
		}
	}
	
	func startAnim() {
		var thisAction1 = SKAction.follow(
			pthOcto1.cgPath,
			asOffset: false,
			orientToPath: true,
			speed: 100.0)
		thisAction1 = SKAction.repeatForever(thisAction1)

		
		var thisAction2 = SKAction.follow(
			pthOcto2.cgPath,
			asOffset: false,
			orientToPath: true,
			speed: 100.0)
		thisAction2 = SKAction.repeatForever(thisAction2)

		nodeArrow1.run(thisAction1, withKey: "myKey")
		nodeArrow2.run(thisAction2, withKey: "myKey")
	}
	

}

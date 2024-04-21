//
//  Simple.swift
//  SpriteKitRotation
//
//  Created by Don Mag on 3/27/24.
//

import UIKit
import GameplayKit

class SimpleGameScene: SKScene {
	
	var dynaY: CGFloat = 0.0
	
	var shapeNodeRect: SKShapeNode!
	var shapeNodeOval: SKShapeNode!
	var shapeNodeArrow: SKShapeNode!
	
	override func didMove(to view: SKView) {
		
		guard let thisSKView = self.view else { return }
		
		let sz = thisSKView.frame.size
		print("thisSKView frame:", thisSKView.frame, "thisSKView center.y:", thisSKView.center.y)
		let offset: CGFloat = 0.0
		
		let x: CGFloat = offset
		let y: CGFloat = dynaY
		let w: CGFloat = 150.0
		let h: CGFloat = 250.0

		let armOffsetX: CGFloat = w * 0.25
		let armOffsetY: CGFloat = h * 0.25
		
		let myRect: CGRect = .init(x: x, y: y, width: w, height: h)
		
		shapeNodeRect = SKShapeNode(path: UIBezierPath(rect: myRect).cgPath)
		shapeNodeRect.lineWidth = 7
		shapeNodeRect.strokeColor = .darkGray
		addChild(shapeNodeRect)
		
		shapeNodeOval = SKShapeNode(path: UIBezierPath(ovalIn: myRect).cgPath)
		shapeNodeOval.lineWidth = 5
		shapeNodeOval.strokeColor = .systemBlue
		addChild(shapeNodeOval)
		
		var pth = UIBezierPath()
		
//		let p1: CGPoint = .init(x: myRect.midX - armOffsetX, y: myRect.minY + armOffsetY)
//		let p2: CGPoint = .init(x: myRect.midX, y: myRect.minY)
//		let p3: CGPoint = .init(x: myRect.midX + armOffsetX, y: myRect.minY + armOffsetY)
//		let p4: CGPoint = .init(x: myRect.midX, y: myRect.maxY)
//		let p5: CGPoint = .init(x: myRect.minX, y: myRect.maxY)
//		let p6: CGPoint = .init(x: myRect.maxX, y: myRect.maxY)
//		
//		pth.move(to: p1)
//		pth.addLine(to: p2)
//		pth.addLine(to: p3)
//		pth.move(to: p2)
//		pth.addLine(to: p4)
//		pth.move(to: p5)
//		pth.addLine(to: p6)

		let p1: CGPoint = .init(x: myRect.minX, y: myRect.minY)
		let p2: CGPoint = .init(x: myRect.maxX, y: myRect.maxY)
		let p3: CGPoint = .init(x: myRect.maxX - 30.0, y: myRect.maxY)
		let p4: CGPoint = .init(x: myRect.maxX, y: myRect.maxY - 30.0)
		let p5: CGPoint = .init(x: myRect.maxX, y: myRect.maxY)

		pth = UIBezierPath()
		
		pth.move(to: p1)
		pth.addLine(to: p2)
		pth.addLine(to: p3)
		pth.addLine(to: p4)
		pth.addLine(to: p5)

//		
//		pth.move(to: .init(x: 0.0, y: 0.0))
//		pth.addLine(to: .init(x: 50.0, y: 150.0))
//		pth.addLine(to: .init(x: 100.0, y: 0.0))

//		print(pth.cgPath)
//		pth.apply(CGAffineTransform(scaleX: 1.0, y: -1.0))
//		print(pth.cgPath)
//		pth.apply(CGAffineTransform(translationX: 0.0, y: pth.bounds.height))
//		print(pth.cgPath)

		pth.apply(CGAffineTransform(scaleX: 1.0, y: -1.0))
		pth.apply(CGAffineTransform(translationX: 0.0, y: pth.bounds.height))

		shapeNodeArrow = SKShapeNode(path: pth.cgPath)
		shapeNodeArrow.lineWidth = 3
		shapeNodeArrow.strokeColor = .systemRed
		addChild(shapeNodeArrow)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		print(#function)
		dynaY += 40.0
		shapeNodeArrow.position.y = dynaY
	}
}

//
//  DirectionsScene.swift
//  SpriteKitRotation
//
//  Created by Don Mag on 4/21/24.
//

import UIKit
import GameplayKit

class DirectionsScene: SKScene {
	
	// closure to handle tapping "< Back" label
	public var backCallback: (() -> ())?

	private var backLabel: SKLabelNode!
	private var directionsLabel: SKLabelNode!

	private var currentSize: CGSize = .zero
	
	func setupScene(size: CGSize) {
		
		self.backgroundColor = .systemBlue
		
		let myRect: CGRect = .init(origin: .zero, size: size)
		
		directionsLabel = SKLabelNode(fontNamed: "MarkerFelt-Thin")
		directionsLabel.text = "Directions..."
		directionsLabel.fontSize = 40
		directionsLabel.fontColor = SKColor.yellow
		directionsLabel.position = CGPoint(x: myRect.midX, y: myRect.midY)
		
		addChild(directionsLabel)
		
		backLabel = SKLabelNode(fontNamed: "MarkerFelt-Thin")
		backLabel.text = "< Back"
		backLabel.fontSize = 32
		backLabel.fontColor = SKColor.green
		backLabel.position = CGPoint(x: myRect.minX + 60.0, y: myRect.maxY - 100.0)
		
		addChild(backLabel)
		
	}

	override func didMove(to view: SKView) {
		updateLayout()
	}
	override func didChangeSize(_ oldSize: CGSize) {
		super.didChangeSize(oldSize)
		updateLayout()
	}
	func updateLayout() {
		if let v = self.view {
			// this can be called multiple times on device rotation,
			//	so we only want to update the framing and animation
			//	if the size has changed
			if currentSize != v.frame.size {
				currentSize = v.frame.size
				directionsLabel.position = CGPoint(x: v.frame.midX, y: v.frame.midY)
				if currentSize.width > currentSize.height {
					backLabel.position = CGPoint(x: v.frame.minX + 60.0, y: v.frame.maxY - 40.0)
				} else {
					backLabel.position = CGPoint(x: v.frame.minX + 60.0, y: v.frame.maxY - 80.0)
				}
			}
		}
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let t = touches.first else { return }
		if backLabel.contains(t.location(in: self)) {
			backCallback?()
		}
	}
}

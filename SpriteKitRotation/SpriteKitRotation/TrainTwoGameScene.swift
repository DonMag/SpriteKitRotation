//
//  TrainTwoGameScene.swift
//  SpriteKitRotation
//
//  Created by Don Mag MBP on 5/4/24.
//

import UIKit
import GameplayKit

class TrainTwoGameScene: SKScene {
	
	// closure to handle tapping Directions or Credits labels
	public var showCallback: ((Int) -> ())?
	
	// labels for top of view
	//	tapping a label will take the user to the corrosponding scene
	private var directionsLabel: SKLabelNode!
	private var creditsLabel: SKLabelNode!
	
	private var ellipsePortrait: MyEllipse = MyEllipse()
	private var ellipseLandscape: MyEllipse = MyEllipse()
	private var ellipseCarPortrait: MyEllipse = MyEllipse()
	private var ellipseCarLandscape: MyEllipse = MyEllipse()

	// this Oval shape is only used because we
	//	haven't added the "tracks image" yet
	private var spOval: SKShapeNode!
	private var myTrain: SKSpriteNode!
	private var myTrainCar: SKSpriteNode!
	
	// "follow path"
	private var trainPath: UIBezierPath!
	private var trainCarPath: UIBezierPath!
	
	// track current view size
	private var currentSize: CGSize = .zero
	
	// image texture of train that will move clockwise
	//	when on Top of oval
	//	when on Bottom of oval
	private var txTop: SKTexture!
	private var txBottom: SKTexture!
	private var txRight: SKTexture!
	private var txLeft: SKTexture!

	private var txCarTop: SKTexture!
	private var txCarBottom: SKTexture!
	private var txCarRight: SKTexture!
	private var txCarLeft: SKTexture!

	private var isOnTopOfOval: Bool = true
	private var isOnTopOfOvalCar: Bool = true
	
	// track the index of the point on the array
	//	that defines the oval / ellipse
	private var lastIDX: Int = 0
	private var lastCarIDX: Int = 0
	
	// number of points to use to define the oval/ellipse
	//	works best as an even factor of 360 (degrees)
	//	360, 180, 120, 90, 72, 60, 45, 40, etc...
	private let numEllipsePoints: Int = 180
	
	func setupScene(size: CGSize) {
		
		// dark green background
		self.backgroundColor = UIColor(red: 0.0, green: 0.4, blue: 0.0, alpha: 1.0)
		
		// load the train image
		//	our train image was drawn in this orientation:
		//
		//      ┌┈┈┈┈┈┈┈┈┈┈┐
		//      │          │
		//      │          └┄┄┄┄╲
		//      │               ╱
		//      └┈┈◯┈┈┈┈┈┈◯◯┈┄┄╱
		//
		// so, we need to create
		//	a rotated copy and (for top-of-oval), and
		//	a horizontallyMirrored copy (for bottom-of-oval)
		guard let img = UIImage(named: "myTrain"),
			  let imgTop = img.rotated(byDegrees: -90.0),
			  let imgBottom = imgTop.horizontallyMirrored(),
			  let imgO = UIImage(named: "myTrainOver"),
			  let imgRight = imgO.rotated(byDegrees: -90.0),
			  let imgLeft = imgRight.horizontallyMirrored()
		else {
			fatalError("Could not load \"myTrain\" image!")
		}
		
		guard let imgC = UIImage(named: "myTrainCar"),
			  let imgCTop = imgC.rotated(byDegrees: -90.0),
			  let imgCBottom = imgCTop.horizontallyMirrored(),
			  let imgCO = UIImage(named: "myTrainCarOver"),
			  let imgCRight = imgCO.rotated(byDegrees: -90.0),
			  let imgCLeft = imgCRight.horizontallyMirrored()
		else {
			fatalError("Could not load \"myTrain\" image!")
		}
		
		txTop = SKTexture(image: imgTop)
		txBottom = SKTexture(image: imgBottom)
		txRight = SKTexture(image: imgRight)
		txLeft = SKTexture(image: imgLeft)
		
		txCarTop = SKTexture(image: imgCTop)
		txCarBottom = SKTexture(image: imgCBottom)
		txCarRight = SKTexture(image: imgCRight)
		txCarLeft = SKTexture(image: imgCLeft)
		
		// oval shape node is only being used here
		//	because we do not have a "tracks" image yet
		spOval = SKShapeNode(ellipseIn: .zero)
		spOval.lineWidth = 5
		spOval.strokeColor = .systemOrange
		addChild(spOval)
		
		myTrain = SKSpriteNode(texture: txTop)
		myTrainCar = SKSpriteNode(texture: txCarTop)
		
		// set train image size based on device
		if UIDevice.current.userInterfaceIdiom == .pad {
			myTrain.size = .init(width: 160, height: 160)
		} else {
			myTrain.size = .init(width: 100, height: 100)
		}
		myTrainCar.size = myTrain.size
		
		addChild(myTrainCar)
		addChild(myTrain)

		// setup "portrait" and "landscape" ellipses
		
		var sz: CGSize!
		var w: CGFloat!
		var h: CGFloat!
		var x: CGFloat!
		var y: CGFloat!
		
		var r: CGRect!
		var rectP: CGRect = .zero
		var rectL: CGRect = .zero
		
		let vFrame: CGRect = .init(origin: .zero, size: size)
		
		if vFrame.width > vFrame.height {
			rectL.size = vFrame.size
			rectP.size = .init(width: vFrame.height, height: vFrame.width)
		} else {
			rectP.size = vFrame.size
			rectL.size = .init(width: vFrame.height, height: vFrame.width)
		}
		
		// create the "portrait" ellipse
		sz = rectP.size
		w = sz.width - 160.0
		h = sz.height * 0.38
		x = (sz.width - w) * 0.5
		y = 80.0
		r = .init(x: x, y: y, width: w, height: h)
		ellipsePortrait.generatePoints(in: r, numberOfPoints: numEllipsePoints)
		
		// create the "landscape" ellipse
		sz = rectL.size
		w = sz.width - 240.0
		h = sz.height * 0.30
		x = (sz.width - w) * 0.5
		y = 40.0
		r = .init(x: x, y: y, width: w, height: h)
		ellipseLandscape.generatePoints(in: r, numberOfPoints: numEllipsePoints)
		
		// we want to start with the train near top-center of the oval
		lastIDX = Int(Double(numEllipsePoints) * 0.25)
		lastCarIDX = lastIDX + 10
		
		// add "tap" labels to show Directions or Credits scenes
		directionsLabel = SKLabelNode(fontNamed: "MarkerFelt-Thin")
		directionsLabel.text = "Directions"
		directionsLabel.fontSize = 32
		directionsLabel.fontColor = SKColor.yellow
		addChild(directionsLabel)
		
		creditsLabel = SKLabelNode(fontNamed: "MarkerFelt-Thin")
		creditsLabel.text = "Credits"
		creditsLabel.fontSize = 32
		creditsLabel.fontColor = SKColor.yellow
		addChild(creditsLabel)
		
	}
	
	// this will be called on initial appearance, and
	//	when "coming back" from other scene
	override func didMove(to view: SKView) {
		// update the framing based on "landscape" or "portrait" format
		updateFraming()
		
		// position sprites at start of animation
		setupAnim()
	}
	
	// this will be called when "going to" another scene
	override func willMove(from view: SKView) {
		
		// self.view is optional, so safely unwrap
		guard let thisSKView = self.view else { return }
		
		// pause the animation
		myTrain.isPaused = true
		myTrainCar.isPaused = true
		
		// get current point
		let curPos = myTrain.position
		let curPosCar = myTrainCar.position
		
		let sz = thisSKView.frame.size
		
		// save the index of the closest point in the ellipse array
		//	to current position
		if sz.width > sz.height {
			lastIDX = ellipseLandscape.closestIndex(to: curPos) ?? 0
			lastCarIDX = ellipseLandscape.closestIndex(to: curPosCar) ?? 0
		} else {
			lastIDX = ellipsePortrait.closestIndex(to: curPos) ?? 0
			lastCarIDX = ellipsePortrait.closestIndex(to: curPosCar) ?? 0
		}
	}
	
	override func didChangeSize(_ oldSize: CGSize) {
		super.didChangeSize(oldSize)
		
		guard let thisSKView = self.view else { return }
		// this can be called multiple times on device rotation,
		//	so we only want to update the framing and animation
		//	if the size has changed
		
		if currentSize != thisSKView.frame.size {
			
			// get current point
			let curPos = myTrain.position
			let curPosCar = myTrainCar.position
			
			// save the index of the closest point in the ellipse array
			//	to current position
			if oldSize.width > oldSize.height {
				lastIDX = ellipseLandscape.closestIndex(to: curPos) ?? 0
				lastCarIDX = ellipseLandscape.closestIndex(to: curPosCar) ?? 0
			} else {
				lastIDX = ellipsePortrait.closestIndex(to: curPos) ?? 0
				lastCarIDX = ellipsePortrait.closestIndex(to: curPosCar) ?? 0
			}
			
			// update the framing based on "landscape" or "portrait" format
			updateFraming()
			// start the animation
			startAnim()
			
		}
	}
	
	func updateFraming() {
		
		// self.view is optional, so safely unwrap
		guard let thisSKView = self.view else { return }
		
		let myRect: CGRect = thisSKView.frame
		currentSize = myRect.size
		
		if currentSize.width > currentSize.height {
			
			// set the corresponding "path to follow"
			trainPath = ellipseLandscape.generatePath(startingAt: lastIDX).reversing()
			trainCarPath = ellipseLandscape.generatePath(startingAt: lastCarIDX).reversing()
			
			// re-position the top labels
			directionsLabel.position = .init(x: myRect.minX + (directionsLabel.frame.width * 0.5) + 32.0, y: myRect.maxY - 40.0)
			creditsLabel.position = .init(x: myRect.maxX - ((creditsLabel.frame.width * 0.5) + 32.0), y: myRect.maxY - 40.0)
			
		} else {
			
			// set the corresponding "path to follow"
			trainPath = ellipsePortrait.generatePath(startingAt: lastIDX).reversing()
			trainCarPath = ellipsePortrait.generatePath(startingAt: lastCarIDX).reversing()
			
			// re-position the top labels
			directionsLabel.position = .init(x: myRect.minX + (directionsLabel.frame.width * 0.5) + 16.0, y: myRect.maxY - 80.0)
			creditsLabel.position = .init(x: myRect.maxX - ((creditsLabel.frame.width * 0.5) + 16.0), y: myRect.maxY - 80.0)
			
		}
		
		// update the visible oval
		//	this won't be here if we have a "tracks" image
		spOval.path = trainPath.cgPath
		
		//trainCarPath.apply(CGAffineTransform(translationX: 20.0, y: 180.0))
	}

	func setupAnim() {
		
		let trainAction = SKAction.follow(
			trainPath.cgPath,
			asOffset: false,
			orientToPath: true,
			speed: 0.0)
		
		let trainActionCar = SKAction.follow(
			trainCarPath.cgPath,
			asOffset: false,
			orientToPath: true,
			speed: 0.0)
		
		myTrain.run(trainAction, withKey: "myKeySetup")
		myTrainCar.run(trainActionCar, withKey: "myKeyCarSetup")
		myTrain.isPaused = false
		myTrainCar.isPaused = false
	}

	func startAnim() {
		var trainAction = SKAction.follow(
			trainPath.cgPath,
			asOffset: false,
			orientToPath: true,
			speed: 100.0)
		trainAction = SKAction.repeatForever(trainAction)

		var trainActionCar = SKAction.follow(
			trainCarPath.cgPath,
			asOffset: false,
			orientToPath: true,
			speed: 100.0)
		trainActionCar = SKAction.repeatForever(trainActionCar)

		myTrain.run(trainAction, withKey: "myKey")
		myTrainCar.run(trainActionCar, withKey: "myKeyCar")
		myTrain.isPaused = false
		myTrainCar.isPaused = false
	}
	
	var txIDX: Int = 0
	var txCarIDX: Int = 0
	// Called before each frame is rendered
	override func update(_ currentTime: TimeInterval) {
		// we want to swap the train image if the animation
		//	has moved from top-half to bottom-half of ellipse
		//	and vice-versa
		let p = myTrain.position
		let r = trainPath.bounds
		let t = r.height * 0.2
		
		if abs(p.y - r.midY) < t {
			if p.x > r.midX {
				if txIDX != 1 {
					txIDX = 1
					myTrain.texture = txRight
					myTrainCar.texture = txCarRight
				}
			} else {
				if txIDX != 3 {
					txIDX = 3
					myTrain.texture = txLeft
					myTrainCar.texture = txCarLeft
				}
			}
		} else {
			if p.y > trainPath.bounds.midY && txIDX != 0 {
				txIDX = 0
				myTrain.texture = txTop
				myTrainCar.texture = txCarTop
			} else if p.y < trainPath.bounds.midY && txIDX != 2 {
				txIDX = 2
				myTrain.texture = txBottom
				myTrainCar.texture = txCarBottom
			}
		}
	}
	
	// if we tap the Directions or Credits label
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let t = touches.first else { return }
		if directionsLabel.contains(t.location(in: self)) {
			showCallback?(1)
			return
		}
		if creditsLabel.contains(t.location(in: self)) {
			showCallback?(2)
			return
		}
		
		if myTrain.action(forKey: "myKeySetup") != nil {
			myTrain.removeAllActions()
			myTrainCar.removeAllActions()
		}

		if !myTrain.hasActions() {
			startAnim()
		} else {
			myTrain.isPaused.toggle()
			myTrainCar.isPaused.toggle()
		}
	}
	
	// debugging only
	func checkIDX(_ curPos: CGPoint) {
		// self.view is optional, so safely unwrap
		guard let thisSKView = self.view else { return }
		
		let sz = thisSKView.frame.size
		
		var i: Int = 0
		if sz.width > sz.height {
			i = ellipseLandscape.closestIndex(to: curPos) ?? 0
		} else {
			i = ellipsePortrait.closestIndex(to: curPos) ?? 0
		}
		print("close:", i)
	}
}

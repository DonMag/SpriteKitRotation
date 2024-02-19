//
//  MyEllipse.swift
//  SpriteKitRotation
//
//  Created by Don Mag on 2/19/24.
//

import UIKit

class MyEllipse: NSObject {
	
	var thePoints: [CGPoint] = []
	
	// we want to save the ellipse center point
	//	to use with "find closest index to point"
	var _center: CGPoint = .zero
	
	func generatePath(startingAt: Int) -> UIBezierPath {
		
		let idx = startingAt < thePoints.count ? startingAt : 0
		
		var ptsCopy = Array(thePoints[idx...])
		ptsCopy.append(contentsOf: thePoints[0..<idx])
		
		let pth = UIBezierPath()
		pth.move(to: ptsCopy.removeFirst())
		while !ptsCopy.isEmpty {
			pth.addLine(to: ptsCopy.removeFirst())
		}
		pth.close()
		return pth
		
	}
	
	func generatePoints(in rect: CGRect, numberOfPoints: Int) {
		_center = .init(x: rect.midX, y: rect.midY)
		generatePoints(center: _center, a: rect.width * 0.5, b: rect.height * 0.5, numberOfPoints: numberOfPoints)
	}
	func generatePoints(center: CGPoint, a: CGFloat, b: CGFloat, numberOfPoints: Int) {
		thePoints = pointsOnEllipse(center: center, a: a, b: b, numberOfPoints: numberOfPoints)
	}
	
	func pointsOnEllipse(center: CGPoint, a: CGFloat, b: CGFloat, numberOfPoints: Int) -> [CGPoint] {
		var ellipsePoints: [CGPoint] = []
		
		for i in 0..<numberOfPoints {
			let theta = CGFloat(2 * Double.pi * Double(i) / Double(numberOfPoints))
			let x = center.x + a * cos(theta)
			let y = center.y + b * sin(theta)
			let point = CGPoint(x: x, y: y)
			ellipsePoints.append(point)
		}
		
		return ellipsePoints
	}
	
	func closestPoint(to targetPoint: CGPoint) -> CGPoint? {
		guard !thePoints.isEmpty else {
			return nil // Return nil if the array is empty
		}
		
		var closestPoint = thePoints[0]
		var closestDistance = quickDistanceBetween(targetPoint, closestPoint)
		
		for point in thePoints {
			let distance = quickDistanceBetween(targetPoint, point)
			if distance < closestDistance {
				closestDistance = distance
				closestPoint = point
			}
		}
		
		return closestPoint
	}
	
	func closestIndex(to targetPoint: CGPoint) -> Int? {
		guard !thePoints.isEmpty else {
			return nil // Return nil if the array is empty
		}
		guard let pt = closestPoint(to: targetPoint) else { return nil }
		
		return thePoints.firstIndex(of: pt)
	}

	func closestIndexByAngle(to targetPoint: CGPoint) -> Int? {
		guard !thePoints.isEmpty else {
			return nil // Return nil if the array is empty
		}
		
		var a = angleBetweenPoints(_center, targetPoint)
		let d1 = a * (180.0 / CGFloat.pi)
		let d2 = d1 < 0.0 ? d1 + 360.0 : d1
		let step: Int = 360 / thePoints.count
		return (Int(d2) / step)
	}

	// returns the distance between points
	//	uses sqrt() to get the *actual* distance
	func distanceBetween(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
		let deltaX = point2.x - point1.x
		let deltaY = point2.y - point1.y
		return sqrt(deltaX * deltaX + deltaY * deltaY)
	}
	
	// returns the *squared* distance between points
	//	use this if we don't care about the *actual* distance
	// this will be faster because we're not calling sqrt()
	func quickDistanceBetween(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
		let deltaX = point2.x - point1.x
		let deltaY = point2.y - point1.y
		return deltaX * deltaX + deltaY * deltaY
	}
	
	func angleBetweenPoints(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
		let deltaX = point2.x - point1.x
		let deltaY = point2.y - point1.y
		let angle = atan2(deltaY, deltaX)
		
		return angle
		
		// Convert the angle to degrees if needed
		//let degrees = angle * (180.0 / CGFloat.pi)
		
		//return degrees
	}
	
}


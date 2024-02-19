//
//  MyEllipse.swift
//  SpriteKitRotation
//
//  Created by Don Mag on 2/19/24.
//

import UIKit

class MyEllipse: NSObject {
	
	private var thePoints: [CGPoint] = []
	
	// we want to save the ellipse center point
	//	to use with "find closest index to point"
	private var _center: CGPoint = .zero
	
	public func generatePoints(in rect: CGRect, numberOfPoints: Int) {
		_center = .init(x: rect.midX, y: rect.midY)
		generatePoints(center: _center, a: rect.width * 0.5, b: rect.height * 0.5, numberOfPoints: numberOfPoints)
	}
	
	public func generatePath(startingAt: Int) -> UIBezierPath {
		
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
	
	public func closestIndex(to targetPoint: CGPoint) -> Int? {
		guard !thePoints.isEmpty else {
			return nil // Return nil if the array is empty
		}
		let pt = closestPoint(to: targetPoint) ?? thePoints[0]
		return thePoints.firstIndex(of: pt) ?? 0
	}
	
	private func closestPoint(to targetPoint: CGPoint) -> CGPoint? {
		guard !thePoints.isEmpty else {
			return nil // Return nil if the array is empty
		}
		
		var p: Double = 0.0
		if targetPoint.x > _center.x {
			if targetPoint.y > _center.y {
				p = 0.0
			} else {
				p = 0.75
			}
		} else {
			if targetPoint.y > _center.y {
				p = 0.25
			} else {
				p = 0.5
			}
		}
		
		var i: Int = Int(floor(Double(thePoints.count) * p))
		
		var closestPoint = thePoints[i]
		var closestDistance = quickDistanceBetween(targetPoint, closestPoint)
		
		i += 1
		var nextPoint = thePoints[i]
		var nextDist = quickDistanceBetween(targetPoint, nextPoint)
		
		while nextDist < closestDistance {
			closestPoint = nextPoint
			closestDistance = nextDist
			i += 1
			nextPoint = i < thePoints.count ? thePoints[i] : thePoints[0]
			nextDist = quickDistanceBetween(targetPoint, nextPoint)
		}
		
		return closestPoint
	}
	
	private func generatePoints(center: CGPoint, a: CGFloat, b: CGFloat, numberOfPoints: Int) {
		thePoints = pointsOnEllipse(center: center, a: a, b: b, numberOfPoints: numberOfPoints)
	}
	private func pointsOnEllipse(center: CGPoint, a: CGFloat, b: CGFloat, numberOfPoints: Int) -> [CGPoint] {
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
	
	// returns the distance between points
	//	uses sqrt() to get the *actual* distance
	private func distanceBetween(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
		let deltaX = point2.x - point1.x
		let deltaY = point2.y - point1.y
		return sqrt(deltaX * deltaX + deltaY * deltaY)
	}
	
	// returns the *squared* distance between points
	//	use this if we don't care about the *actual* distance
	// this will be faster because we're not calling sqrt()
	private func quickDistanceBetween(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
		let deltaX = point2.x - point1.x
		let deltaY = point2.y - point1.y
		return deltaX * deltaX + deltaY * deltaY
	}
	
}


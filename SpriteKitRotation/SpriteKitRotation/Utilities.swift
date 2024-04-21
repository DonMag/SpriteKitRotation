//
//  Utilities.swift
//  SpriteKitRotation
//
//  Created by Don Mag on 4/21/24.
//

import UIKit

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



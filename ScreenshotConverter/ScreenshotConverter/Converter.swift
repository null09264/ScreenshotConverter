//
//  Converter.swift
//  ScreenshotConverter
//
//  Created by Jinghan Wang on 28/3/17.
//  Copyright © 2017 Jinghan Wang. All rights reserved.
//

import Cocoa
import CoreGraphics

class Converter: NSObject {
	static func convertScreenshot(image: NSImage) -> NSImage {
		let template = NSImage(contentsOf: URL(string: TEMPLATE_DATA_URL)!)!
		
		// The canvas size will base on iPhone 6s
		// Images in other sizes will be resized to canvasSize before putting into the mockup
		let canvasSize = CGSize(width: 750, height: 1334)
		
		let imageRepresentation = NSBitmapImageRep(
			bitmapDataPlanes: nil,
			pixelsWide: Int(template.size.width),
			pixelsHigh: Int(template.size.height),
			bitsPerSample: 8,
			samplesPerPixel: 4,
			hasAlpha: true,
			isPlanar: false,
			colorSpaceName: NSCalibratedRGBColorSpace,
			bytesPerRow: 0,
			bitsPerPixel: 0
		)!
		
		let result = NSImage(size: template.size)
		
		result.addRepresentation(imageRepresentation)
		result.lockFocus()
		
		let offset = CGPoint.zero
		
		let origin = CGPoint(
			x: result.size.width / 2 - canvasSize.width / 2 + offset.x,
			y: result.size.height / 2 - canvasSize.height / 2 + offset.y
		)
		
		if let context = NSGraphicsContext.current()?.cgContext {
			context.draw(template.cgImage, in: CGRect(origin: .zero, size: template.size))
			context.draw(image.cgImage, in: CGRect(origin: origin, size: canvasSize))
		}
		
		result.unlockFocus()
		
		return result
	}
}

extension NSImage {
	var cgImage: CGImage {
		get {
			let imageData = self.tiffRepresentation
			let source = CGImageSourceCreateWithData(imageData as! CFData, nil)!
			let maskRef = CGImageSourceCreateImageAtIndex(source, 0, nil)!
			return maskRef
		}
	}
	
	var pngData: Data? {
		return tiffRepresentation?.bitmap?.png
	}
	
	func savePNG(to url: URL) -> Bool {
		do {
			try self.pngData?.write(to: url)
			
			return true
		} catch {
			print(error)
			return false
		}
		
	}
}

extension NSBitmapImageRep {
	var png: Data? {
		return self.representation(using: .PNG, properties: [:])
	}
}

extension Data {
	var bitmap: NSBitmapImageRep? {
		return NSBitmapImageRep(data: self)
	}
}

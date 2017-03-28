//
//  main.swift
//  ScreenshotConverter
//
//  Created by Jinghan Wang on 28/3/17.
//  Copyright © 2017 Jinghan Wang. All rights reserved.
//

import Cocoa


let arguments = Array(CommandLine.arguments.dropFirst())

if arguments.count > 0 {
	let input = arguments[0]
	
	if let image = NSImage(byReferencingFile: input) {
		let result = Converter.convertScreenshot(image: image)
		
		var output = "file:///"
		if arguments.count > 1 {
			output += arguments[1]
		} else {
			let directory = (input as NSString).deletingLastPathComponent
			output += directory + "/output-" + (input as NSString).lastPathComponent
		}
		
		if let outputUrl = URL(string: output) {
			if result.savePNG(to: outputUrl) {
				print("Coversion Succeeded")
			} else {
				print("Coversion Failed")
			}
		} else {
			print("Output path not found.")
		}
	} else {
		print("Input image not found.")
	}
} else {
	print("Command format: ScreenshotConvert <input-file-path> [<output-file-path>]")
}

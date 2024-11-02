//
//  SafariWebExtensionHandler.swift
//  NiceCopy for Safari
//
//  Created by Marlon Raskin on 2024-10-05.
//

import Foundation
import os.log
import SafariServices

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {
	
	func beginRequest(with context: NSExtensionContext) {
		if
			let item = context.inputItems.first as? NSExtensionItem,
			let message = item.userInfo?[SFExtensionMessageKey] as? [String: Any],
			let action = message["action"] as? String
		{
			if action == "sendUrl" {
				if let url = message["url"] as? String {
					print("Received URL from JavaScript: \(url)")
					
					// Copy the URL to the clipboard
					let pasteboard = NSPasteboard.general
					pasteboard.clearContents()
					pasteboard.setString(url, forType: .string)
					
					print("URL copied to clipboard")
					
					let response = NSExtensionItem()
					response.userInfo = [SFExtensionMessageKey: ["status": "Copied URL"]]
					
					context.completeRequest(returningItems: [response])
				}
			} else if action == "openApp" {
				openApp()
				
				let response = NSExtensionItem()
				response.userInfo = [SFExtensionMessageKey: ["status": "Opened NiceCopy app"]]
				
				context.completeRequest(returningItems: [response])
			}
		}
	}
	
	// Runs a terminal command to open NiceCopy app (menu bar)
	private func openApp() {
		let process = Process()
		process.executableURL = URL(fileURLWithPath: "/usr/bin/open")
		process.arguments = ["-a", "NiceCopy"]
		
		do {
			try process.run()
			process.waitUntilExit()
			if process.terminationStatus == 0 {
				os_log("Successfully opened NiceCopy app.")
			} else {
				os_log("Failed to open NiceCopy app with termination status: %d", process.terminationStatus)
			}
		} catch {
			os_log("Error running process: %@", error.localizedDescription)
		}
	}
}

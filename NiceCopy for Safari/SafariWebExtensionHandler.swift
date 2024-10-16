//
//  SafariWebExtensionHandler.swift
//  NiceCopy for Safari
//
//  Created by Marlon Raskin on 2024-10-05.
//

import SafariServices
import os.log

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
		 if
			let item = context.inputItems.first as? NSExtensionItem,
			let message = item.userInfo?[SFExtensionMessageKey] as? [String: Any],
			let action = message["action"] as? String
		 {
			 if action == "sendUrl", let url = message["url"] as? String {
				 print("Received URL from JavaScript: \(url)")
				 
				 // Copy the URL to the clipboard
				 let pasteboard = NSPasteboard.general
				 pasteboard.clearContents()
				 pasteboard.setString(url, forType: .string)
				 
				 print("URL copied to clipboard")
				 
				 let response = NSExtensionItem()
				 response.userInfo = [SFExtensionMessageKey: ["status": "Copied Current URL"]]
				 
				 context.completeRequest(returningItems: [response])
			 }
		 }
    }
}

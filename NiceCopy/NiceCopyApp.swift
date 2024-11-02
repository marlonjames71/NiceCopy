//
//  NiceCopyApp.swift
//  NiceCopy
//
//  Created by Marlon Raskin on 2024-10-05.
//

import Cocoa
import SwiftUI

@main
struct NiceCopyApp: App {
		
	@Environment(\.openWindow) var openWindow
	
	var body: some Scene {
		MenuBarExtra {
			Button("Settings & Info") {
				openWindow(id: "open_app")
			}
			Button("Quit NiceCopy") {
				NSApp.terminate(self)
			}
		} label: {
			let image: NSImage = {
				let ratio = $0.size.height / $0.size.width
				$0.size.height = 18
				$0.size.width = 18 / ratio
				$0.isTemplate = true
				return $0
			}(NSImage(resource: .niceCopyIcon))
			
			Image(nsImage: image)
		}
		
		Window("NiceCopy", id: "open_app") {
			SettingsView()
		}
		.windowResizability(.contentSize)
		.windowLevel(.floating)
		.defaultLaunchBehavior(.suppressed)
	}
}

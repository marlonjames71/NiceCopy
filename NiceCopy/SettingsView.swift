//
//  SettingsView.swift
//  NiceCopy
//
//  Created by Marlon Raskin on 2024-10-05.
//

import SwiftUI
import AppKit
import UniformTypeIdentifiers

struct SettingsView: View {
	@State private var isExporting = false
	@State private var exportingBrowser: BrowserType?
	@State private var showingExportHelp = false
	
	var body: some View {
		Form {
			Section {
				VStack(alignment: .leading, spacing: 8) {
					Text("Info")
						.font(.title3)
						.fontWeight(.bold)
					
					Text("NiceCopy needs to stay open to write URLs to the clipboard due to Safari Web Extension limits. However, it won't appear in your dock or app switcher. You can always reopen this window from the menu bar and clicking the \"Settings & Info\" option.\n\nIf you'd like to quit NiceCopy, make sure you disable the extension first as it will just reopen the app in the background if you don't. Once the extension is disabled, you can quit NiceCopy by clicking the \"Quit NiceCopy\" option in the menu bar. If you'd like to reopen the menu bar app, right-click the extension icon in Safari and choose \"Open NiceCopy App\".")
						.multilineTextAlignment(.leading)
						.opacity(0.8)
				}
			}
			
			Section {
				VStack(alignment: .leading) {
					Text("How to Use")
						.font(.title3)
						.fontWeight(.bold)
					
					Group {
						listItem(Text("Press  ⌘ ⇧ C  to copy the current tab's URL."))
						listItem(Text("Click the extension icon to copy the current tab's URL."))
						listItem(Text("Right-click anywhere on the webpage and select \"Copy Page URL\"."))
					}
					.opacity(0.8)
				}
			}
			
			Section {
				VStack(alignment: .leading, spacing: 8) {
					HStack {
						Text("Browser Extensions")
							.font(.title3)
							.fontWeight(.bold)
						
						Button {
							showingExportHelp = true
						} label: {
							Image(systemName: "questionmark.circle")
								.foregroundStyle(.secondary)
						}
						.buttonStyle(.plain)
						.help("Learn more about browser extensions")
					}
					
					Text("NiceCopy is available for other browsers too. When you export the extension, a folder will open containing the extension files and instructions:")
						.multilineTextAlignment(.leading)
						.opacity(0.8)
					
					VStack(alignment: .leading, spacing: 4) {
						Text("• The extension files needed for installation")
							.opacity(0.8)
						Text("• A README with step-by-step instructions")
							.opacity(0.8)
						Text("• A ZIP file for easy sharing or distribution")
							.opacity(0.8)
					}
					.padding(.vertical, 4)
					
					HStack(spacing: 12) {
						Button(action: exportForChromium) {
							Label {
								Text("Add to Chromium")
							} icon: {
								if isExporting && exportingBrowser == .chromium {
									ProgressView()
										.controlSize(.small)
								} else {
									Image(systemName: BrowserType.chromium.iconName)
										.foregroundStyle(BrowserType.chromium.color)
										.symbolRenderingMode(.hierarchical)
								}
							}
							.frame(maxWidth: .infinity)
						}
						.buttonStyle(.bordered)
						.controlSize(.large)
						.disabled(isExporting)
						
						Button(action: exportForFirefox) {
							Label {
								Text("Add to Firefox")
							} icon: {
								if isExporting && exportingBrowser == .firefox {
									ProgressView()
										.controlSize(.small)
								} else {
									Image(systemName: BrowserType.firefox.iconName)
										.foregroundStyle(BrowserType.firefox.color)
										.symbolRenderingMode(.hierarchical)
								}
							}
							.frame(maxWidth: .infinity)
						}
						.buttonStyle(.bordered)
						.controlSize(.large)
						.disabled(isExporting)
					}
					.padding(.vertical, 4)
				}
			}
			
			Section {
				Link(destination: URL(string: "https://github.com/marlonjames71/NiceCopy")!) {
					HStack {
						Label("Source Code & Contribution", systemImage: "chevron.left.forwardslash.chevron.right")
						Spacer()
						Image(systemName: "arrow.up.forward.app")
							.foregroundStyle(.secondary)
					}
				}
				Link(destination: URL(string: "https://github.com/marlonjames71/NiceCopy/blob/main/Privacy%20Policy.md")!) {
					HStack {
						Label("Privacy Policy", systemImage: "shield.lefthalf.fill")
						Spacer()
						Image(systemName: "arrow.up.forward.app")
							.foregroundStyle(.secondary)
					}
				}
			}
			
			Section {
				VStack(alignment: .leading, spacing: 8) {
					Text("Attribution")
						.font(.title3)
						.fontWeight(.bold)
					
					listItem(Text("Vectors and icons by [Microsoft](https://github.com/microsoft/vscode-codicons?ref=svgrepo.com) in MIT License via [SVG Repo](https://www.svgrepo.com)"))
					listItem(Text("App icon by [Noah Raskin](https://x.com/noahraskin_)"))
				}
			}
		}
		.formStyle(.grouped)
		.navigationTitle("NiceCopy Settings & Info")
		.sheet(isPresented: $showingExportHelp) {
			ExportHelpView()
		}
	}
	
	private func listItem(_ text: Text) -> some View {
		Group { Text("• ").monospaced() + text }
		.padding(.vertical, 2)
		.padding(.horizontal, 5)
	}
	
	private func exportForChromium() {
		exportingBrowser = .chromium
		isExporting = true
		
		// Use a background task to avoid blocking the UI
		DispatchQueue.global(qos: .userInitiated).async {
			self.exportExtension(for: .chromium)
			
			// Update the UI on the main thread
			DispatchQueue.main.async {
				self.isExporting = false
				self.exportingBrowser = nil
			}
		}
	}
	
	private func exportForFirefox() {
		exportingBrowser = .firefox
		isExporting = true
		
		// Use a background task to avoid blocking the UI
		DispatchQueue.global(qos: .userInitiated).async {
			self.exportExtension(for: .firefox)
			
			// Update the UI on the main thread
			DispatchQueue.main.async {
				self.isExporting = false
				self.exportingBrowser = nil
			}
		}
	}
	
	private func exportExtension(for browser: BrowserType) {
		// Check if the browser is installed
		if !isBrowserInstalled(browser) {
			DispatchQueue.main.async {
				let alert = NSAlert()
				alert.messageText = "Browser Not Found"
				alert.informativeText = "Could not find \(browser.displayName) installed on your system. Please install it first."
				alert.alertStyle = .warning
				alert.addButton(withTitle: "OK")
				alert.runModal()
			}
			return
		}
		
		// Create a temporary directory to store the extension
		let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent("NiceCopy-\(browser.rawValue)")
		let extensionURL = Bundle.main.bundleURL.appendingPathComponent("Contents/PlugIns/NiceCopy for Safari.appex/Contents/Resources")
		
		do {
			// Create the directory if it doesn't exist
			try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true, attributes: nil)
			
			// Copy the extension files
			try copyExtensionFiles(from: extensionURL, to: tempDir, for: browser)
			
			// Open the directory in Finder on the main thread
			DispatchQueue.main.async {
				NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: tempDir.path)
				
				// Show success message with clearer instructions
				let alert = NSAlert()
				alert.messageText = "Extension Ready for Installation"
				alert.informativeText = """
				The NiceCopy extension for \(browser.displayName) has been exported.

				What's next:
				1. A folder has opened containing the extension files
				2. Follow the instructions in the README.md file
				3. The extension will be ready to use after installation

				Need help? Click the "?" button next to "Browser Extensions" in the settings.
				"""
				alert.alertStyle = .informational
				alert.addButton(withTitle: "OK")
				alert.runModal()
			}
		} catch {
			// Show error message on the main thread
			DispatchQueue.main.async {
				let alert = NSAlert()
				alert.messageText = "Export Failed"
				alert.informativeText = "Failed to export the extension: \(error.localizedDescription)"
				alert.alertStyle = .critical
				alert.addButton(withTitle: "OK")
				alert.runModal()
			}
		}
	}
	
	private func copyExtensionFiles(from source: URL, to destination: URL, for browser: BrowserType) throws {
		// Copy all files from the extension directory
		let fileManager = FileManager.default
		let contents = try fileManager.contentsOfDirectory(at: source, includingPropertiesForKeys: nil)
		
		for url in contents {
			let fileName = url.lastPathComponent
			let destinationURL = destination.appendingPathComponent(fileName)
			
			// Skip .DS_Store files
			if fileName == ".DS_Store" { continue }
			
			// If it's a directory, recursively copy its contents
			var isDir: ObjCBool = false
			if fileManager.fileExists(atPath: url.path, isDirectory: &isDir), isDir.boolValue {
				try fileManager.createDirectory(at: destinationURL, withIntermediateDirectories: true)
				try copyExtensionFiles(from: url, to: destinationURL, for: browser)
			} else {
				// If it's the manifest file, modify it for the target browser
				if fileName == "manifest.json" {
					try modifyManifest(from: url, to: destinationURL, for: browser)
				} else {
					try fileManager.copyItem(at: url, to: destinationURL)
				}
			}
		}
		
		// Create a README file with installation instructions
		let readmeContent = browser.installationInstructions
		try readmeContent.write(to: destination.appendingPathComponent("README.md"), atomically: true, encoding: .utf8)
		
		// Create a ZIP file for easier distribution
		createZipFile(from: destination, for: browser)
	}
	
	private func createZipFile(from directory: URL, for browser: BrowserType) {
		let zipFileName = "NiceCopy-\(browser.rawValue).zip"
		let zipFilePath = directory.deletingLastPathComponent().appendingPathComponent(zipFileName)
		
		// Create a shell command to zip the directory
		let process = Process()
		process.executableURL = URL(fileURLWithPath: "/usr/bin/zip")
		process.arguments = ["-r", zipFilePath.path, directory.lastPathComponent]
		process.currentDirectoryURL = directory.deletingLastPathComponent()
		
		do {
			try process.run()
			process.waitUntilExit()
			
			// Check if the zip was created successfully
			if process.terminationStatus == 0 {
				// Copy the zip file to the directory for easy access
				try FileManager.default.copyItem(at: zipFilePath, to: directory.appendingPathComponent(zipFileName))
			}
		} catch {
			print("Failed to create ZIP file: \(error.localizedDescription)")
		}
	}
	
	private func modifyManifest(from source: URL, to destination: URL, for browser: BrowserType) throws {
		let data = try Data(contentsOf: source)
		guard var manifest = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
			throw NSError(domain: "com.nicecopy.error", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid manifest format"])
		}
		
		// Modify the manifest based on the browser type
		switch browser {
		case .chromium:
			// Chromium uses the same manifest format as Safari (Manifest V3)
			break
		case .firefox:
			// Firefox requires some modifications for compatibility
			if manifest["manifest_version"] as? Int == 3 {
				// Firefox supports Manifest V2 and V3, but some properties might need adjustment
				if var background = manifest["background"] as? [String: Any] {
					// Firefox uses background.scripts instead of service_worker
					if let scripts = background["scripts"] as? [String] {
						background["scripts"] = scripts
						manifest["background"] = background
					}
				}
			}
		}
		
		// Write the modified manifest
		let modifiedData = try JSONSerialization.data(withJSONObject: manifest, options: [.prettyPrinted])
		try modifiedData.write(to: destination)
	}
	
	private func isBrowserInstalled(_ browser: BrowserType) -> Bool {
		let fileManager = FileManager.default
		
		switch browser {
		case .chromium:
			// Check for common Chromium-based browsers
			let chromePaths = [
				"/Applications/Google Chrome.app",
				"/Applications/Microsoft Edge.app",
				"/Applications/Brave Browser.app",
				"/Applications/Vivaldi.app",
				"/Applications/Opera.app"
			]
			
			return chromePaths.contains { fileManager.fileExists(atPath: $0) }
			
		case .firefox:
			// Check for Firefox
			return fileManager.fileExists(atPath: "/Applications/Firefox.app")
		}
	}
}

enum BrowserType: String {
	case chromium = "chromium"
	case firefox = "firefox"
	
	var displayName: String {
		switch self {
		case .chromium: return "Chromium (Chrome, Edge, Brave, etc.)"
		case .firefox: return "Firefox"
		}
	}
	
	var color: Color {
		switch self {
		case .chromium: return Color(red: 0.29, green: 0.56, blue: 0.89)
		case .firefox: return Color(red: 0.96, green: 0.39, blue: 0.13)
		}
	}
	
	var iconName: String {
		switch self {
		case .chromium: return "safari.fill" // Using Safari icon as a placeholder
		case .firefox: return "safari.fill"  // Using Safari icon as a placeholder
		}
	}
	
	var installationInstructions: String {
		switch self {
		case .chromium:
			return """
			# Installing NiceCopy in Chromium-based Browsers
			
			## Installation Steps
			
			1. Open your Chromium-based browser (Chrome, Edge, Brave, etc.)
			2. Navigate to `chrome://extensions/`
			3. Enable "Developer mode" using the toggle in the top-right corner
			4. Click "Load unpacked"
			5. Select this folder
			6. The NiceCopy extension should now be installed and ready to use
			
			## Usage
			
			- Press `Cmd+Shift+C` to copy the current tab's URL
			- Click the extension icon to copy the current tab's URL
			- Right-click anywhere on the webpage and select "Copy Page URL"
			
			## Note
			
			This is a side-loaded version of NiceCopy. For the best experience, consider using the Safari version which integrates with the macOS menu bar app.
			"""
		case .firefox:
			return """
			# Installing NiceCopy in Firefox
			
			## Installation Steps
			
			1. Open Firefox
			2. Navigate to `about:debugging#/runtime/this-firefox`
			3. Click "Load Temporary Add-on..."
			4. Select the `manifest.json` file in this folder
			5. The NiceCopy extension should now be installed and ready to use
			
			## For Permanent Installation
			
			To install the extension permanently, you need to package it and have it signed by Mozilla:
			
			1. Zip the contents of this folder
			2. Go to [Mozilla Add-on Developer Hub](https://addons.mozilla.org/en-US/developers/)
			3. Create an account if you don't have one
			4. Submit your extension for review
			
			## Usage
			
			- Press `Cmd+Shift+C` to copy the current tab's URL
			- Click the extension icon to copy the current tab's URL
			- Right-click anywhere on the webpage and select "Copy Page URL"
			
			## Note
			
			This is a side-loaded version of NiceCopy. For the best experience, consider using the Safari version which integrates with the macOS menu bar app.
			"""
		}
	}
}

// Add a new view for the help sheet
struct ExportHelpView: View {
	var body: some View {
		NavigationStack {
			ScrollView {
				VStack(alignment: .leading, spacing: 20) {
					Group {
						VStack(alignment: .leading, spacing: 8) {
							Text("About Browser Extensions")
								.font(.title2)
								.fontWeight(.bold)
							
							Text("NiceCopy can be installed in multiple browsers. Each browser has its own way of handling extensions, which is why the installation process differs slightly between them.")
								.opacity(0.8)
						}
						
						VStack(alignment: .leading, spacing: 8) {
							Text("Installation Process")
								.font(.title2)
								.fontWeight(.bold)
							
							Text("When you click one of the browser extension buttons:")
								.opacity(0.8)
							
							VStack(alignment: .leading, spacing: 4) {
								Text("1. A folder will open containing:")
									.opacity(0.8)
								Text("   • The extension files")
									.opacity(0.8)
								Text("   • A README with instructions")
									.opacity(0.8)
								Text("   • A ZIP file for sharing")
									.opacity(0.8)
								
								Text("\n2. Follow the README instructions")
									.opacity(0.8)
								Text("\n3. The extension will be ready to use")
									.opacity(0.8)
							}
						}
						
						VStack(alignment: .leading, spacing: 8) {
							Text("Browser-Specific Notes")
								.font(.title2)
								.fontWeight(.bold)
							
							Text("Chromium Browsers (Chrome, Edge, Brave)")
								.font(.headline)
							Text("• Installation is permanent until manually removed")
								.opacity(0.8)
							Text("• Works with any Chromium-based browser")
								.opacity(0.8)
							
							Text("\nFirefox")
								.font(.headline)
							Text("• Temporary installation (removed on browser restart)")
								.opacity(0.8)
							Text("• For permanent installation, submit to Mozilla")
								.opacity(0.8)
						}
						
						VStack(alignment: .leading, spacing: 8) {
							Text("Troubleshooting")
								.font(.title2)
								.fontWeight(.bold)
							
							Text("If you encounter any issues:")
								.opacity(0.8)
							
							VStack(alignment: .leading, spacing: 4) {
								Text("• Make sure your browser is up to date")
									.opacity(0.8)
								Text("• Check if developer mode is enabled (Chromium)")
									.opacity(0.8)
								Text("• Try restarting your browser")
									.opacity(0.8)
								Text("• Visit our GitHub page for support")
									.opacity(0.8)
							}
						}
					}
					.padding(.horizontal)
				}
				.padding(.vertical)
			}
			.navigationTitle("Browser Extension Help")
		}
		.frame(width: 500, height: 600)
	}
}

#Preview {
	SettingsView()
		.frame(width: 500)
}

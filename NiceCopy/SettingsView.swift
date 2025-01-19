//
//  SettingsView.swift
//  NiceCopy
//
//  Created by Marlon Raskin on 2024-10-05.
//

import SwiftUI

struct SettingsView: View {
	@AppStorage("copyURLShortcut") private var copyURLShortcut: String = "⌘ ⇧ C"
	
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
						listItem(Text("Press  ⌘ ⇧ C (default) to copy the current tab's URL. You can change this shortcut in the Keyboard Shortcuts section below."))
						listItem(Text("Click the extension icon to copy the current tab's URL."))
						listItem(Text("Right-click anywhere on the webpage and select \"Copy Page URL\"."))
					}
					.opacity(0.8)
				}
			}
			
			Section {
				Link(destination: URL(string: "https://github.com/marlonjames71/NiceCopy")!) {
					HStack {
						Label("Source Code & Contribution", image: .githubFill)
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
			
			Section(header: Text("Keyboard Shortcuts")) {
				HStack {
					Text("Copy URL")
					Spacer()
					KeyboardShortcutRecorder(shortcut: $copyURLShortcut)
				}
			}
		}
		.formStyle(.grouped)
		.navigationTitle("NiceCopy Settings & Info")
	}
	
	private func listItem(_ text: Text) -> some View {
		Group { Text("• ").monospaced() + text }
		.padding(.vertical, 2)
		.padding(.horizontal, 5)
	}
}

struct KeyboardShortcutRecorder: View {
	@Binding var shortcut: String
	@State private var isRecording = false
	
	var body: some View {
		Button(action: {
			isRecording.toggle()
		}) {
			Text(shortcut.isEmpty ? "Click to record" : shortcut)
				.frame(width: 150)
		}
		.buttonStyle(.bordered)
		.onAppear {
			NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
				if isRecording {
					let modifiers = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
					let key = event.charactersIgnoringModifiers ?? ""
					
					if !key.isEmpty {
						shortcut = modifierString(from: modifiers) + key.uppercased()
						isRecording = false
					}
				}
				return event
			}
		}
	}
	
	private func modifierString(from flags: NSEvent.ModifierFlags) -> String {
		var modifiers: [String] = []
		
		if flags.contains(.command) { modifiers.append("⌘") }
		if flags.contains(.shift) { modifiers.append("⇧") }
		if flags.contains(.option) { modifiers.append("⌥") }
		if flags.contains(.control) { modifiers.append("⌃") }
		
		return modifiers.joined() + (modifiers.isEmpty ? "" : " ")
	}
}

#Preview {
	SettingsView()
		.frame(width: 500)
}

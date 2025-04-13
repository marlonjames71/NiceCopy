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
				Link(destination: URL(string: "https://github.com/marlonjames71/NiceCopy")!) {
					HStack {
						Label("Source Code & Contribution", image: .githubFill)
						Spacer()
						Image(systemName: "arrow.up.forward.app")
					}
				}
				
				Link(destination: URL(string: "https://github.com/marlonjames71/NiceCopy/blob/main/Privacy%20Policy.md")!) {
					HStack {
						Label("Privacy Policy", systemImage: "shield.lefthalf.fill")
						Spacer()
						Image(systemName: "arrow.up.forward.app")
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
	}
	
	private func listItem(_ text: Text) -> some View {
		Group { Text("• ").monospaced() + text }
			.padding(.vertical, 2)
			.padding(.horizontal, 5)
	}
}

#Preview {
	SettingsView()
		.frame(width: 500)
}

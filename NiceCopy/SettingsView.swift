//
//  SettingsView.swift
//  NiceCopy
//
//  Created by Marlon Raskin on 2024-10-05.
//

import SwiftUI

struct SettingsView: View {
	var body: some View {
		Form {
			Section {
				VStack(alignment: .leading, spacing: 8) {
					Text("Info")
						.font(.title3)
						.fontWeight(.bold)
					
					Text("NiceCopy needs to stay open to write URLs to the clipboard due to Safari Web Extension limits. However, it won't appear in your dock or app switcher. You can always reopen this window from the menu bar and clicking the \"Settings\" option.\n\nIf you'd like to quit NiceCopy, make sure you disable the extension first as it will just reopen the app. Once the extension is disabled, you can quit NiceCopy by clicking the \"Quit\" option.")
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
				Link(destination: URL(string: "https://google.com")!) {
					HStack {
						Label("Source Code & Contribution", image: .githubFill)
						Spacer()
						Image(systemName: "arrow.up.forward.app")
							.foregroundStyle(.secondary)
					}
				}
				Link(destination: URL(string: "https://google.com")!) {
					HStack {
						Label("Privacy Policy", systemImage: "shield.lefthalf.fill")
						Spacer()
						Image(systemName: "arrow.up.forward.app")
							.foregroundStyle(.secondary)
					}
				}
				.tint(.primary)
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

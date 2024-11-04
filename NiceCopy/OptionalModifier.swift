//
//  OptionalModifier.swift
//  NiceCopy
//
//  Created by Marlon Raskin on 2024-11-04.
//

import SwiftUI

extension View {
	@ViewBuilder
	func modifiers<Content: View>(@ViewBuilder content: @escaping (Self) -> Content) -> some View {
		content(self)
	}
}

extension Scene {
	@SceneBuilder
	func modifiers<Content: Scene>(@SceneBuilder content: @escaping (Self) -> Content) -> some Scene {
		content(self)
	}
}

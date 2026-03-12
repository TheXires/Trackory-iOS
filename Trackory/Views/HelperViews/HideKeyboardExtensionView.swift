//
//  HideKeyboardExtensionView.swift
//  Trackory
//
//  Created by Robin Beckmann on 28.01.26.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

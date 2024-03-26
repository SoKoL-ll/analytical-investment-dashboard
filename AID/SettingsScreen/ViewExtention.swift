//
//  ViewExtention.swift
//  SettingsScreenInSwiftUI
//
//  Created by Egor Anoshin on 25.03.2024.
//

import Foundation
import SwiftUI

extension View {
    func limitInputLength(to maxLength: Int) -> some View {
        self.modifier(LimitInputLengthModifier(maxLength: maxLength))
    }
}

struct LimitInputLengthModifier: ViewModifier {
    let maxLength: Int
    
    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification)) { notification in
                if let textField = notification.object as? UITextField, let text = textField.text, text.count > maxLength {
                    textField.text = String(text.prefix(maxLength))
                }
            }
    }
}

//
//  EmailCopyView.swift
//  AID
//
//  Created by Egor Anoshin on 28.03.2024.
//

import SwiftUI

struct EmailCopyView: View {
    var email: String
    @Binding var showCopiedMessage: Bool

    var body: some View {
        HStack {
            Image(systemName: "envelope")
                .resizable()
                .frame(width: 23, height: 18)

            Button(action: {
                if let url = URL(string: "mailto:\(email)") {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("Contact us!")
                    .foregroundColor(.blue)
            }

            Spacer()
            Text(email)
                .padding(8)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                )
            Button(action: {
                UIPasteboard.general.string = email
                withAnimation {
                    showCopiedMessage = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showCopiedMessage = false
                    }
                }
            }) {
                Image(systemName: "doc.on.doc")
                    .foregroundColor(.blue)
                    .font(.system(size: 22))
            }
        }
        .padding(.vertical, 6)
    }
}

//
//  PreferencesSectionView.swift
//  SettingsScreenInSwiftUI
//
//  Created by Egor Anoshin on 25.03.2024.
//

import Foundation
import SwiftUI

struct PreferencesSectionView: View {
    @Binding var languageIndex: Int
    let languageOptions: [String]
    @AppStorage("isDarkModeEnabled") var isDarkModeEnabled: Bool = false
    @State private var showingShareSheet = false
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("PREFERENCES")
                .font(.headline)
                .padding(.top, 20)
            
            Divider()
            
            HStack {
                Image(systemName: "globe")
                    .resizable()
                    .frame(width: 23, height: 23)
                Text("Language")
                Spacer()
                Picker("Select", selection: $languageIndex) {
                    ForEach(0 ..< languageOptions.count, id: \.self) {
                        Text(self.languageOptions[$0])
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            Divider()
            
            HStack {
                Image(systemName: "moon.fill")
                    .resizable()
                    .frame(width: 23, height: 23)
                Text("Dark Mode")
                    .frame(width: 120, alignment: .leading)
                Spacer()
                Toggle("", isOn: $isDarkModeEnabled)
            }
            .padding(.vertical, 4)
            
            Divider()
            
            HStack {
                Image(systemName: "envelope")
                    .resizable()
                    .frame(width: 23, height: 23)
                Link("Contact us", destination: URL(string: "mailto:dreamteam@gmail.com")!)
            }
            .padding(.vertical, 4)
            
            Divider()
            
            HStack {
                Image(systemName: "square.and.arrow.up")
                    .resizable()
                    .frame(width: 23, height: 23)
                Button("Share") {
                    showingShareSheet = true
                }
                .sheet(isPresented: $showingShareSheet) {
                    ActivityView(activityItems: [URL(string: "https://www.apple.com")!])
                }
            }
            .padding(.vertical, 4)
            
            Divider()
        }
        .padding(.horizontal)
    }
}



struct ActivityView: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {
    }
}

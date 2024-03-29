import Foundation
import SwiftUI

struct PreferencesSectionView: View {
    @Binding var languageIndex: Int
    let languageOptions: [String]
    @State private var showingShareSheet = false
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var themeManager = ThemeManager.shared
    @State private var showCopiedMessage: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("ПЕРСОНАЛЬНЫЕ НАСТРОЙКИ")
                .font(.headline)
                .padding(.top, 20)
            
            Divider()
            
            HStack {
                Image(systemName: "globe")
                    .resizable()
                    .frame(width: 23, height: 23)
                Text("Язык")
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
                Image(systemName: "moon")
                    .resizable()
                    .frame(width: 23, height: 23)
                Text("Тема")
                    .frame(width: 70, alignment: .leading)
                Spacer()
                Picker("Theme", selection: $themeManager.selectedThemeIndex) {
                    Text("Системная").tag(0)
                    Text("Светлая").tag(1)
                    Text("Темная").tag(2)
                }
                .frame(width: 250)
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding(.vertical, 4)
            
            Divider()
            
            EmailCopyView(email: "dreamteam@gmail.com", showCopiedMessage: $showCopiedMessage)
            
            Divider()
            
            HStack {
                Image(systemName: "square.and.arrow.up")
                    .resizable()
                    .frame(width: 21, height: 29)
                    .padding(.leading, 2)
                Button("Поделиться") {
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
    var applicationActivities: [UIActivity]?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {
    }
}

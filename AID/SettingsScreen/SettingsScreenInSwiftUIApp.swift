
import SwiftUI

@main
struct SettingsScreenInSwiftUIApp: App {
    @AppStorage("isDarkModeEnabled") var isDarkModeEnabled: Bool = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkModeEnabled ? .dark : .light)
        }
    }
}

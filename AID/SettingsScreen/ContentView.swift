import SwiftUI

struct ContentView: View {
    
    @State private var languageIndex = 0
    @State private var metricIndex = 0
    @State private var bubblesIndex = 0
    var languageOptions = ["Русский", "English", "中国人"]
    var metricOptions = ["Total value", "MSE", "MAE", "RMSE", "MS5", "MS10"]
    
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingFavorites = false
    @State private var profileImage: UIImage? = UIImage.loadImage() ?? UIImage(named: "DefaultProfilePic")
    
    @State private var userName: String = UserDefaults.standard.string(forKey: "userName") ?? ""
    
    init() {
        _userName = State(initialValue: UserDefaults.standard.string(forKey: "userName") ?? "")
    }
    
    func saveUserName() {
        UserDefaults.standard.set(self.userName, forKey: "userName")
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    UserProfileSection(profileImage: $profileImage, userName: $userName, onPhotoTap: {
                        self.showingImagePicker = true
                    })
                    .padding(.bottom)
                    .onChange(of: userName) { _ in
                        saveUserName()
                    }
                    
                    StockSettingsSection(metricIndex: $metricIndex, bubblesIndex: $bubblesIndex, metricOptions: metricOptions, showingFavorites: $showingFavorites)
                    
                    PreferencesSectionView(languageIndex: $languageIndex, languageOptions: languageOptions)
                    
                    
                }
            }
            
            .navigationBarTitle("Settings")
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
        }
        .onAppear {
            self.profileImage = UIImage.loadImage() ?? UIImage(named: "DefaultProfilePic")
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        profileImage = inputImage.cropToBounds(image: inputImage, width: Double(inputImage.size.width), height: Double(inputImage.size.width))
        UIImage.saveImage(profileImage!)
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

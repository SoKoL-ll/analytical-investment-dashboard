//
//  AccountViewController.swift
//  AID
//
//  Created by Alexandr Sokolov on 21.03.2024.
//

import Foundation
import UIKit
import SwiftUI

struct ProfileView: View {
    @State private var languageIndex: Int = UserDefaults.standard.integer(forKey: "languageIndex")
    @State private var metricIndex: Int = UserDefaults.standard.integer(forKey: "metricIndex")
    @State private var bubblesIndex: Int = UserDefaults.standard.integer(forKey: "bubblesIndex")
    
    var languageOptions = ["Русский", "English", "中国人"]
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingFavorites = false
    @State private var profileImage: UIImage? = UIImage.loadImage() ?? UIImage(named: "DefaultProfilePic")
    @State private var userName: String = UserDefaults.standard.string(forKey: "userName") ?? ""
    
    @StateObject private var stockSettingsViewModel = StockSettingsViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    UserProfileSection(
                        profileImage: $profileImage,
                        userName: Binding(
                            get: { self.userName },
                            set: { newValue in
                                self.userName = newValue
                                UserDefaults.standard.set(newValue, forKey: "userName")
                            }
                        ),
                        onPhotoTap: {
                            self.showingImagePicker = true
                        }
                    )
                    .padding(.bottom)
                    
                    StockSettingsSection(
                        metricIndex: Binding(
                            get: { self.metricIndex },
                            set: { newValue in
                                self.metricIndex = newValue
                                UserDefaults.standard.set(newValue, forKey: "metricIndex")
                            }
                        ),
                        bubblesIndex: Binding(
                            get: { self.bubblesIndex },
                            set: { newValue in
                                self.bubblesIndex = newValue
                                UserDefaults.standard.set(newValue, forKey: "bubblesIndex")
                            }
                        ),
                        viewModel: stockSettingsViewModel,
                        showingFavorites: $showingFavorites
                    )
                    
                    PreferencesSectionView(languageIndex: $languageIndex, languageOptions: languageOptions)
                }
            }
            .background(Color("Background").edgesIgnoringSafeArea(.all))
            .navigationBarTitle("Settings")
            .onAppear {
                if stockSettingsViewModel.categories.isEmpty {
                    stockSettingsViewModel.loadCategories()
                }
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
        }
        .background(Color("Background").edgesIgnoringSafeArea(.all))
        .onAppear {
            self.profileImage = UIImage.loadImage() ?? UIImage(named: "DefaultProfilePic")
            if stockSettingsViewModel.categories.isEmpty {
                stockSettingsViewModel.loadCategories()
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = self.inputImage else {
            return
        }
        profileImage = inputImage.cropToBounds(image: inputImage, width: Double(inputImage.size.width), height: Double(inputImage.size.width))
        UIImage.saveImage(profileImage!)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

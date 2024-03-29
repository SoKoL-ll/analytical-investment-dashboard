import Foundation
import SwiftUI

struct UserProfileSection: View {
    @Binding var profileImage: UIImage?
    @Binding var userName: String
    var onPhotoTap: () -> Void
    
    var body: some View {
        VStack(spacing: 5) {
            Image(uiImage: profileImage ?? UIImage(named: "DefaultProfilePic")!)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .onTapGesture {
                    onPhotoTap()
                }
            
            Button(String(localized: "Set New Photo"), action: onPhotoTap)
                .foregroundColor(.blue)
                .padding(.bottom, 10)
            
            TextField(String(localized: "Enter your name here!"), text: $userName)
                .foregroundColor(.primary)
                .font(.system(size: 22))
                .multilineTextAlignment(.center)
                .textFieldStyle(PlainTextFieldStyle())
                .limitInputLength(to: 20)
        }
    }
}

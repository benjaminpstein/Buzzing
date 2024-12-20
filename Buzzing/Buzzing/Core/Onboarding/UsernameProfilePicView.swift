//
//  UsernameProfilePicView.swift
//  Buzzing
//
//  Created by Benjamin Stein on 11/30/24.
//


import SwiftUI

struct UsernameProfilePicView: View {
    @EnvironmentObject var userData: UserData
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?

    var body: some View {
        VStack(spacing: 20) {
            Text("Let's set up your profile")
                .font(.title)
                .multilineTextAlignment(.center)
                .fontWeight(.bold)
                .foregroundColor(Color.appLight)
                .padding(.bottom, 50)

            Text("First, choose a username")
                .font(.system(size: 20))
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.appLight)
                .frame(maxWidth: 370, alignment: .leading)
            
            TextField("Enter your username", text: $userData.username)
                .padding()
                .background(Color.appLight)
                .cornerRadius(8)
                .foregroundColor(Color.appDark)
                .padding(.horizontal)
                .onChange(of: userData.username) { _, newValue in
                    userData.username = newValue.replacingOccurrences(of: " ", with: "").lowercased()
                }
            
            Text("Choose your profile picture")
                .font(.system(size: 20))
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.appLight)
                .frame(maxWidth: 370, alignment: .leading)
                .padding(.top, 40)

            ZStack {
                if let image = userData.profileImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color.appLight)
                        .frame(width: 200, height: 200)
                        .overlay(
                            Text("Tap to select a picture")
                                .foregroundColor(.appDark)
                        )
                }
            }
            .onTapGesture {
                self.showImagePicker = true
            }

            NavigationLink(destination: EmailPasswordView()) {
                            Text("Continue")
                                .font(.headline)
                                .foregroundColor(.appLight)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
            .frame(width: 300, height: 40)
            .background(.appPrimary)
            .cornerRadius(10)
            .padding(.top, 30)
            .disabled(!canContinue) // Disable button if conditions are not met
            .opacity(canContinue ? 1.0 : 0.6)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.appDark)
        .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
            ProfileImagePicker(image: self.$inputImage)
        }
    }
    
    private var canContinue: Bool {
            !userData.username.isEmpty && userData.profileImage != nil
        }

    func loadImage() {
        if let inputImage = inputImage {
            userData.profileImage = inputImage
        }
    }
}

#Preview{
    let userData = UserData()
            userData.username = ""
            userData.email = ""
    
    return UsernameProfilePicView()
        .environmentObject(userData)
}

//
//  EmailPasswordView.swift
//  Buzzing
//
//  Created by Benjamin Stein on 11/30/24.
//


import SwiftUI
import Supabase

struct EmailPasswordView: View {
    @EnvironmentObject var userData: UserData
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 20) {
            if isLoading {
                ProgressView("Creating your account...")
                    .foregroundColor(.appLight)
                    .font(.headline)
            }else{
                Text("A few final steps")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .fontWeight(.bold)
                    .foregroundColor(Color.appLight)
                    .padding(.bottom, 50)
                
                Text("Enter your email (so we can sell it)")
                    .font(.system(size: 20))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color.appLight)
                    .frame(maxWidth: 370, alignment: .leading)
                
                TextField("get ready for some crazy spam", text: $userData.email)
                    .padding() // Add some internal padding for better appearance
                    .background(Color.appLight) // Set the background color
                    .cornerRadius(8) // Apply rounded corners
                    .foregroundColor(Color.appDark) // Set the text color (adjust as needed)
                    .padding(.horizontal)
                    .onChange(of: userData.email) { oldValue, newValue in
                        userData.email = newValue.lowercased() // Convert to lowercase
                    }
                
                Text("And your password ;)")
                    .font(.system(size: 20))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color.appLight)
                    .frame(maxWidth: 370, alignment: .leading)
                    .padding(.top)
                
                SecureField("this is not at all secure so make it easy", text: $userData.password)
                    .padding() // Add some internal padding for better appearance
                    .background(Color.appLight) // Set the background color
                    .cornerRadius(8) // Apply rounded corners
                    .foregroundColor(Color.appDark) // Set the text color (adjust as needed)
                    .padding(.horizontal)
                
                Button(action: createAccount) {
                    Text("Create Account")
                        .font(.headline)
                        .foregroundStyle(.appLight)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(width: 300, height: 40)
                .background(.appPrimary)
                .cornerRadius(10)
                .padding(.top, 50)
                .disabled(!canContinue || isLoading) // Disable during loading
                .opacity(canContinue && !isLoading ? 1.0 : 0.6)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.appDark)
    }

    private var canContinue: Bool {
        !userData.email.isEmpty && !userData.password.isEmpty
        }
    
    func createAccount() {
        isLoading = true
        Task {
            do {
                // Upload the profile image
                try await uploadProfileImage(for: userData)

                // Register the user
                try await withCheckedThrowingContinuation { continuation in
                    registerUser(userData: userData) { result in
                        switch result {
                        case .success(let response):
                            print("User registered successfully:", response)
                            DispatchQueue.main.async {
                                // Update the user object and transition to root
                                realUser = UserInfo(
                                    email: userData.email,
                                    username: userData.username,
                                    profPicURL: userData.imageURL
                                )
                                UserDefaults.standard.saveRealUser(realUser)
                                isLoading = false
                                userData.appState = .root
                            }
                            continuation.resume()
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error during account creation: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    let userData = UserData()
            userData.username = "Ben"
            userData.email = ""
    
    return EmailPasswordView()
        .environmentObject(userData)
}

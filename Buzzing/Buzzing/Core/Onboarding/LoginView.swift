//
//  LoginView.swift
//  Buzzing
//
//  Created by Benjamin Stein on 11/30/24.
//


import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userData: UserData
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var showingAlert = false
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if isLoading {
                    ProgressView("Logging you in...")
                        .foregroundColor(.appLight)
                        .font(.headline)
                }else{
                    Text("We're so back")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .fontWeight(.bold)
                        .foregroundColor(Color.appLight)
                        .padding(.bottom, 50)
                    
                    TextField("Enter your email", text: $email)
                        .padding()
                        .background(Color.appLight)
                        .cornerRadius(8)
                        .foregroundColor(Color.appDark)
                        .padding(.horizontal)
                    
                    SecureField("Enter your password", text: $password)
                        .padding()
                        .background(Color.appLight)
                        .cornerRadius(8)
                        .foregroundColor(Color.appDark)
                        .padding(.horizontal)
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.horizontal)
                    }
                    
                    
                    Button(action: logIn) {
                        Text("Log In")
                            .font(.headline)
                            .foregroundColor(.appLight)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(width: 300, height: 40)
                    .background(.appPrimary)
                    .cornerRadius(10)
                    .padding(.top, 30)
                    .disabled(!canContinue)
                    .opacity(canContinue ? 1.0 : 0.6)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.appDark)
        }
    }

    private var canContinue: Bool {
        !email.isEmpty && !password.isEmpty
    }

    func logIn() {
        isLoading = true // Set loading state to true immediately

        guard let url = URL(string: "\(serverAddress)/login") else {
            errorMessage = "Invalid server URL"
            isLoading = false // Reset loading state
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = [
            "email": email,
            "password": password
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            errorMessage = "Failed to encode login data"
            isLoading = false // Reset loading state
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    errorMessage = "Error: \(error.localizedDescription)"
                    isLoading = false // Reset loading state
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    errorMessage = "Invalid email or password"
                    isLoading = false // Reset loading state
                    return
                }

                guard let data = data else {
                    errorMessage = "No data received from server"
                    isLoading = false // Reset loading state
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let message = json["message"] as? String,
                           let theusername = json["username"] as? String,
                           let profile_pic = json["profile_picture"] as? String {
                            // Successful login
                            realUser.email = email
                            realUser.username = theusername
                            realUser.profPicURL = profile_pic
                            print("Login successful: \(message)")
                            UserDefaults.standard.saveRealUser(realUser)
                            userData.appState = .root
                        } else if let error = json["error"] as? String {
                            errorMessage = error // Display the server's error message
                        }
                    }
                } catch {
                    errorMessage = "Failed to parse server response"
                }

                isLoading = false // Reset loading state after all cases
            }
        }

        task.resume()
    }

}

#Preview {
    LoginView()
}

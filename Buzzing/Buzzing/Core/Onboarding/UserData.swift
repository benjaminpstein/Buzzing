//
//  UserData.swift
//  Buzzing
//
//  Created by Benjamin Stein on 11/30/24.
//


import SwiftUI

class UserData: ObservableObject {
    @Published var username: String = ""
    @Published var profileImage: UIImage? = nil
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var imageURL: String = ""
    @Published var appState: AppState = .onboarding
    
    init(username: String = "", profileImage: UIImage? = nil, email: String = "", password: String = "", imageURL: String = "", appState: AppState = .onboarding) {
            self.username = username
            self.profileImage = profileImage
            self.email = email
            self.password = password
            self.imageURL = imageURL
        self.appState = .onboarding
        }
}


enum AppState {
    case onboarding
    case root
    case loading
}

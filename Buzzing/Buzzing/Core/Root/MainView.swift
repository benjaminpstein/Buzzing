//
//  MainView.swift
//  Buzzing
//
//  Created by Benjamin Stein on 12/2/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var userData: UserData
    
    init() {
        let initialUserData = UserData()
        initialUserData.appState = .loading // Start with loading state
        _userData = StateObject(wrappedValue: initialUserData)
        
        realUser = UserDefaults.standard.loadRealUser()
        print("realUser username: \(realUser.username)")
        
        // Simulate loading realUser from UserDefaults or a database
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if realUser.username.isEmpty {
                initialUserData.appState = .onboarding
            } else {
                initialUserData.appState = .root
            }
        }
        print("realUser username1: \(realUser.username)")
    }
    
    var body: some View {
        Group {
            switch userData.appState {
            case .loading:
                LoadingView()
            case .onboarding:
                OnboardingView()
                    .environmentObject(userData)
            case .root:
                Root()
                    .environmentObject(userData)
            }
        }
        .id(userData.appState) // Force refresh
        .onChange(of: userData.appState) { oldState, newState in
            print("MainView detected appState change: \(newState)")
            print("realUser username2: \(realUser.username)")
        }
    }
}


#Preview {
    MainView()
}

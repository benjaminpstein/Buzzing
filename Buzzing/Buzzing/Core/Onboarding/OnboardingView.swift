//
//  OnboardingView.swift
//  Buzzing
//
//  Created by Benjamin Stein on 11/30/24.
//


import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        NavigationView {
            WelcomeView()
                .environmentObject(userData)
        }
    }
}

#Preview{
    let userData = UserData()
            userData.username = ""
            userData.email = ""
            
    return OnboardingView()
        .environmentObject(userData)
}

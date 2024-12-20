//
//  WelcomeView.swift
//  Buzzing
//
//  Created by Benjamin Stein on 11/30/24.
//


import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        VStack(spacing: 20) {
                
            ZStack{
                Circle()
                    .stroke(
                        RadialGradient(
                            gradient: Gradient(colors: [.appPrimary, .appDark]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 200
                        ),
                        lineWidth: 300 // Thickness of the stroke
                    )
                    .foregroundStyle(.appPrimary)
                    .opacity(0.9)
                    .frame(width: 300)
                Text("🍺")
                    .font(.system(size: 140))
            }
            Text("What's Buzzing?")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .fontWeight(.bold)
                .foregroundColor(Color.appLight)
                .padding(.top, 50)
            Text("Check the vibes at all your favorite Columbia bars")
                .font(.system(size: 20))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.appLight)
                .padding(.horizontal, 60)

            NavigationLink(destination: UsernameProfilePicView()) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.appPrimary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(width: 300, height: 40)
            .background(.appLight)
            .cornerRadius(10)
            .padding(.top)
            
            NavigationLink(destination: LoginView()) {
                            Text("Or Log In")
                                .font(.headline)
                                .foregroundColor(.appLight)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
            .frame(width: 300, height: 40)
            .background(.appPrimary)
            .cornerRadius(10)
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.appDark)
    }
}

#Preview{
    let userData = UserData()
            userData.username = ""
            userData.email = ""
            
    return WelcomeView()
        .environmentObject(userData)
}

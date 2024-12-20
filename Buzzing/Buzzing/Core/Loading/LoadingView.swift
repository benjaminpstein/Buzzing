//
//  LoadingView.swift
//  Buzzing
//
//  Created by Benjamin Stein on 12/3/24.
//

import SwiftUI

struct LoadingView: View {
    @State private var jump = false // Track jump animation state

    var body: some View {
        VStack {
            ZStack {
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
                
                // Animated 🍺 emoji
                Text("🍺")
                    .font(.system(size: 140))
                    .scaleEffect(jump ? 1.5 : 1.0) // Scale up and down
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever(autoreverses: true),
                        value: jump
                    )
            }
            Text("What's Buzzing?")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .fontWeight(.bold)
                .foregroundColor(Color.appLight)
                .padding(.top, 50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appDark)
        .onAppear {
            jump = true // Start the jump animation
        }
    }
}

#Preview {
    LoadingView()
}

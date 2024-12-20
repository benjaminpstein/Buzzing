//
//  TabBarButton.swift
//  Buzzing
//
//  Created by Analisa Wood on 11/15/24.
//

import SwiftUI

struct TabBarButton: View {
    var image: String
    @Binding var selectedTab: Int
    var index: Int
    var size: CGFloat = 40 // Default size for icons

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.3)) {
                selectedTab = index
            }
        }) {
            ZStack {
                // Smoothly scale the highlight when the tab is selected
                Circle()
                    .fill(selectedTab == index ? Color.white.opacity(0.2) : Color.clear)
                    .frame(width: 60, height: 60)
                    .animation(.easeInOut(duration: 0.2), value: selectedTab)

                // Add scaling to the icon for a subtle bounce effect
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .foregroundColor(selectedTab == index ? .white : .gray)
                    .scaleEffect(selectedTab == index ? 1.2 : 1.0) // Scale up selected icon
                    .animation(.easeInOut(duration: 0.2), value: selectedTab) // Smooth scaling
            }
        }
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(1))
}

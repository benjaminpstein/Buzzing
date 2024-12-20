//
//  CustomTabBar.swift
//  Buzzing
//
//  Created by Analisa Wood on 11/15/24.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int

    var body: some View {
        ZStack (alignment: .top){
            // Background with an outline
            Rectangle()
                .stroke(Color.appDark, lineWidth: 2) // Black outline
                .background(
                    Rectangle()
                        .fill(Color.appPrimary) // Tab bar background color
                )
                .frame(height: 120)
                .clipShape(RoundedCornerShape(corners: [.topLeft, .topRight], radius: 10))

            // Tab bar content
            
            HStack(alignment: .top) {
                TabBarButton(image: "house_icon", selectedTab: $selectedTab, index: 0, size: 50)
                Spacer()
                TabBarButton(image: "location_shadow_icon", selectedTab: $selectedTab, index: 1, size: 43)
                Spacer()
                TabBarButton(image: "post_shadow_icon", selectedTab: $selectedTab, index: 2, size: 47)
                Spacer()
                TabBarButton(image: "profile_shadow_icon", selectedTab: $selectedTab, index: 3, size: 44)
            }
            .padding(.horizontal, 16) // Space the buttons horizontally
            .padding(.vertical, 10) // Add vertical padding for content inside the bar
        }
    }
}


#Preview {
    CustomTabBar(selectedTab: .constant(1))
}

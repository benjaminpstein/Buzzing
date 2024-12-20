//
//  TabView.swift
//  Buzzing
//
//  Created by Analisa Wood on 11/15/24.
//
import SwiftUI

struct Root: View {
    @EnvironmentObject var userData: UserData
    @State private var selectedTab = 0

    var body: some View {
        ZStack (alignment: .bottom) {
            // Main content area, which switches based on the selected tab
            VStack {
                Spacer()
                switch selectedTab {
                case 0:
                    FeedView()
                case 1:
                    MapWithBarReviews()
                case 2:
                    PostView(selectedTab: $selectedTab)
                case 3:
                    ProfileView()
                        .environmentObject(userData)
                default:
                    FeedView()
                }
                Spacer(minLength: 120)
            }

            // Custom floating tab bare
            VStack {
                HStack {
                    CustomTabBar(selectedTab: $selectedTab)
                }
            }
        }.background(.appDark)
        .edgesIgnoringSafeArea(.bottom) // Ignore safe area at the bottom for a full-screen look
        .edgesIgnoringSafeArea(.top)
    }
}



#Preview {
    Root()
}

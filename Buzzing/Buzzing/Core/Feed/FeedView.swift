//
//  FeedView.swift
//  Buzzing
//
//  Created by Benjamin Stein on 11/11/24.
//

import SwiftUI

struct FeedView: View {
    @State private var selectedTab: Int = 1

    var body: some View {
        NavigationStack {
            VStack {
                FeedHeaderView(selectedTab: $selectedTab)
                if selectedTab == 1 {
                    recencyView
                        .transition(.move(edge: .leading))
                        .animation(.easeInOut(duration: 0.5), value: selectedTab)
                } else {
                    byBarView
                        .transition(.move(edge: .trailing))
                        .animation(.easeInOut(duration: 0.5), value: selectedTab)
                }
            }
            .background(Color.appDark)
        }
    }

    var recencyView: some View {
        RecencyFeedView()
    }

    var byBarView: some View {
        ByBarFeedView()
    }

    var groupedReviews: [BarReviews] {
        [
            BarReviews(
                barName: "The Heights Bar and Grill",
                reviews: [
                    ReviewInfo(username: "user1", userPicURL: "...", rating: 5, description: "Great place!", bar: "The Heights Bar and Grill", photos: ["..."], publishTime: Date()),
                    // Add more reviews
                ]
            ),
            // Add more bars
        ]
    }
}


#Preview {
    FeedView()
}

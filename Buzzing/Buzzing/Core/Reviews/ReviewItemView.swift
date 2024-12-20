//
//  ReviewItemView.swift
//  Buzzing
//
//  Created by Benjamin Stein on 11/11/24.
//

import SwiftUI



struct ReviewItemView: View {
    var reviewData: ReviewInfo
    
    var body: some View {
        if !reviewData.bar.isEmpty {
            FeedReviewItemView(review: reviewData)
        } else {
            BarReviewItemView(review: reviewData)
        }
    }
}

#Preview {
    ReviewItemView(reviewData: ReviewInfo(
        username: "analizard",
        userPicURL: "https://static.vecteezy.com/system/resources/previews/005/129/844/non_2x/profile-user-icon-isolated-on-white-background-eps10-free-vector.jpg",
        rating: 4,
        description: "Great bar with the most amazing atmosphere!",
        bar: "The Heights Bar and Grill",
        photos: ["https://s3-media0.fl.yelpcdn.com/bphoto/RC1OBEE1zpDaAsz7FGkeZA/348s.jpg"],
        publishTime: Date()))
}

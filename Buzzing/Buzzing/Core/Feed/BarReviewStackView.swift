//
//  BarReviewStackView.swift
//  Buzzing
//
//  Created by Benjamin Stein on 11/13/24.
//

import SwiftUI

let barStackSampleData: [ReviewInfo] = [
    ReviewInfo(
        username: "analizard",
        userPicURL: "https://static.vecteezy.com/system/resources/previews/005/129/844/non_2x/profile-user-icon-isolated-on-white-background-eps10-free-vector.jpg",
        rating: 4,
        description: "Great bar with amazing atmosphere!",
        bar: "Arts and Crafts Beer Parlor",
        photos: ["https://s3-media0.fl.yelpcdn.com/bphoto/RC1OBEE1zpDaAsz7FGkeZA/348s.jpg"],
        publishTime: Date()
    ),
    ReviewInfo(
        username: "analizard",
        userPicURL: "https://static.vecteezy.com/system/resources/previews/005/129/844/non_2x/profile-user-icon-isolated-on-white-background-eps10-free-vector.jpg",
        rating: 4,
        description: "Great bar with amazing atmosphere!",
        bar: "Arts and Crafts Beer Parlor",
        photos: ["https://s3-media0.fl.yelpcdn.com/bphoto/RC1OBEE1zpDaAsz7FGkeZA/348s.jpg"],
        publishTime: Date()
    ),
    ReviewInfo(
        username: "analizard",
        userPicURL: "https://static.vecteezy.com/system/resources/previews/005/129/844/non_2x/profile-user-icon-isolated-on-white-background-eps10-free-vector.jpg",
        rating: 4,
        description: "Great bar with amazing atmosphere!",
        bar: "Arts and Crafts Beer Parlor",
        photos: ["https://s3-media0.fl.yelpcdn.com/bphoto/RC1OBEE1zpDaAsz7FGkeZA/348s.jpg"],
        publishTime: Date()
    )
]


struct BarReviewStackView: View {
    var barData : BarInfo
    var barStackData : [ReviewInfo]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Bar image
            barData.img
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding(.horizontal)
                    
            VStack(alignment: .leading, spacing: 4) {
                Text(barData.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.appLight)
                        
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(.appLight)
                    Text(barData.address)
                        .font(.subheadline)
                        .foregroundColor(.appLight)
                }
            }
            .padding(.horizontal)
            
            // Review list
            ScrollView{
                VStack(spacing: 8) {
                    ForEach(barStackData, id: \.username) { review in
                        ReviewItemView(reviewData: review)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.top)
        .padding(.bottom)
        .background(.appPrimary)
        .cornerRadius(10)
    }
}

#Preview {
    BarReviewStackView(barData: Heights, barStackData: barStackSampleData)
}

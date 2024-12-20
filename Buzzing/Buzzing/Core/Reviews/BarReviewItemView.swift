//
//  BarReviewItemView.swift
//  Buzzing
//
//  Created by Benjamin Stein on 11/13/24.
//

import SwiftUI

struct BarReviewItemView: View {
    var review: ReviewInfo

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                // Review content with only top corners rounded
                HStack(alignment: .top, spacing: 10) {
                    // Profile picture and username column
                    VStack(alignment: .center, spacing: 6) {
                        if let userPicURL = review.userPicURL, let url = URL(string: userPicURL) {
                                        AsyncImage(url: url) { image in
                                            image.resizable()
                                                 .aspectRatio(contentMode: .fill)
                                                 .frame(width: 40, height: 40)
                                                 .clipShape(Circle())
                                        } placeholder: {
                                            Circle()
                                                .fill(Color.gray)
                                                .frame(width: 40, height: 40)
                                                .overlay(
                                                    Image(systemName: "person.fill")
                                                        .foregroundColor(.white)
                                                )
                                        }
                                    } else {
                                        Circle()
                                            .fill(Color.gray)
                                            .frame(width: 40, height: 40)
                                            .overlay(
                                                Image(systemName: "person.fill")
                                                    .foregroundColor(.white)
                                            )
                                    }
                        Text(review.username)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: 60) // Set a fixed width for alignment

                    // Review details
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 2) {
                            // Star rating
                            ForEach(0..<5) { index in
                                Image(systemName: index < review.rating ? "star.fill" : "star")
                                    .foregroundColor(.appPrimary)
                            }

                            Spacer()

                            Text(review.publishTime.timeAgo())
                                .font(.caption)
                        }

                        Text(review.description)
                    }

                    Spacer()
                }
                .padding()
                .background(Color.appLight)
                .cornerRadius(10, corners: [.topLeft, .topRight])

                // Display the first photo from the `photos` array
                if let firstPhotoURL = review.photos.first, !firstPhotoURL.isEmpty {
                    AsyncImage(url: URL(string: firstPhotoURL)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: 320)
                            .clipped()
                            .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
                    } placeholder: {
                        Rectangle()
                            .frame(width: geometry.size.width, height: 320)
                            .foregroundColor(.gray)
                            .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
                    }
                }
            }
            .frame(width: geometry.size.width) // Constrain the entire component to the screen width
        }
        .frame(height: 450) // Ensure GeometryReader has a fixed height
    }
}

#Preview {
    BarReviewItemView(review: ReviewInfo(
        username: "analizard",
        userPicURL: "https://static.vecteezy.com/system/resources/previews/005/129/844/non_2x/profile-user-icon-isolated-on-white-background-eps10-free-vector.jpg",
        rating: 4,
        description: "Great bar with the most amazing atmosphere!",
        bar: "Arts and Crafts Beer Parlor",
        photos: ["https://s3-media0.fl.yelpcdn.com/bphoto/RC1OBEE1zpDaAsz7FGkeZA/348s.jpg"],
        publishTime: Date()))
}


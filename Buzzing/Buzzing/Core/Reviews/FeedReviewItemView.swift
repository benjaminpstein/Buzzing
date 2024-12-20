//
//  FeedReviewItemView.swift
//  Buzzing
//
//  Created by Benjamin Stein on 11/13/24.
//

import SwiftUI

import SwiftUI

struct FeedReviewItemView: View {
    var review: ReviewInfo

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Bar name
            if !review.bar.isEmpty {
                Text(review.bar)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(.appLight))
                    .padding(.bottom)
            }


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

                Spacer() // Push content to the left
            }
            .padding()
            .background(Color.appLight)
            .cornerRadius(10, corners: [.topLeft, .topRight]) // Fix corner rounding

            // Image with only bottom corners rounded
            if let firstPhotoURL = review.photos.first, !firstPhotoURL.isEmpty {
                GeometryReader { geometry in
                    AsyncImage(url: URL(string: firstPhotoURL)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width) // Constrain image width to screen
                            .frame(height: 320) // Fixed height
                            .clipped()
                            .cornerRadius(10, corners: [.bottomLeft, .bottomRight]) // Rounded bottom corners
                    } placeholder: {
                        Rectangle()
                            .frame(width: geometry.size.width, height: 320)
                            .foregroundColor(.gray)
                            .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
                    }
                }
                .frame(height: 320) // Ensure GeometryReader has a fixed height
            }
        }
        .frame(maxWidth: UIScreen.main.bounds.width) // Ensure the whole component respects screen width
        .padding()
        .background(Color.appPrimary)
        .cornerRadius(10)
    }
}

#Preview {
    FeedReviewItemView(review: ReviewInfo(
        username: "analizard",
        userPicURL: "https://static.vecteezy.com/system/resources/previews/005/129/844/non_2x/profile-user-icon-isolated-on-white-background-eps10-free-vector.jpg",
        rating: 4,
        description: "Great bar with the most amazing atmosphere!",
        bar: "The Heights Bar and Grill",
        photos: ["https://images.pexels.com/photos/866398/pexels-photo-866398.jpeg?cs=srgb&dl=pexels-ralph-chang-260364-866398.jpg&fm=jpg"],
        publishTime: Date()))
}

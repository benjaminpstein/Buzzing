//
//  ProfileReviewItemView.swift
//  Buzzing
//
//  Created by Analisa Wood on 11/13/24.
//

// To use in the Profile Section has Bar name, in the pod w the review

import SwiftUI

struct ProfileReviewItemView: View {
    var review: ReviewInfo

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                // Top part of the review (user details, bar name, etc.)
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
                        if !review.bar.isEmpty {
                            Text(review.bar)
                                .font(.headline)
                                .foregroundColor(.primary)
                        }

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
                    AsyncImage(url: URL(string: firstPhotoURL)) { image in
                        image
                            .resizable()
                            .scaledToFill() // Maintain aspect ratio, fill width
                            .frame(width: geometry.size.width, height: 320) // Constrain width to screen width
                            .clipped() // Crop overflowing parts
                            .cornerRadius(10, corners: [.bottomLeft, .bottomRight]) // Apply corner rounding
                    } placeholder: {
                        Rectangle()
                            .frame(width: geometry.size.width, height: 320) // Placeholder constrained to screen width
                            .foregroundColor(.gray)
                            .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
                    }
                }
            }
            .frame(width: geometry.size.width, alignment: .center) // Constrain the entire view to the screen width
        }
        .frame(height: 400) // Explicit height for the GeometryReader
    }
}

// Helper for applying corner radius selectively
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCornerShape(corners: corners, radius: radius))
    }
}

#Preview {
    ProfileReviewItemView(review: ReviewInfo(
        username: "analizard",
        userPicURL: "https://static.vecteezy.com/system/resources/previews/005/129/844/non_2x/profile-user-icon-isolated-on-white-background-eps10-free-vector.jpg",
        rating: 4,
        description: "Great bar with the most amazing atmosphere!",
        bar: "The Heights Bar & Grill",
        photos: ["https://images.pexels.com/photos/866398/pexels-photo-866398.jpeg?cs=srgb&dl=pexels-ralph-chang-260364-866398.jpg&fm=jpg"],
        publishTime: Date()
    ))
}

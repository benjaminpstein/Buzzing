//
//  RecencyFeedView.swift
//  Buzzing
//
//  Created by Benjamin Stein on 11/12/24.
//

import SwiftUI

struct RecencyFeedView: View {
    @State private var reviews: [ReviewInfo] = [] // Store fetched reviews
    @State private var isLoading = true // Track loading state
    @State private var errorMessage: String? // Store error message

    var body: some View {
        ScrollView {
            if isLoading {
                // Show loading indicator
                VStack {
                    ProgressView("Loading reviews...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                        .foregroundStyle(.appLight)
                }
            } else if let errorMessage = errorMessage {
                // Show error message if there's an error
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                // Show the list of reviews
                LazyVStack(spacing: 16) {
                    ForEach(Array(reviews.enumerated()), id: \.offset) { _, review in
                        ReviewItemView(reviewData: review)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            fetchReviews() // Fetch reviews when the view appears
        }
    }

    // Fetch reviews from the /get-feed route
    private func fetchReviews() {
        guard let url = URL(string: "\(serverAddress)/get-feed") else {
            errorMessage = "Invalid server URL"
            isLoading = false
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = "Error: \(error.localizedDescription)"
                    isLoading = false
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    errorMessage = "Failed to fetch reviews"
                    isLoading = false
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    errorMessage = "No data received from server"
                    isLoading = false
                }
                return
            }

            do {
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                decoder.dateDecodingStrategy = .formatted(dateFormatter)

                let response = try decoder.decode(FeedResponse.self, from: data)
                DispatchQueue.main.async {
                    reviews = response.reviews
                    isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    errorMessage = "Failed to parse reviews: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }

        task.resume()
    }
}


#Preview {
    RecencyFeedView()
}

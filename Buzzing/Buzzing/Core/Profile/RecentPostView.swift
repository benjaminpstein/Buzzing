import SwiftUI

struct RecentPostView: View {
    @State private var reviews: [ReviewInfo] = [] // Store fetched reviews
    @State private var isLoading = true // Track loading state
    @State private var errorMessage: String? // Store error message
    @State private var isEmptyState = false // Track if the state is empty

    var username = "" // Pass username to fetch reviews for the user
    
    var body: some View {
        ScrollView {
            if isLoading {
                // Show loading indicator
                VStack {
                    ProgressView("Loading reviews...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
            } else if let errorMessage = errorMessage {
                // Show error message if there's an error
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else if isEmptyState {
                // Show empty state message
                VStack {
                    Text("You haven't reviewed any bars yet!")
                        .font(.headline)
                        .foregroundColor(.appLight)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Text("Click + to write your first review!")
                        .font(.subheadline)
                        .foregroundColor(.appLight)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            } else {
                // Show the list of reviews
                VStack(alignment: .leading) {
                    Text("Recent Reviews")
                        .font(.system(size: 16))
                        .foregroundColor(.appLight)
                        .padding(.bottom, 2)
                        .padding(.leading, 3) // Increase the left padding slightly to move it to the right

                    LazyVStack(spacing: 0) {
                        ForEach(reviews, id: \.publishTime) { review in
                            ProfileReviewItemView(review: review)
                                .padding(.vertical)
                        }
                    }
                }
                .padding(.top, 16)
                .padding(.leading, 16) // Added left padding
                .padding(.trailing, 16) // Optional for consistent horizontal padding
            }
        }
        .onAppear {
            fetchRecentReviews() // Fetch reviews when the view appears
        }
    }

    // Fetch recent reviews for the user from the backend
    private func fetchRecentReviews() {
        guard let url = URL(string: "\(serverAddress)/get-recent-reviews?username=\(username)") else {
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

            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 404 {
                    DispatchQueue.main.async {
                        isEmptyState = true // Set empty state
                        isLoading = false
                    }
                    return
                } else if httpResponse.statusCode != 200 {
                    DispatchQueue.main.async {
                        errorMessage = "Failed to fetch reviews (HTTP \(httpResponse.statusCode))"
                        isLoading = false
                    }
                    return
                }
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
                // Use custom ISO8601 decoding to match the format in the JSON
                let iso8601Formatter = DateFormatter()
                iso8601Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                iso8601Formatter.timeZone = TimeZone(secondsFromGMT: 0)
                decoder.dateDecodingStrategy = .formatted(iso8601Formatter)

                let response = try decoder.decode(FeedResponse.self, from: data)
                DispatchQueue.main.async {
                    reviews = response.reviews
                    isEmptyState = reviews.isEmpty // Set empty state if no reviews
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
    RecentPostView()
}

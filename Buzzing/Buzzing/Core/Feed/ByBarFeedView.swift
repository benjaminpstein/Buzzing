//
//  ByBarFeedView.swift
//  Buzzing
//
//  Created by Benjamin Stein on 11/12/24.
//


import SwiftUI


struct ByBarFeedView: View {
    @State private var searchText: String = ""
    @State private var selectedBar: BarInfo? = nil
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var isEmptyState = false
    @State private var reviewsGroupedByBar: [Int: [ReviewInfo]] = [:]
    
    var allBars: [BarInfo] = [Heights, TenTwenty, Amity, LionsHead, ArtsAndCrafts]
    
    
    
    var body: some View {
        VStack(spacing: 0) {
            // Dropdown Menu
            ByBarFeedDropdownMenuView(selectedBar: $selectedBar, bars: allBars)
                .onChange(of: selectedBar) { oldBar, newBar in
                                    if let newBar = newBar {
                                        print("[DEBUG] Selected bar: \(newBar.name)")
                                        getBarReviews(barID: newBar.bar_id) // Call the function here
                                    } else {
                                        print("[DEBUG] No bar selected, clearing reviews.")
                                        reviewsGroupedByBar.removeAll()
                                    }
                                }
            
            ScrollView {
                LazyVStack(spacing: 16) {
                    if isLoading {
                        // Show loading indicator
                        VStack {
                            ProgressView("Loading reviews...")
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding()
                        }
                    }else{
                            // Show reviews for the selected bar
                            if let selectedBar = selectedBar {
                                if let reviews = reviewsGroupedByBar[selectedBar.bar_id] {
                                    BarReviewStackView(barData: selectedBar, barStackData: reviews)
                                } else {
                                    Text("No reviews available for \(selectedBar.name)")
                                        .foregroundColor(.appLight)
                                        .padding()
                                        .multilineTextAlignment(.center)
                                }
                            } else {
                                // Show all bars and their reviews
                                ForEach(allBars, id: \.name) { bar in
                                    if let reviews = reviewsGroupedByBar[bar.bar_id] {
                                        BarReviewStackView(barData: bar, barStackData: reviews)
                                    } else {
                                        Text("No reviews available for \(bar.name)")
                                            .foregroundColor(.appLight)
                                            .padding()
                                            .multilineTextAlignment(.center)
                                    }
                                }
                            }
                        
                    }
                }
                .padding()
            }
            .background(Color.appDark)
            .onAppear {
                fetchAllReviews()
            }
        }
        .background(Color.appDark)
    }
    
    private func fetchAllReviews() {
            isLoading = true // Show the loading state
            for bar in allBars {
                getBarReviews(barID: bar.bar_id)
            }
        }
    
    func getBarReviews(barID: Int) {
        isLoading = true // Set loading state to true at the start
        print("[DEBUG] Fetching reviews for Bar ID: \(barID)")

        guard let url = URL(string: "\(serverAddress)/get-recent-bar-reviews?bar_id=\(String(barID))") else {
            errorMessage = "Invalid server URL"
            isLoading = false
            print("[DEBUG] Invalid server URL: \(serverAddress)/get-recent-bar-reviews?bar_id=\(String(barID))")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = "Error: \(error.localizedDescription)"
                    isLoading = false
                    print("[DEBUG] Network error: \(error.localizedDescription)")
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("[DEBUG] HTTP Response Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 404 {
                    DispatchQueue.main.async {
                        isEmptyState = true // Set empty state for 404
                        isLoading = false
                        print("[DEBUG] No reviews found for Bar ID: \(barID) (404)")
                    }
                    return
                } else if httpResponse.statusCode != 200 {
                    DispatchQueue.main.async {
                        errorMessage = "Failed to fetch reviews (HTTP \(httpResponse.statusCode))"
                        isLoading = false
                        print("[DEBUG] Non-200 HTTP status code: \(httpResponse.statusCode)")
                    }
                    return
                }
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    errorMessage = "No data received from server"
                    isLoading = false
                    print("[DEBUG] No data received from server for Bar ID: \(barID)")
                }
                return
            }

            // Print raw JSON for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("[DEBUG] Raw JSON Response: \(jsonString)")
            }

            do {
                // Decode the JSON response
                let decoder = JSONDecoder()
                let iso8601Formatter = DateFormatter()
                iso8601Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                iso8601Formatter.timeZone = TimeZone(secondsFromGMT: 0)
                decoder.dateDecodingStrategy = .formatted(iso8601Formatter)

                // Decode into `FeedResponse`
                let response = try decoder.decode(FeedResponse.self, from: data)

                // Adjust for `photos` array with only the first item
                let parsedReviews = response.reviews.map { review in
                    ReviewInfo(
                        username: review.username,
                        userPicURL: review.userPicURL,
                        rating: review.rating,
                        description: review.description,
                        bar: review.bar,
                        photos: [review.photos.first ?? ""], // Safely use the first photo
                        publishTime: review.publishTime
                    )
                }

                DispatchQueue.main.async {
                    reviewsGroupedByBar[barID] = parsedReviews
                    isEmptyState = parsedReviews.isEmpty // Set empty state if no reviews
                    isLoading = false
                    print("[DEBUG] Successfully fetched and parsed reviews for Bar ID: \(barID). Total reviews: \(parsedReviews.count)")
                }
            } catch {
                DispatchQueue.main.async {
                    errorMessage = "Failed to parse reviews: \(error.localizedDescription)"
                    isLoading = false
                    print("[DEBUG] JSON parsing error for Bar ID: \(barID): \(error.localizedDescription)")
                }
            }
        }

        task.resume()
    }
}

#Preview {
    ByBarFeedView()
}

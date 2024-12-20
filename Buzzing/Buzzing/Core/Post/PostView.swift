//
//  PostView.swift
//  Buzzing
//
//  Created by Allyce Chung on 2024/11/12.
//

import SwiftUI
import PhotosUI

struct PostView: View {
    @Binding var selectedTab: Int
    @State private var searchText = ""
    @State private var showSuggestions = false
    @State private var selectedBar: BarInfo?
    @State private var showImagePicker = false
    @State private var isSelectingImage = false
    @State private var post = Post(rating: 0, description: "", bar: nil, image: nil)
    @State private var user_id: Int?
    @State private var errorMessage: String = ""
    
    var body: some View {
        ScrollView{
            Spacer(minLength: 50)
            ZStack {
                Color("AppDark") // Dark purple background
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    // Title
                    Text("Post to Friends!")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.top)
                        .foregroundColor(Color.appLight)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // WYA: SELECT BAR LOCATION
                    VStack{
                        Text("wya?")
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.appLight)
                        
                        PostBarSelectionDropdownMenu(selectedBar: $selectedBar, bars: allBars)
                        
                    }
                    .onChange(of: selectedBar) { oldValue, newValue in
                                            post.bar = newValue?.name
                        }
                    .padding(.horizontal)
                    
                    
                    // ENTER STAR RATING
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Rating")
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.appLight)
                        
                        HStack {
                            HStack {
                                ForEach(1..<6) { star in
                                    Image(systemName: star <= post.rating ? "star.fill" : "star")
                                        .resizable()
                                        .frame(width: 45, height: 45)
                                        .foregroundColor(Color("AppLight"))
                                        .onTapGesture {
                                            post.rating = star
                                        }
                                }
                            }
                            // Center align the stars
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(.horizontal)
                    
                    
                    // ADD IMAGES
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Add Image")
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.appLight)
                        
                        HStack {
                            ZStack {
                                Color("AppLight")
                                    .frame(width: 120, height: 80)
                                    .cornerRadius(8)
                                    .onTapGesture {
                                        isSelectingImage = true
                                        showImagePicker = true
                                    }
                                
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 30, height: 30) // Adjust the size of the plus sign
                                    .foregroundColor(Color("AppPrimary"))
                                
                                if let image1 = post.image {
                                    Image(uiImage: image1)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 80)
                                        .cornerRadius(8)
                                } else {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(Color("AppPrimary"))
                                }
                            } // end ZStack pic 1
                            
                            
                        }
                        
                        // Center align the HStack
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(selectedImage: $post.image)
                    }
                    
                    .padding(.leading, 20)
                    
                    // WRITE REVIEW
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Review")
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                            .foregroundColor(.appLight)
                        
                            
                        // TextEditor with character limit
                        TextEditor(text: $post.description)
                            .frame(height: 100)
                            .padding(8)
                            .background(Color.appLight)
                            .cornerRadius(8)
                            .scrollContentBackground(.hidden) // Disable default white background
                            .onChange(of: post.description) { oldValue, newValue in
                                if newValue.count > 200 {
                                    post.description = String(newValue.prefix(200))
                                }
                            }
                        Text("\(post.description.count)/200")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 20)
                    }
                    .padding(.horizontal, 20)
                    
                    // POST BUTTON
                    Button(action: {
                        guard let barName = selectedBar?.name, post.rating > 0 else {
                            errorMessage = "Please select a bar and provide a rating."
                            return
                        }

                        Task {
                            do {
                                // Upload image and get the URL
                                let photoURL: String
                                if let photoData = post.image?.pngData() {
                                    photoURL = try await uploadReviewImage(photo: photoData, barName: barName, username: realUser.username)
                                } else {
                                    photoURL = "" // No image uploaded
                                }

                                // Prepare data for the POST request
                                let body: [String: Any] = [
                                    "username": realUser.username,
                                    "bar_name": barName,
                                    "rating": post.rating,
                                    "description": post.description.isEmpty ? nil : post.description,
                                    "photos": [photoURL],
                                    "user_pic_url": realUser.profPicURL// Send photo URL in an array
                                ].compactMapValues { $0 }

                                guard let url = URL(string: "\(serverAddress)/submit-review") else {
                                    errorMessage = "Invalid server URL."
                                    return
                                }

                                var request = URLRequest(url: url)
                                request.httpMethod = "POST"
                                request.setValue("application/json", forHTTPHeaderField: "Content-Type")

                                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

                                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                                    if let error = error {
                                        DispatchQueue.main.async {
                                            errorMessage = "Error: \(error.localizedDescription)"
                                        }
                                        return
                                    }

                                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                                        DispatchQueue.main.async {
                                            errorMessage = "Failed to submit review."
                                        }
                                        return
                                    }

                                    DispatchQueue.main.async {
                                        errorMessage = ""
                                        print("Post submitted successfully!")
                                        selectedTab = 0 // Navigate back to the feed
                                    }
                                }
                                selectedTab = 0
                                task.resume()
                            } catch {
                                DispatchQueue.main.async {
                                    errorMessage = "Failed to upload image: \(error.localizedDescription)"
                                }
                            }
                        }
                    }) {
                        HStack {
                            Text("Post")
                                .font(.system(size: 25))
                                .fontWeight(.bold)
                                .foregroundColor(Color("AppPrimary"))
                            
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(Color("AppPrimary"))
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("AppLight"))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                }// end VStack
                
            }// end ZStack
        }.background(.appDark)
    }// end view
    
}

#Preview {
    PostView(selectedTab: .constant(3))
}

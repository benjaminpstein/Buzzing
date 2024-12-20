//
//  uploadReviewImage.swift
//  Buzzing
//
//  Created by Erick Cifuentes on 12/2/24.
//
import Foundation
import Supabase


func uploadReviewImage(photo: Data, barName: String, username: String) async throws -> String {
    // Define the file path in the storage bucket
    let filePath = "\(username) \(barName).png"

    // Upload the image data to Supabase Storage
    try await supabaseClient.storage
        .from("review-images")
        .upload(path: filePath,
                file: photo,
                options: FileOptions(
                    cacheControl: "3600",
                    contentType: "image/png",
                    upsert: true
                ))

    // Retrieve the public URL of the uploaded image
    let publicURL = try supabaseClient.storage
        .from("review-images")
        .getPublicURL(path: filePath)

    // Return the public URL
    return publicURL.absoluteString
}

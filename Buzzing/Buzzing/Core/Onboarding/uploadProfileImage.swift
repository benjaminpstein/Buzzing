//
//  uploadProfileImage.swift
//  Buzzing
//
//  Created by Benjamin Stein on 12/2/24.
//

import Foundation
import Supabase

let supabaseClient = SupabaseManager.shared.client

func uploadProfileImage(for userData: UserData) async throws {
    guard let profileImage = userData.profileImage else {
        throw NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Profile image is nil"])
    }

    // Convert UIImage to Data
    guard let imageData = profileImage.pngData() else {
        throw NSError(domain: "ImageError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert UIImage to Data"])
    }

    // Define the file path in the storage bucket
    let filePath = "\(userData.username).png"

    // Upload the image data to Supabase Storage
    try await supabaseClient.storage
        .from("user-images")
        .upload(path: filePath,
                file: imageData,
                options: FileOptions(
                    cacheControl: "3600",
                    contentType: "image/png",
                    upsert: false
                ))

    // Retrieve the public URL of the uploaded image
    let publicURL = try supabaseClient.storage
        .from("user-images")
        .getPublicURL(path: filePath)

    // Update the user's imageURL with the public URL on the main thread
    DispatchQueue.main.async {
        userData.imageURL = publicURL.absoluteString
    }
}

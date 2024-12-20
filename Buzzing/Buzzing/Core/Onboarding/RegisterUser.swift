//
//  RegisterUser.swift
//  Buzzing
//
//  Created by Benjamin Stein on 12/2/24.
//

import Foundation

func registerUser(userData: UserData, completion: @escaping (Result<[String: Any], Error>) -> Void) {
    // Flask server URL
    guard let url = URL(string: "\(serverAddress)/register") else {
        print("Invalid URL")
        return
    }

    // Create JSON payload
    let payload: [String: Any] = [
        "username": userData.username,
        "password": userData.password,
        "email": userData.email,
        "profile_picture": userData.imageURL
    ]

    // Serialize payload to JSON
    guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else {
        print("Failed to encode JSON")
        return
    }

    // Create a URLRequest
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData

    // Create a URLSession data task
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        // Validate the response
        guard let data = data else {
            completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
            return
        }

        // Parse JSON response
        do {
            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                completion(.success(jsonResponse))
            } else {
                completion(.failure(NSError(domain: "Invalid response format", code: -1, userInfo: nil)))
            }
        } catch {
            completion(.failure(error))
        }
    }

    // Start the task
    task.resume()
}

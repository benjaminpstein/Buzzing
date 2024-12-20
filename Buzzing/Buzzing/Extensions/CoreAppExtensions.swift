//
//  CoreAppExtensions.swift
//  Buzzing
//
//  Created by Benjamin Stein on 11/14/24.
//

import SwiftUI

extension Date {
    func timeAgo() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .hour, .day]
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        
        let now = Date()
        let timeInterval = now.timeIntervalSince(self)
        
        if let timeString = formatter.string(from: timeInterval) {
            return "\(timeString) ago"
        } else {
            return "Just now"
        }
    }
}


extension UserDefaults {
    private enum Keys {
        static let realUser = "realUser"
    }

    // Save UserInfo
    func saveRealUser(_ user: UserInfo) {
        if let encoded = try? JSONEncoder().encode(user) {
            set(encoded, forKey: Keys.realUser)
        }
    }

    // Load UserInfo
    func loadRealUser() -> UserInfo {
        if let savedData = data(forKey: Keys.realUser),
           let decodedUser = try? JSONDecoder().decode(UserInfo.self, from: savedData) {
            return decodedUser
        }
        return UserInfo(email: "", username: "", profPicURL: "") // Default empty user
    }

    // Remove UserInfo (for logout, etc.)
    func removeRealUser() {
        removeObject(forKey: Keys.realUser)
    }
}

//
//  UserManagement.swift
//  Buzzing
//
//  Created by Benjamin Stein on 11/30/24.
//

import Foundation

// Save userInfo to UserDefaults
func saveUserInfo(_ userInfo: UserInfo) {
    if let encoded = try? JSONEncoder().encode(userInfo) {
        UserDefaults.standard.set(encoded, forKey: "userInfo")
    }
}

// Retrieve userInfo from UserDefaults
func getUserInfo() -> UserInfo? {
    if let savedData = UserDefaults.standard.data(forKey: "userInfo") {
        if let decodedUserInfo = try? JSONDecoder().decode(UserInfo.self, from: savedData) {
            return decodedUserInfo
        }
    }
    return nil
}

// Remove userInfo when signing out
func removeUserInfo() {
    UserDefaults.standard.removeObject(forKey: "userInfo")
}

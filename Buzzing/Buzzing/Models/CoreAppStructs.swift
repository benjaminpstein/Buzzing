//
//  CoreAppStructs.swift
//  Buzzing
//
//  Created by Benjamin Stein on 11/14/24.
//

import SwiftUI
import CoreLocation

// Review Component Structs

struct ReviewInfo: Decodable {
    var username: String
    var userPicURL: String?
    var rating: Int
    var description: String
    var bar: String
    var photos: [String]
    var publishTime: Date

    enum CodingKeys: String, CodingKey {
        case username
        case userPicURL = "user_pic_url"
        case rating
        case description
        case bar
        case photos
        case publishTime = "publish_time"
    }
}

struct FeedResponse: Decodable {
    let reviews: [ReviewInfo]
}


// Bar component structs

struct ReviewsByBar {
    var TenTwenty: [ReviewInfo]
    var Heights: [ReviewInfo]
    var Amity: [ReviewInfo]
    var ArtsAndCrafts: [ReviewInfo]
    var LionsHead: [ReviewInfo]
}

struct BarInfo : Identifiable, Equatable {
    let id = UUID()
    var name: String
    var address: String
    var img: Image
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    var bar_id: Int
}

struct BarReviews: Identifiable {
    var id: String { barName }
    let barName: String
    let reviews: [ReviewInfo]
}

// Custom shape for half rounded corners

struct RoundedCornerShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}


struct UserInfo: Codable{
    var email: String
    var username: String
    var profPicURL: String
}

struct Post {
    var rating: Int
    var description: String
    var bar: String?
    var image: UIImage?
    var imageURL: String?
}

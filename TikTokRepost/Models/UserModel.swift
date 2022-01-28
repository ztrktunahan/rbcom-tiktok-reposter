//
//  UserModel.swift
//  TikStats
//
//  Created by VladDeveloper on 09/10/21.
//  Copyright © 2021 VladDeveloper. All rights reserved.
//

import UIKit

// User model to hold details about user account
class UserModel: NSObject {
    
    var id: String
    var followers: NSNumber
    var following: NSNumber
    var hearts: NSNumber
    var video: NSNumber
    var profileDescription: String = ""
    var profilePictureURL: String
    var image: UIImage? = nil
    
    init?(dictionary: [String : Any]) {
        if let identifier = dictionary["id"] as? String,
            let followersCount = dictionary["followersCount"] as? NSNumber,
            let followingCount = dictionary["followingCount"] as? NSNumber,
            let heartsCount = dictionary["heartsCount"] as? NSNumber,
            let videoCount = dictionary["videoCount"] as? NSNumber,
            let profilePicUrl = dictionary["avatar"] as? String {
            self.followers = followersCount
            self.following = followingCount
            self.profilePictureURL = profilePicUrl
            self.id = identifier
            self.video = videoCount
            self.profileDescription = dictionary["description"] as? String ?? ""
            self.hearts = heartsCount
        } else { return nil }
    }
}

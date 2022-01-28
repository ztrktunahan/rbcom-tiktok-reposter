//
//  MediaModel.swift
//  TikStats
//
//  Created by VladDeveloper on 09/10/21.
//  Copyright © 2021 VladDeveloper. All rights reserved.
//

import UIKit

// Media model to hold details about user posts
class MediaModel: NSObject {
    
    private var videoData: [[String: Any]]
    
    var videoPosts: [VideoDetail] {
        var posts = [VideoDetail]()
        videoData.forEach { (dictionary) in
            if let videoPost = VideoDetail(dictionary: dictionary),
                !posts.compactMap({ $0.id }).contains(videoPost.id) {
                posts.append(videoPost)
            }
        }
        return posts
    }
    
    init?(dictionary: [String : Any]) {
        if let data = dictionary["videoData"] as? [String: Any],
            let items = data["videosList"] as? [[String: Any]] {
            self.videoData = items
        } else { return nil }
    }
}

// Video post model with cover, likes, comments and more
class VideoDetail: NSObject {
    
    var id: String
    var cover: String
    var likes: Int64
    var comments: Int64
    var image: UIImage? = nil
    
    init?(dictionary data: [String : Any]) {
        if let identifier = data["id"] as? String,
            let commentsCount = data["comments"] as? Int64,
            let likesCount = data["likes"] as? Int64,
            let coverURL = data["cover"] as? String {
            self.comments = commentsCount
            self.likes = likesCount
            self.cover = coverURL
            self.id = identifier
        } else { return nil }
    }
}

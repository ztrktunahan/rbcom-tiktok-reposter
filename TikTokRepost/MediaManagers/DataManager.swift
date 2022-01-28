//
//  DataManager.swift
//  TikTokRepost
//
//  Created by Neon Apps
//  Copyright © 2021 Neon Apps. All rights reserved.
//

import UIKit
import TikTokFeed

// This manages user data, API requests and more
class DataManager: NSObject {
    
    /// Type of followers performance
    enum FollowPerformanceType {
        case none, lost, gained
    }

    static var shared = DataManager()
    var userModel: UserModel?
    var mediaModel: MediaModel?
    
    var followPerformance: Int64 = 0
    var followPerformanceType: FollowPerformanceType = .none
    
    /// Get all details about user
    func fetchUserData(username: String, completion: @escaping (_ userModel: UserModel?) -> Void) {
        userModel = nil
        TikTokManager().fetchUserDetails(user: username, completion: { dictionary in
            guard let jsonData = dictionary else { completion(nil); return }
            if let model = UserModel(dictionary: jsonData) {
                self.saveData(user: model, username: username)
                self.userModel = UserModel(dictionary: jsonData)
            }
            completion(self.userModel)
        })
    }
    
    /// Get all media for user
    func fetchMediaData(completion: @escaping (_ mediaModel: MediaModel?) -> Void) {
        if let model = self.mediaModel, !AppConfig.allowVideoFeedRefresh { completion(model); return }
        guard let user = UserDefaults.standard.string(forKey: "last_username") else {
            completion(nil)
            return
        }
        self.mediaModel = nil
        TikTokManager().fetchVideoFeed(username: user, timeout: AppConfig.videoFeedTimeout) { (json) in
            DispatchQueue.main.async {
                if let dictionary = json, let model = MediaModel(dictionary: dictionary) {
                    self.mediaModel = model
                    completion(model)
                } else { completion(nil) }
            }
        }
    }
  
    /// Download image for a given url
    func downloadImage(url: String, completion: @escaping (_ image: UIImage?) -> Void) {
        let url = URL(string: url)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, let img = UIImage(data: data) else { completion(nil); return }
            completion(img)
        }.resume()
    }
    
    /// Save new data for username and set gain/lost followers data
    func saveData(user: UserModel, username: String) {
        /// Get old data for username
        if let oldData = UserDefaults.standard.dictionary(forKey: username),
            let oldFollowersCount = oldData["followers"] as? NSNumber {

            /// lost followers
            if oldFollowersCount.int64Value > user.followers.int64Value {
                let followersLost = oldFollowersCount.int64Value - user.followers.int64Value
                followPerformance = followersLost
                followPerformanceType = .lost
            
            /// gained followers
            } else if oldFollowersCount.int64Value < user.followers.int64Value {
                let followersGained = user.followers.int64Value - oldFollowersCount.int64Value
                followPerformance = followersGained
                followPerformanceType = .gained
            }
                        
        }
        
        print(followPerformance)
        
        /// Save new data
        let data = ["followers" : user.followers, "following" : user.following]
        UserDefaults.standard.set(username, forKey: "last_username")
        UserDefaults.standard.set(data, forKey: username)
        UserDefaults.standard.synchronize()
    }
    
    /// Reset current username data
    func resetUsernameData() {
        mediaModel = nil
        userModel = nil
        let username = UserDefaults.standard.string(forKey: "last_username") ?? ""
        UserDefaults.standard.set(nil, forKey: "last_username")
        UserDefaults.standard.set(nil, forKey: username)
        UserDefaults.standard.synchronize()
    }
}

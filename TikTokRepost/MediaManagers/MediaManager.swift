//
//  DataManager.swift
//  InstaSaver
//
//  Created by Neon Apps
//  Copyright © 2019 Neon Apps. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import AVFoundation

@objc class MediaManager: NSObject {
    
    let database = Database.shared
    
    static let shared = MediaManager()
    
    let mainUrl = "http://videodownloader.shivjagar.co.in/services/downloader_api.php"

    func getPreviewImage(post: String?, completion: @escaping (_ postMedia: Post?) -> Void) {
        guard let postURL = post else {completion(nil); return}
      
        let urlToGetContent = mainUrl

        AF.request(urlToGetContent, method: .post,parameters: ["url":postURL]).responseJSON { (response:(DataResponse<Any, AFError>)) in
            guard let data = response.data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: [])
            else {
                print("sasdasf \(response.error) - \(response.result) - \(response.error)")
                switch response.result {
                case .failure(_): completion(nil); return
                default: return
                }
            }
            
            if (json as? [String:Any]) != nil
            {
                let jsonData = json as! [String:Any]
                
                let post = Post(context: self.database.context)
                
                post.date = Date()
                post.url = URL(string: postURL)
                                
                if (jsonData["VideoResult"] as? [[String:Any]]) != nil
                {
                    let vdata = jsonData["VideoResult"] as! [[String:Any]]
                                        
                    if (vdata[0]["VideoUrl"] as? String) != nil
                    {
                        
                        let videoUrl = vdata[0]["VideoUrl"] as? String ?? ""
                        
                        if videoUrl != "" {
                            self.downloadVideo(url: videoUrl) { resultURL in
                                post.videoURL = resultURL
                                post.imageData = self.getThumbnailImage(forUrl: resultURL)?.jpegData(compressionQuality: 0.5)
                                completion(post)
                            }
                        }
                        
                    }
                    
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
        
    }
    
    func downloadVideo(url: String, completion: @escaping (_ videoURL: URL) -> Void) {
                
        let destination = DownloadRequest.suggestedDownloadDestination()
        AF.download(url, to: destination).downloadProgress(queue: DispatchQueue.global(qos: .utility)) { (progress) in
            print("Progress: \(progress.fractionCompleted)")
        } .validate().responseData { response in
                        
            if let fileURL = response.fileURL {
                completion(fileURL)
                let videoData = NSData(contentsOf: fileURL)
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let documentsDirectory = paths.first
                let tempPath = documentsDirectory?.appending("/vid1.mp4")
                videoData?.write(toFile: tempPath!, atomically: false)
            }else{
                
                print("burda sıçtık")
            }
            
        }
    }
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)

        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }

        return nil
    }
    
}

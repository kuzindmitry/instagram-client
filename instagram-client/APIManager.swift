//
//  APIManager.swift
//  instagram-client
//
//  Created by kuzindmitry on 11.07.17.
//  Copyright © 2017 Dmitry Kuzin. All rights reserved.
//

import Foundation
import UIKit

class APIManager {

    struct API {
        static let host = "https://api.instagram.com/v1/"
        static let token = "?access_token="
    }
    
    static let shared = APIManager()

    func getUser(_ completion: @escaping (User?) -> Void) {
        if let token = Credential.token {
            self.load(API.host + "users/self/" + API.token + token) { (json) in
                if let result = (json as? [String:Any])?["data"] as? [String:Any] {
                    completion(User(response: result))
                } else {
                    completion(nil)
                }
            }
        }
    }

    func getPhotos(_ completion: @escaping ([Photo]) -> Void) {
        if let token = Credential.token {
            self.load(API.host + "users/self/media/recent/" + API.token + token, { (json) in
                if let resultArray = (json as? [String:Any])?["data"] as? [[String:Any]] {
                    var photos: [Photo] = []
                    for object in resultArray {
                        photos.append(Photo(response: object))
                    }
                    completion(photos)
                } else {
                    completion([])
                }
            })
        }
    }
    
    func searchTag(tag: String, _ completion: @escaping ([Tag]) -> Void) {
        if let token = Credential.token {
            var stringUrl = API.host + "tags/search" + API.token + token + "&q=" + tag
            stringUrl = stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            self.load(stringUrl, { (json) in
                if let result = (json as? [String:Any])?["data"] as? [[String:Any]] {
                    var tags: [Tag] = []
                    for object in result {
                        tags.append(Tag(response: object))
                    }
                    completion(tags)
                } else {
                    completion([])
                }
            })
        }
    }
    
    func getPhotosForTag(_ tag: Tag, _ completion: @escaping ([Photo]) -> Void) {
        if let token = Credential.token {
            var stringUrl = API.host + "tags/" + tag.name + "/media/recent" + API.token + token
            stringUrl = stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            self.load(stringUrl, { (json) in
                if let result = (json as? [String:Any])?["data"] as? [[String:Any]] {
                    var photos: [Photo] = []
                    for object in result {
                        photos.append(Photo(response: object))
                    }
                    completion(photos)
                } else {
                    completion([])
                }
            })
        }
    }
    
    private func load(_ url: String, _ completion: @escaping (Any?) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                return
            }
             UIApplication.shared.isNetworkActivityIndicatorVisible = false
            completion(try? JSONSerialization.jsonObject(with: data, options: .mutableContainers))
        }.resume()
    }
}

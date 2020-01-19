
//
//  NetworkManager.swift
//  Quick Hunt
//
//  Created by Surjit Chowdhary on 18/01/20.
//  Copyright © 2020 Surjit. All rights reserved.
//

import Foundation

class NetworkManager {

    //making class Singleton
    static let shared = NetworkManager()

    //Server url
    static let ServerUrl = "https://api.producthunt.com"
    static let authorizationKey = "zJDQvfIPB626ljp7i4vvP8YznZDacH8OpAw55msod5k"
    static let hostName = "api.producthunt.com"

    //create http object
    let httpClient = HTTPClient.shared

    //endpoints
    let postEndpoint = "/v1/posts"
    let commentEndPoint = "/v1/comments?search[post_id]=%d"


    func getAllPosts(for date: String, completionHadler: @escaping (([Post]?, Error?) -> Void)) {
        var updatedPostEndpoint = self.postEndpoint
        if !date.isEmpty {
           updatedPostEndpoint  = "\(self.postEndpoint)?day=\(date)"
        }

        let urlString = "\(NetworkManager.ServerUrl)\(updatedPostEndpoint)"
        httpClient.dataRequest(with: urlString, method: .GET, requestBody: nil, objectType: CustomData.self) { (result: CustomResult) in
        switch result {
        case .success(let object):
            completionHadler(object.posts, nil)
        case .failure(let error):
            debugPrint(error)
            completionHadler(nil, error)
            }
        }
    }

    func getComments(for postId: Int, completionHadler: @escaping (([Comment]?, Error?) -> Void)) {
        let endpoint = String(format: self.commentEndPoint, postId)
        let urlString = "\(NetworkManager.ServerUrl)\(endpoint)"
        httpClient.dataRequest(with: urlString, method: .GET, requestBody: nil, objectType: CustomComment.self) { (result: CustomResult) in
        switch result {
        case .success(let object):
            completionHadler(object.comments, nil)
        case .failure(let error):
            debugPrint(error)
            completionHadler(nil, error)
            }
        }
    }
}

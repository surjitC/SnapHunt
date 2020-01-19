//
//  ProductViewModel.swift
//  Snap Hunt
//
//  Created by Surjit Chowdhary on 19/01/20.
//  Copyright © 2020 Surjit. All rights reserved.
//

import Foundation
import UIKit

class ProductViewModel {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var posts: [PostDataModel] = []
    private var searchPosts: [PostDataModel] = []
    private var comments: [Comment] = []
    
    func initialLoadPosts() {
        self.posts = DatabaseManager.shareInstance.getData()
        self.searchPosts = self.posts
    }
    
    func getTodayPosts(completionHadler: @escaping ((Bool) -> Void)) {
        NetworkManager.shared.getAllPosts(for: "") { (postdata, error) in
            if let postsData = postdata {
                DispatchQueue.main.async {
                    self.posts = self.postToPostDataModel(posts: postsData)
                    DatabaseManager.shareInstance.deleteData()
                    DatabaseManager.shareInstance.saveData(posts: postsData)
                    self.posts = DatabaseManager.shareInstance.getData()
                    self.searchPosts = self.posts
                }
            }
            completionHadler(true)
        }
    }
    
    func getPosts(for date: String, completionHadler: @escaping ((Bool) -> Void)) {
        NetworkManager.shared.getAllPosts(for: date) { (postdata, error) in
            self.posts = []
            DispatchQueue.main.async {
                if let posts = postdata {
                    self.posts = self.postToPostDataModel(posts: posts)
                } else {
                    self.posts = DatabaseManager.shareInstance.getData()
                }
                self.searchPosts = self.posts
                completionHadler(true)
            }
        }
    }
    
    func getPosts() -> [PostDataModel] {
        return searchPosts
    }
    
    func postToPostDataModel(posts: [Post]) -> [PostDataModel] {
        var postDataModels: [PostDataModel] = []
        for post in posts {
            let postModel = PostDataModel(context: context)
            postModel.id = Int64(Int(post.id ?? 0))
            postModel.commentCount = Int64(post.commentsCount ?? 0)
            postModel.name = post.name
            postModel.tagline = post.tagline
            postDataModels.append(postModel)
        }
        return postDataModels
        
    }
    
    func searchPosts(by value: String, completionHadler: @escaping ((Bool) -> Void)) {
        if !value.isEmpty {
            self.searchPosts = self.posts.filter { (model) -> Bool in
                model.name?.lowercased().contains(value.lowercased()) ?? false || model.tagline?.lowercased().contains(value.lowercased()) ?? false
            }
            
        } else {
            self.searchPosts = self.posts
        }
        completionHadler(true)
        
    }
    
    func clearComments() {
        self.comments = []
    }
    
    func getComment(for postId: Int, completionHadler: @escaping ((Bool) -> Void)) {
        NetworkManager.shared.getComments(for: postId) { (comments, error) in
            guard let comments = comments else {
                debugPrint(error as Any)
                completionHadler(false)
                return
            }
            self.comments = comments
            completionHadler(true)
        }
    }
    
    func getComments() -> [Comment] {
        return self.comments
    }
}

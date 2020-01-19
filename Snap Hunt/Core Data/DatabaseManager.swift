//
//  DatabaseManager.swift
//  Snap Hunt
//
//  Created by Surjit Chowdhary on 19/01/20.
//  Copyright © 2020 Surjit. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DatabaseManager {

    static let shareInstance = DatabaseManager()


    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func saveData(posts: [Post]) {

        for post in posts {
            let postModel = PostDataModel(context: context)
            postModel.id = Int64(Int(post.id ?? 0))
            postModel.commentCount = Int64(post.commentsCount ?? 0)
            postModel.voteCount = Int64(Int(post.votesCount ?? 0))
            postModel.name = post.name
            postModel.tagline = post.tagline
        }
        do {
            try context.save()
            print("Posts are saved")
        } catch {
            print(error.localizedDescription)
        }
    }

    func getData() -> [PostDataModel] {
        var posts: [PostDataModel] = []
        let fetchRequest: NSFetchRequest<PostDataModel> = PostDataModel.fetchRequest()

        do {
            let result = try self.context.fetch(fetchRequest)
            posts = result
        } catch {
            debugPrint("Failed")
        }

        return posts
    }

    func deleteData() {
        let fetchRequest: NSFetchRequest<PostDataModel> = PostDataModel.fetchRequest()

        do {
            let result = try self.context.fetch(fetchRequest)
            for post in result {
                context.delete(post)
            }
        } catch {
            debugPrint("Failed")
        }
    }
}


//
//  CommentViewController.swift
//  Snap Hunt
//
//  Created by Surjit Chowdhary on 20/01/20.
//  Copyright © 2020 Surjit. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var commentTableView: UITableView!

    //product view model
    var productViewModel: ProductViewModel?
    var postId: Int?
    var pageIndex = 1
    var totalPageCount = 0

    //invoking controllers
    class func initiateCommentVC() -> CommentViewController {
        guard let commentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommentViewController") as? CommentViewController else {
            return CommentViewController()
        }
        return commentViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.productViewModel?.clearComments()
        
        guard let postId = self.postId else {
            return
        }
        self.productViewModel?.getComment(for: postId, completionHadler: { [weak self] (succes) in
            if succes {
                DispatchQueue.main.async {
                    self?.calculateTotalPages()
                    self?.commentTableView.reloadData()
                }
            }
        })
    }

    func calculateTotalPages() {
        let numberOfComments = productViewModel?.getComments().count ?? 0
        totalPageCount = numberOfComments / 5
        if numberOfComments % 5 > 0 {
            totalPageCount += 1
        }
    }

    @IBAction func nextTapped(_ sender: Any) {
        if pageIndex < totalPageCount {
            pageIndex += 1
        }
        self.commentTableView.reloadData()
    }
    
    @IBAction func previousTapped(_ sender: Any) {
        if pageIndex > 1 {
            pageIndex -= 1
        }
        self.commentTableView.reloadData()
    }
}

extension CommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if productViewModel?.getComments().count == nil || totalPageCount == 0 {
            return 0
        }
        let numberOfComments = productViewModel?.getComments().count ?? 0
        if pageIndex == totalPageCount, numberOfComments % 5 > 0 {
            return numberOfComments %  5
        }
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.cellIdentifier, for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }
//        if pageIndex * indexPath.row <= productViewModel?.getComments().count ?? 0 {
        let currentIndex = (pageIndex - 1) * 5 + indexPath.row
            if let comment = productViewModel?.getComments()[currentIndex] {
                cell.configureCell(comment: comment)
            }
            return cell
//        }

    }


}

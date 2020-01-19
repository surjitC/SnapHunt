//
//  CommentTableViewCell.swift
//  Snap Hunt
//
//  Created by Surjit Chowdhary on 20/01/20.
//  Copyright © 2020 Surjit. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    static let cellIdentifier = "CommentTableViewCell"

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var commentText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(comment: Comment) {
        self.commentText.text = comment.body
        self.userName.text = comment.user?.name
    }
}

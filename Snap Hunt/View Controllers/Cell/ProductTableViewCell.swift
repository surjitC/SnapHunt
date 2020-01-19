//
//  ProductTableViewCell.swift
//  Snap Hunt
//
//  Created by Surjit Chowdhary on 18/01/20.
//  Copyright © 2020 Surjit. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    static let cellIdentifier = "ProductTableViewCell"
    
    @IBOutlet weak var mainBackgroudView: UIView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productTagline: UILabel!
    @IBOutlet weak var commentCount: UIButton!
    @IBOutlet weak var voteCounts: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func configureCell(post: PostDataModel) {
        self.productName.text = post.name
        self.productTagline.text = post.tagline
        self.commentCount.setTitle("\(post.commentCount)", for: .normal)

        self.voteCounts.text = "\(post.voteCount)"
    }
}

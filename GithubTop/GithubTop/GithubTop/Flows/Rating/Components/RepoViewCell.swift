//
//  TableViewCell.swift
//  GithubTop
//
//  Created by Владимир Лишаненко on 3/10/21.
//

import UIKit

class RepoViewCell: UITableViewCell {
    @IBOutlet var repoNameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var starCountLabel: UILabel!
    
    func configure(with repo: Repo) {
        repoNameLabel.text = repo.fullName
        descriptionLabel.text = repo.itemDescription
        starCountLabel.text = String(repo.starsCount)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

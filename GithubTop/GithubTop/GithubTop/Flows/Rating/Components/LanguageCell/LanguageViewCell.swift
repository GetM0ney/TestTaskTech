//
//  LanguageViewCell.swift
//  GithubTop
//
//  Created by Владимир Лишаненко on 3/10/21.
//

import UIKit

class LanguageViewCell: UITableViewCell {
    @IBOutlet var languageLabel: UILabel!

    func configure(with language: String) {
        languageLabel.text = language
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

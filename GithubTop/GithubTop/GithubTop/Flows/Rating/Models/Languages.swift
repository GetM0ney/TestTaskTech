//
//  Languages.swift
//  GithubTop
//
//  Created by Владимир Лишаненко on 3/10/21.
//

import Foundation

struct Language: Codable {
    let name: String
    let aliases: [String]
}

typealias Languages = [Language]

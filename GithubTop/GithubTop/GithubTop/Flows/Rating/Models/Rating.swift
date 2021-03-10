//
//  Rating.swift
//  GithubTop
//
//  Created by Владимир Лишаненко on 3/10/21.
//

import Foundation

struct Rating: Codable, Equatable {
    let totalCount: Int
    let incompleteResults: Bool
    var items: [Repo]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
    
    static func == (lhs: Rating, rhs: Rating) -> Bool {
        return lhs.totalCount == rhs.totalCount
            && lhs.incompleteResults == rhs.incompleteResults
            && lhs.items == rhs.items
    }
}

struct Repo: Codable, Equatable {
    let fullName: String
    let htmlURL: String
    let itemDescription: String?
    let starsCount: Int

    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case htmlURL = "html_url"
        case itemDescription = "description"
        case starsCount = "stargazers_count"
    }
}

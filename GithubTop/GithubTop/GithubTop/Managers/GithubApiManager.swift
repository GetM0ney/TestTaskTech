//
//  GithubApiManager.swift
//  GithubTop
//
//  Created by Владимир Лишаненко on 3/10/21.
//

import Foundation

enum PathType: FinalURLPoint {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }

    var path: String {
        switch self {
        case let .rating(lang: lang, page: page):
            return "/search/repositories?q=language:\(lang.replacingOccurrences(of: " ", with: "%20"))&sort=stars&page=\(page)"
        case .languages:
            return "/languages"
        }
    }

    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURL)
        return URLRequest(url: url!)
    }

    case rating(lang: String, page: String)
    case languages
}

final class GithubApiManager: NSObject, APIManager {
    lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .useProtocolCachePolicy
        return URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue())
    }()

    lazy var imageCache: NSCache<NSString, NSData> = {
        NSCache<NSString, NSData>()
    }()

    var dataTask: URLSessionDataTask?

    func fetchRatingWith(lang: String, page: String, completionHandler:
        @escaping (APIResult<Rating>) -> Void) {
        let request = PathType.rating(lang: lang, page: page).request
        fetch(request: request) { result in
            completionHandler(result)
        }
    }

    func fetchLanguages(completionHandler:
        @escaping (APIResult<Languages>) -> Void) {
        let request = PathType.languages.request
        fetch(request: request) { result in
            completionHandler(result)
        }
    }
}

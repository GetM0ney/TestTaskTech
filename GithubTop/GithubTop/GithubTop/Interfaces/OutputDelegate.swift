//
//  OutputDelegate.swift
//  GithubTop
//
//  Created by Владимир Лишаненко on 3/10/21.
//

import Foundation

protocol OutputDelegate: AnyObject {
    func getError(_ error: Error)
    func getNewData()
}

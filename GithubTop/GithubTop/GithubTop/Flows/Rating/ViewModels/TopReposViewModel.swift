//
//  TopReposViewModel.swift
//  GithubTop
//
//  Created by Владимир Лишаненко on 3/10/21.
//

import Foundation

protocol TopReposCoordinatorDelegate: AnyObject {
    func showUrl(_ url: URL)
    func selectLanguage(isFirstLaunch: Bool)
}

class TopReposViewModel {
    private let apiManager = GithubApiManager()
    private let databaseManage = CoreDataManager()

    weak var delegate: OutputDelegate?
    var coordinatorDelegate: TopReposCoordinatorDelegate?

    private(set) var topRepos: Rating?
    private var currentPage = 1
    private var currentLanguage: String?

    func requestRating(isNewPage: Bool) {
        guard let entities = databaseManage.fetchRecordsForEntity(String(describing: DBLanguage.self)) as? [DBLanguage],
              let entity = entities.first,
              let language = entity.name else {
            coordinatorDelegate?.selectLanguage(isFirstLaunch: true)
            return
        }

        if isNewPage { currentPage += 1 }
        if currentLanguage != language {
            topRepos = nil
            currentLanguage = language
        }

        apiManager.fetchRatingWith(lang: language, page: String(currentPage)) { [weak self] result in
            switch result {
            case let .failure(error):
                self?.delegate?.getError(error)
            case let .success(model):
                if let topRepos = self?.topRepos {
                    model.items.filter { !topRepos.items.contains($0) }.forEach {
                        self?.topRepos?.items.append($0)
                    }
                } else {
                    self?.topRepos = model
                }

                self?.delegate?.getNewData()
            }
        }
    }
}

//
//  LanguageViewModel.swift
//  GithubTop
//
//  Created by Владимир Лишаненко on 3/10/21.
//

import Foundation

protocol LanguageOutputDelegate: OutputDelegate {
    func firstLaunch()
}

class LanguageViewModel {
    let apiManager = GithubApiManager()
    let databaseManager = CoreDataManager()
    weak var delegate: LanguageOutputDelegate?
    
    private var isFirstLaunch: Bool
    private(set) var languages = Languages()
    
    init(isFirstLaunch: Bool) {
        self.isFirstLaunch = isFirstLaunch
    }

    func requestLanguages() {
        if isFirstLaunch {
            delegate?.firstLaunch()
            isFirstLaunch = false
        }
        
        apiManager.fetchLanguages { [weak self] result in
            switch result {
            case let .failure(error):
                self?.delegate?.getError(error)
            case let .success(model):
                self?.languages = model
                self?.delegate?.getNewData()
            }
        }
    }
    
    func saveLanguage(_ language: String) {
        let entities = databaseManager.fetchRecordsForEntity(String(describing: DBLanguage.self))
        if entities.count == 0 {
            let entity = databaseManager.createRecordForEntity(String(describing: DBLanguage.self)) as? DBLanguage
            entity?.name = language
            databaseManager.saveContext()
        } else {
            let entity = entities.first as? DBLanguage
            entity?.name = language
            databaseManager.saveContext()
        }
    }
}

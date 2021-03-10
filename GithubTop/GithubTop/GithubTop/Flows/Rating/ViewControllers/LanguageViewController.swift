//
//  LanguageViewController.swift
//  GithubTop
//
//  Created by Владимир Лишаненко on 3/10/21.
//

import PKHUD
import UIKit

class LanguageViewController: UITableViewController {
    private var viewModel: LanguageViewModel
    private var isSearchEnabled = false
    private var searchResults = Languages()

    init(viewModel: LanguageViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    private func configure() {
        tableView.register(UINib(resource: R.nib.languageViewCell), forCellReuseIdentifier: String(describing: LanguageViewCell.self))

        viewModel.requestLanguages()
        HUD.show(.progress)

        tableView.delegate = self
        tableView.allowsSelection = true

        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        navigationItem.searchController = search

        title = R.string.localizable.languageTitle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LanguageViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }

        if text.isEmpty {
            isSearchEnabled = false
            tableView.reloadData()
            return
        }

        isSearchEnabled = true

        searchResults = viewModel.languages.filter {
            $0.name.lowercased().contains(text.lowercased())
        }
        tableView.reloadData()
    }
}

extension LanguageViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = isSearchEnabled ? searchResults[indexPath.row].name : viewModel.languages[indexPath.row].name
        viewModel.saveLanguage(name)
        navigationController?.popViewController(animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchEnabled ? searchResults.count : viewModel.languages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LanguageViewCell.self), for: indexPath) as? LanguageViewCell else { return UITableViewCell() }
        let name = isSearchEnabled ? searchResults[indexPath.row].name : viewModel.languages[indexPath.row].name
        cell.configure(with: name)

        return cell
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension LanguageViewController: LanguageOutputDelegate {
    func firstLaunch() {
        navigationItem.hidesBackButton = true
    }

    func getError(_ error: Error) {
        print(error)

        HUD.show(.error)
    }

    func getNewData() {
        tableView.reloadData()
        HUD.hide()
    }
}

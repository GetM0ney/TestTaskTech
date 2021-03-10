//
//  TopRepoViewController.swift
//  GithubTop
//
//  Created by Владимир Лишаненко on 3/10/21.
//

import PKHUD
import UIKit

class TopReposViewController: UITableViewController {
    private var viewModel: TopReposViewModel
    private var oldOffset: CGFloat = 0

    init(viewModel: TopReposViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.requestRating(isNewPage: false)
        HUD.show(.progress)
    }

    private func configure() {
        let lang = UIBarButtonItem(image: R.image.language(), style: .plain, target: self, action: #selector(selectLanguage))
        navigationItem.rightBarButtonItem = lang

        tableView.delegate = self
        tableView.allowsSelection = true
        tableView.allowsSelectionDuringEditing = true
        tableView.register(UINib(resource: R.nib.repoViewCell), forCellReuseIdentifier: String(describing: RepoViewCell.self))
    }

    @objc private func selectLanguage() {
        viewModel.coordinatorDelegate?.selectLanguage(isFirstLaunch: false)
    }
}

extension TopReposViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let repo = viewModel.topRepos?.items[indexPath.row], let url = URL(string: repo.htmlURL) else { return }
        viewModel.coordinatorDelegate?.showUrl(url)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.topRepos?.items.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RepoViewCell.self), for: indexPath) as? RepoViewCell,
              let repo = viewModel.topRepos?.items[indexPath.row] else { return UITableViewCell() }
        cell.configure(with: repo)

        return cell
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension TopReposViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset

        if deltaOffset <= 0, currentOffset - oldOffset > 100 {
            oldOffset = currentOffset
            HUD.show(.progress)
            viewModel.requestRating(isNewPage: true)
        }
    }
}

extension TopReposViewController: OutputDelegate {
    func getError(_ error: Error) {
        print(error)

        HUD.show(.error)
    }

    func getNewData() {
        title = "\(R.string.localizable.ratingTitle()) \(viewModel.topRepos?.totalCount ?? 0)"
        tableView.reloadData()
        HUD.hide()
    }
}

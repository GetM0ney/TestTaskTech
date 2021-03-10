//
//  WebViewController.swift
//  GithubTop
//
//  Created by Владимир Лишаненко on 3/10/21.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    var webView: WKWebView

    init(url: URL) {
        let request = URLRequest(url: url)

        webView = WKWebView()
        webView.load(request)

        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = webView
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

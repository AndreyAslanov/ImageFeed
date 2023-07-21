//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Андрей Асланов on 24.06.23.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    private let ShowWebViewSegueIdentifier = "ShowWebView"

    weak var delegate: AuthViewControllerDelegate?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(ShowWebViewSegueIdentifier)") }
            print("делегат работает")
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        OAuth2Service.shared.fetchOAuthToken(code) { [weak self] result in
            
            print ("код\(code)")                                                                    //принт
            guard let self = self else { return }

            switch result {
            case .success(let authToken):
                print("Полученный токен: \(authToken)")
                OAuth2TokenStorage.shared.token = authToken
            case .failure(let error):
                print("Ошибка получения токена: \(error)")
            }

            DispatchQueue.main.async {
                self.delegate?.authViewController(self, didAuthenticateWithCode: code)
            }
        }
//        delegate?.authViewController(self, didAuthenticateWithCode: code)              не знаю оставить или удалить
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}


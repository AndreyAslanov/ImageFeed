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
    private let webViewIdentifier = "ShowWebView"
    static let storyboardID = "AuthViewController"

    weak var delegate: AuthViewControllerDelegate?
    
    @IBOutlet private weak var authButton: UIButton!
    @IBAction private func didTapAuthButton(_ sender: Any?) {
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = .black

//        authButton.layer.cornerRadius = 16
//        authButton.layer.masksToBounds = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == webViewIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { assertionFailure("Failed to prepare for \(webViewIdentifier)")
                return 
            }
            print("делегат работает")
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
//        OAuth2Service.shared.fetchOAuthToken(code) { [weak self] result in
//
//            print ("код\(code)")
//            guard let self = self else { return }
//
//            switch result {
//            case .success(let authToken):
//                print("Полученный токен: \(authToken)")
//                OAuth2TokenStorage.shared.token = authToken
//            case .failure(let error):
//                print("Ошибка получения токена: \(error)")
//            }
//
//            DispatchQueue.main.async {
                delegate?.authViewController(self, didAuthenticateWithCode: code)
            }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}


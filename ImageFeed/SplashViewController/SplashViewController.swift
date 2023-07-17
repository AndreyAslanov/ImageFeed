//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Андрей Асланов on 08.07.23.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = oauth2TokenStorage.token {
            print("токен есть")
            profileService.fetchProfile(token) { result in
                switch result {
                case .success:
                    self.switchToTabBarController()
                case .failure(let error):
                    // Обработка ошибки при вызове fetchProfile
                    print("Ошибка при вызове fetchProfile: \(error)")
                }
            }
        } else {
            performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
//    private func fetchProfile(token: String, completion: @escaping (Result<Void, Error>) -> Void) {
//        profileService.fetchProfile(token) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success:
//                UIBlockingProgressHUD.dismiss()
//                print("ПрогрессХуд.дисмисс")
//                self.switchToTabBarController()
//            case .failure:
//                UIBlockingProgressHUD.dismiss()
//                print("ПрогрессХуд.дисмисс")
//                break
//            }
//        }
//    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(ShowAuthenticationScreenSegueIdentifier)") }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            print("ПрогрессХуд.шоу")
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                profileService.fetchProfile(code) { result in
                    switch result {
                    case .success:
                        self.switchToTabBarController()
                        UIBlockingProgressHUD.dismiss()
                        print("ПрогрессХуд.дисмисс")
                    case .failure:
                        UIBlockingProgressHUD.dismiss()
                        print("ПрогрессХуд.дисмисс")
                        break
                    }
                }
            case .failure:
                UIBlockingProgressHUD.dismiss()
                print("ПрогрессХуд.дисмисс")
                break
            }
        }
    }
}

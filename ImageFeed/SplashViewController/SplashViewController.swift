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
    private let alertPresenter = AlertPresenter()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("вьюДидАпир")
        
        if let token = oauth2TokenStorage.token {
//            switchToTabBarController()                                не знаю оставить или удалить
            profileService.fetchProfile(token) { result in
                switch result {
                case .success:
                    self.switchToTabBarController()
                    print("Данные загрузились")
                case .failure(let error):
                    self.showErrorAlert(error: error)
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
    
    private func showErrorAlert(error: Error) {
        alertPresenter.showAlert(title: "Что-то пошло не так(", message: "Не удалось войти в систему, \(error.localizedDescription)"){ self.performSegue(withIdentifier: self.ShowAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
            guard let navigationController = segue.destination as? UINavigationController,
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

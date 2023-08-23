//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Андрей Асланов on 11.06.23.
//

import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    
    func updateAvatar(url: URL)
    func nameLabel(_ name: String)
    func userNameLabel(_ userName:String)
    func descriptionLabel(_ description: String)
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    var presenter: ProfileViewPresenterProtocol?
    
    private let blackView = UIView()
    private let profileImage = UIImage(named:"Avatar")
    private let nameLabel = UILabel()
    private let loginNameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let avatarImageView = UIImageView()
    private let profileService = ProfileService.shared
    private let alertManager = Alert.shared
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "logout_button")
        button.accessibilityIdentifier = "logout_button"
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func nameLabel(_ name: String) {
        nameLabel.text = name
    }
    
    func userNameLabel(_ userName: String) {
        loginNameLabel.text = userName
    }
    
    func descriptionLabel(_ description: String) {
        descriptionLabel.text = description
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let presenter = ProfileViewPresenter(view: self)

        setupViews()
        setupConstraints()
        presenter.updateProfileDetails(profile: profileService.profile)

        view.backgroundColor = UIColor(named: "YP Black")
        
        presenter.updateAvatar()
    }

    func updateAvatar(url: URL) {
        let cache = ImageCache.default
        cache.clearDiskCache()
        
        avatarImageView.kf.setImage(with: url)
        let processor = RoundCornerImageProcessor(cornerRadius: 42)
        
        avatarImageView.kf.setImage(with: url,
                                    placeholder: UIImage(named: "placeholder"),
                                    options: [.processor(processor), .transition(.fade(1))])
    }
    
    private func setupViews() {
        
        blackView.backgroundColor = UIColor(named: "YP Black")
        blackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blackView)
        
        avatarImageView.image = profileImage
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        
        logoutButton.setImage(UIImage(named: "logout_button"), for: .normal)
        logoutButton.tintColor = UIColor(named: "YP Red")
        logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = UIColor(named: "YP White")
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.textColor = UIColor(named: "YP Gray")
        loginNameLabel.font = UIFont.systemFont(ofSize: 13)
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        
        descriptionLabel.text = "Hello, World!"
        descriptionLabel.textColor = UIColor(named: "YP White")
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
           NSLayoutConstraint.activate([

            blackView.topAnchor.constraint(equalTo: view.topAnchor),
            blackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),

            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55),
            logoutButton.leadingAnchor.constraint(greaterThanOrEqualTo: avatarImageView.leadingAnchor),

            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
            
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
           ])
    }
        
    @objc
    private func didTapLogoutButton() {
        alertManager.showAlert(on: self) {
               OAuth2TokenStorage.shared.clean()
               WebViewViewController.clean()
               CacheManager.clean()
               
               guard let window = UIApplication.shared.windows.first else {
                   assertionFailure("invalid configuration")
                   return
               }
               window.rootViewController = SplashViewController()
               window.makeKeyAndVisible()
           }
       }
}

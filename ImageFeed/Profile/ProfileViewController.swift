//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Андрей Асланов on 11.06.23.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let blackView = UIView()
    private let profileImage = UIImage(named:"Avatar")
    private let nameLabel = UILabel()
    private let loginNameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let avatarImageView = UIImageView()
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "logout_button")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()

        updateProfileDetails(profile: profileService.profile)
        
        view.backgroundColor = UIColor(named: "YP Black")
        
        profileImageServiceObserver = NotificationCenter.default   
            .addObserver(
                forName: ProfileImageService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
    private func updateAvatar() {
        guard let profileImage = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImage)
        else { return }
        let cache = ImageCache.default
        cache.clearDiskCache()
        avatarImageView.kf.setImage(with: url)
        let processor = RoundCornerImageProcessor(cornerRadius: 42)
        
        avatarImageView.kf.setImage(with: url,
                                 placeholder: UIImage(named: "placeholder"),
                                 options: [.processor(processor), .transition(.fade(1))])
    }
    
    func updateProfileDetails(profile: ProfileService.Profile?){
        if let profile = profile{
            nameLabel.text = profile.name
            loginNameLabel.text = profile.loginName
            descriptionLabel.text = profile.bio
        } else {
            print("Ошибка: Значение profile равно nil")
        }
    }
    
    private func setupViews() {
        
        blackView.backgroundColor = UIColor(named: "YP Black")
        blackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blackView)
        
        let profileImage = UIImage(named: "Photo")
        avatarImageView.image = profileImage
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        
        logoutButton.setImage(UIImage(named: "logout_button"), for: .normal)
        logoutButton.tintColor = UIColor(named: "YP Red")
        logoutButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
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
    private func didTapButton() {
        
        for view in view.subviews {
            if view is UILabel {
                view.removeFromSuperview()
            }
        }
    }
    
    deinit {
        if let observer = profileImageServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}


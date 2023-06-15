//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Андрей Асланов on 11.06.23.
//

import UIKit

final class ProfileViewController: UIViewController {
    private var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let blackView = UIView()
        blackView.backgroundColor = UIColor(named: "YP Black")

        blackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blackView)

        NSLayoutConstraint.activate([
        blackView.topAnchor.constraint(equalTo: view.topAnchor),
        blackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        blackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        blackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        

        let profileImage = UIImage(named: "Photo")
        let avatarImageView = UIImageView(image: profileImage)
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        
        NSLayoutConstraint.activate([
        avatarImageView.widthAnchor.constraint(equalToConstant: 70),
        avatarImageView.heightAnchor.constraint(equalToConstant: 70),
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
        avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        
        let logoutButton = UIButton.systemButton(
            with: UIImage(named: "logout_button")!,
            target: self,
            action: #selector(Self.didTapButton)
        )
        
        logoutButton.tintColor = UIColor(named: "YP Red")
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
        logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55),
        logoutButton.leadingAnchor.constraint(greaterThanOrEqualTo: avatarImageView.leadingAnchor)
        ])
        
        
        let nameLabel = UILabel()
        let loginNameLabel = UILabel()
        let descriptionLabel = UILabel()
        
        nameLabel.text = "Екатерина Новикова"
        loginNameLabel.text = "@ekaterina_nov"
        descriptionLabel.text = "Hello, World!"
        
        nameLabel.textColor = UIColor(named: "YP White")
        loginNameLabel.textColor = UIColor(named: "YP Gray")
        descriptionLabel.textColor = UIColor(named: "YP White")
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        loginNameLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
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
}


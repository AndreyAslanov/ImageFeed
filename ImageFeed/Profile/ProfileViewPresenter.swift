//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Андрей Асланов on 09.08.23.
//

import Foundation
import UIKit
import Kingfisher

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func updateAvatar()
    func updateProfileDetails(profile: Profile?)
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
            }
    }
    
    init(view: ProfileViewControllerProtocol) {
        self.view = view
    }
    
    func updateAvatar() {
        guard let profileImage = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImage)
        else { return }
        
        view?.updateAvatar(url: url)
        
    }
    
    func updateProfileDetails(profile: Profile?) {
        if let profile = profile{
            if let name = profile.name,
               let loginName = profile.loginName,
               let bio = profile.bio {
                view?.nameLabel(name)
                view?.userNameLabel(loginName)
                view?.descriptionLabel(bio)
            }
        } else {
            print("Ошибка: Значение profile равно nil")
        }
    }

}



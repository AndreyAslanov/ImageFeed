//
//  ProfileViewPresenterTests.swift
//  ImageFeedTests
//
//  Created by Андрей Асланов on 13.08.23.
//

import UIKit
import ImageFeed

final class ProfileViewPresenterSpy: ImageFeed.ProfileViewPresenterProtocol {
    
    var view: ImageFeed.ProfileViewControllerProtocol?
    
    var isUpdateAvatarCalled = false
    var isUpdateProfileCalled = false

    var isViewDidLoadCalled: Bool = false
    
    var receivedAvatarURL: URL?
    
    func updateAvatar() {
        isUpdateAvatarCalled = true
    }
    
    func updateAvatar(url: URL) {
        isUpdateAvatarCalled = true
        receivedAvatarURL = url
    }
    
    func updateProfileDetails(profile: ImageFeed.Profile?) {
        isUpdateProfileCalled = true
    }
    
    func viewDidLoad() {
        isViewDidLoadCalled = true
    }
    
    
}

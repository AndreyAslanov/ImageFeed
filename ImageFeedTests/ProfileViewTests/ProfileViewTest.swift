//
//  ProfileViewControllerTests.swift
//  ImageFeedTests
//
//  Created by Андрей Асланов on 13.08.23.
//

import XCTest
@testable import ImageFeed 

final class ProfileViewTest: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
            viewController.presenter = presenter
            presenter.view = viewController
        
        //when
        _ = viewController.view
        presenter.viewDidLoad()

        //then
        XCTAssertTrue(presenter.isViewDidLoadCalled)
    }
 
    func testProfileViewControllerUpdateAvatar() {
        
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        let url = DefaultBaseURL
                
        //When
        viewController.updateAvatar(url: url)
        
        //Then
        XCTAssertTrue(viewController.isUpdateAvatarCalled)
    }
    
    func testProfileViewControllerUpdateProfile() {
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        let profile = Profile(userName: "", name: nil, loginName: "", bio: nil)

                
        //When
        presenter.updateProfileDetails(profile: profile)
        
        //Then
        XCTAssertTrue(presenter.isUpdateProfileCalled)
    }


}



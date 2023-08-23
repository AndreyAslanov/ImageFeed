//
//  ProfileModels.swift
//  ImageFeed
//
//  Created by Андрей Асланов on 12.08.23.
//

import Foundation

struct ProfileResult: Codable{
    let userName: String?
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    private enum CodingKeys: String, CodingKey {
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

public struct Profile{
    let userName: String?
    let name: String?
    let loginName: String?
    let bio: String?
}


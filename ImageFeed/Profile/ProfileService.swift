//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Андрей Асланов on 15.07.23.
//

import Foundation

final class ProfileService{
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    struct ProfileResult: Codable{
        let userName: String?
        let firstName: String?
        let lastName: String?
        let bio: String?
        let profileImage: ProfileImage?
        
        private enum CodingKeys: String, CodingKey {
            case userName = "username"
            case firstName = "first_name"
            case lastName = "last_name"
            case bio
            case profileImage = "profile_image"
        }
    }
    
    struct ProfileImage: Codable {
        let small: String?
        let medium: String?
        let large: String?
    }
    
    struct Profile{
        let userName: String?
        let name: String?
        let loginName: String?
        let bio: String?
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        task?.cancel()
        if task != nil {
            return
        }
        guard let request = profileRequest(token:token) else {
            assertionFailure("Invalid request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        let task = urlSession.objectTask(for:request) {[weak self] (response:Result<ProfileResult, Error>) in
            self?.task = nil
            switch response {
            case .success(let profileResult):
                let profile = Profile(userName: profileResult.userName,
                                      name: profileResult.firstName,
                                      loginName: profileResult.lastName,
                                      bio: profileResult.bio)
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    private func buildProfile(from result: ProfileResult) -> Profile {
        let name = "\(result.firstName ?? "") \(result.lastName ?? "")"
        let loginName = "@\(result.userName ?? "")"
        
        let profile = Profile(
            userName: result.userName ?? "",
            name: name,
            loginName: loginName,
            bio: result.bio ?? ""
        )
        
        return profile
    }
    
    private func profileRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/me") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
    


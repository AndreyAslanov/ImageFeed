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
                let profile = self?.buildProfile(from: profileResult)
                self?.profile = profile
                
                if let profile = profile {
                    completion(.success(profile))
                } else {
                    completion(.failure(NetworkError.invalidResponse))
                }
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
    


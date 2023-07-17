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
        let username: String?
        let first_name: String?
        let last_name: String?
        let bio: String?
    }
    
    struct Profile{
        let username: String
        let name: String
        let loginName: String
        let bio: String
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void){
        if task != nil {
                    return
            }
        let request = profileRequest(token: token)
        let task = urlSession.data(for: request) { [weak self] result in
            guard let self = self else { return }
                    
            switch result {
            case .success(let data):
                do {
                    print("все ок")
                    let decoder = JSONDecoder()
                    let responseObject = try decoder.decode(ProfileResult.self, from: data)
                    let profile = self.buildProfile(from: responseObject)
                    self.profile = profile
                    completion(.success(profile))
                    print("все ок 2")
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
                    
            self.task = nil
        }
                
        self.task = task
        task.resume()
    }
    
    private func buildProfile(from result: ProfileResult) -> Profile {
        let name = "\(result.first_name ?? "") \(result.last_name ?? "")"
        let loginName = "@\(result.username ?? "")"
        
        let profile = Profile(
            username: result.username ?? "",
            name: name,
            loginName: loginName,
            bio: result.bio ?? ""
        )
        
        return profile
    }
    
    private func profileRequest(token: String) -> URLRequest {
        let url = URL(string: "https://api.unsplash.com")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
    


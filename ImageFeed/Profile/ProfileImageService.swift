import Foundation

final class ProfileImageService {
    
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private(set) var avatarURL: String?
    static let shared = ProfileImageService()
    private var fetchProfileImageURLTask: URLSessionTask?
    private let tokenStorage: OAuth2TokenStorage
    private let urlSession = URLSession.shared
    
    private init() {
        tokenStorage = OAuth2TokenStorage.shared
    }
    
    struct UserResult: Codable {
        let profile_image: ProfileImage
    }
    
    struct ProfileImage: Codable {
        let small: String
    }
    
    func fetchProfileImageURL(userName: String, _ completion: @escaping(Result<String, Error>) -> Void) {
        fetchProfileImageURLTask?.cancel()
        
        guard let token = tokenStorage.token else {
            completion(.failure(ProfileImageError.unauthorized))
            return
        }
        
        let baseURL = URL(string: "https://api.unsplash.com/me")!
        let url = baseURL.appendingPathComponent("/users/\(userName)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        fetchProfileImageURLTask = urlSession.objectTask(for: request) { [weak self] (response:Result<UserResult, Error>) in
            defer { self?.fetchProfileImageURLTask = nil }
            
            switch response{
            case .success(let result):
                if !result.profile_image.small.isEmpty {
                    self?.avatarURL = result.profile_image.small
                    completion(.success(result.profile_image.small))
                } else {
                    completion(.failure(ProfileImageError.invalidData))
                }
            case .failure(let error):
                completion(.failure(error))
                
            }
            }
        
        fetchProfileImageURLTask?.resume()
    }
}

enum ProfileImageError: Error {
    case unauthorized
    case invalidData
}

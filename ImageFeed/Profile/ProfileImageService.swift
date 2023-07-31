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
        let medium: String
        let large: String
    }
    
    func fetchProfileImageURL(userName: String, _ completion: @escaping(Result<String, Error>) -> Void) {
        print ("userName: \(userName)")
        assert(Thread.isMainThread)
        fetchProfileImageURLTask?.cancel()
        
        guard let token = tokenStorage.token else {
            assertionFailure("Failed to make HTTP request")
            return
        }
        
        let baseURL = URL(string: "https://api.unsplash.com")!
        let url = baseURL.appendingPathComponent("/users/\(userName)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        fetchProfileImageURLTask = urlSession.objectTask(for: request) { [weak self] (response:Result<UserResult, Error>) in
            defer { self?.fetchProfileImageURLTask = nil }
            
            switch response{
            case .success(let result):
                completion(.success(result.profile_image.large))
                NotificationCenter.default.post(name:ProfileImageService.DidChangeNotification,
                                                object:self,
                                                userInfo: ["URL": result.profile_image.large])
                if let avatarURL = self?.avatarURL {
                    print("URL аватара: \(avatarURL)")
                }
                self?.avatarURL = result.profile_image.large
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        fetchProfileImageURLTask?.resume()
    }
}

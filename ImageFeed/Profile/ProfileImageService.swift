
import Foundation

final class ProfileImageService {
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private(set) var avatarURL: String?
    static let shared = ProfileImageService()
    private var fetchProfileImageURLTask: URLSessionTask?
    private let tokenStorage: OAuth2TokenStorage
    private let urlSession = URLSession.shared
    
    private init() {
        tokenStorage = OAuth2TokenStorage.shared
    }
    
    func fetchProfileImageURL(userName: String, _ completion: @escaping(Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        fetchProfileImageURLTask?.cancel()
        
        guard let token = OAuth2TokenStorage.shared.token else {
            assertionFailure("Failed to make HTTP request")
            return
        }
        guard let baseURL = URL(string: "https://api.unsplash.com") else {
            assertionFailure("Invalid URL")
            return
        }

        let url = baseURL.appendingPathComponent("/users/\(userName)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        fetchProfileImageURLTask = urlSession.objectTask(for: request) { [weak self] (response:Result<UserResult, Error>) in
            defer { self?.fetchProfileImageURLTask = nil }
            
            switch response{
            case .success(let result):
                completion(.success(result.profileImage.large))
                NotificationCenter.default.post(name:ProfileImageService.didChangeNotification,
                                                object:self,
                                                userInfo: ["URL": result.profileImage.large])
                if let avatarURL = self?.avatarURL {
                    print("URL аватара: \(avatarURL)")
                }
                self?.avatarURL = result.profileImage.large
            case .failure(let error):
                completion(.failure(error))
                print("Ошибка при выполнении fetchProfileImageURLTask: \(error)")
            }
        }
        
        fetchProfileImageURLTask?.resume()
    }
}

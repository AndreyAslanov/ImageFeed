//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Андрей Асланов on 31.07.23.
//

import Foundation
import UIKit

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let description: String?
    let urls: UrlsResult
    let likedByUser: Bool             
    
    private enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case description
        case urls
        case likedByUser = "liked_by_user"
    }
}

struct UrlsResult: Decodable {
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let regularImageURL: String
    let smallImageURL: String
    var isLiked: Bool
    
    init(_ photoResult: PhotoResult, date: ISO8601DateFormatter) {
        self.id = photoResult.id
        self.size = CGSize(width: photoResult.width, height: photoResult.height)
        self.createdAt = date.date(from: photoResult.createdAt ?? "")
        self.welcomeDescription = photoResult.description
        self.thumbImageURL = photoResult.urls.thumb
        self.largeImageURL = photoResult.urls.full
        self.regularImageURL = photoResult.urls.regular
        self.smallImageURL = photoResult.urls.small
        self.isLiked = photoResult.likedByUser                    
    }
}

struct PhotoLike: Decodable {
    let photo: PhotoResult
}

final class ImagesListService {
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var currentTask: URLSessionTask?
    private let urlSession = URLSession.shared
    let dateFormatter = ISO8601DateFormatter()
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    static let shared = ImagesListService()
    
    private var page: Int = 1
  
// MARK: Response Photo Next Page
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard currentTask == nil else { return }
        
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        page = nextPage
        
        guard let authToken = OAuth2TokenStorage.shared.token else {
            return
        }
        
        if let authToken = OAuth2TokenStorage.shared.token {
            print("Токен на фотках: \(authToken)")
        } else {
            print ("Токен на фотки не пришел")
        }
        
        guard let request = makeRequest(authToken: authToken, page: nextPage) else {
            print("Запрос не удался")
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let photoResults):
                    if self.lastLoadedPage == nil {
                        self.lastLoadedPage = 1
                    } else {
                        self.lastLoadedPage! += 1
                    }
                    let newPhotos = photoResults.map { Photo ($0, date: self.dateFormatter) }
                    
                    if let httpResponse = (self.currentTask?.response as? HTTPURLResponse) {
                        print("Статус-код:", httpResponse.statusCode)
                    }
                                        
                    self.photos.append(contentsOf: newPhotos)
                    
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
                    
                case.failure(let error):
                    print("Ошибка запроса fetchPhotosNextPage:", error.localizedDescription)
                }
            }
            self.currentTask = nil
        }
        self.currentTask = task
        task.resume()
    }
    
// MARK: Response Change Like
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        if currentTask != nil {
            currentTask?.cancel()
        }
        guard let request = makeLikeRequest(photoId: photoId, isLike: isLike) else {
            return
        }
        let task = URLSession.shared.objectTask(for: request) { (result: Result<PhotoLike, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        let photo = self.photos[index]
                        let newPhotoResult = PhotoResult(id: photo.id,
                                                         createdAt: photo.createdAt?.description,
                                                         width: Int(photo.size.width),
                                                         height: Int(photo.size.height),
                                                         description: photo.welcomeDescription,
                                                         urls: UrlsResult(full: photo.largeImageURL,
                                                                          regular: photo.regularImageURL,
                                                                          small: photo.smallImageURL,
                                                                          thumb: photo.thumbImageURL),
                                                         likedByUser: !photo.isLiked)
                        let newPhoto = Photo(newPhotoResult, date: self.dateFormatter)
                        self.photos[index] = newPhoto
                        completion(.success(()))
                    }

                case .failure(let error):
                    assertionFailure("Ошибка при лайке: \(error)")
                }
            }
        }
        self.currentTask = task
        task.resume()
    }
        
// MARK: Requests
    private func makeRequest(authToken: String, page: Int) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://api.unsplash.com/photos") else {
            assertionFailure("Неправильный юрл")
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "10")
        ]
        guard let url = urlComponents.url else {
            assertionFailure("Ошибка создания юрл")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return request
        
    }
    
    private func makeLikeRequest(photoId: String, isLike: Bool) -> URLRequest? {
        let baseURL = "https://api.unsplash.com"
        let likeURL = "\(baseURL)/photos/\(photoId)/like"
        
        guard let url = URL(string: likeURL) else {
            assertionFailure("Ошибка создания URL для лайков")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        
        guard let authToken = OAuth2TokenStorage.shared.token else {
            print("Токен на лайках не найден")
            return nil
        }
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}



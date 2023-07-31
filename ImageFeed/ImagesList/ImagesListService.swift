//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Андрей Асланов on 31.07.23.
//

import Foundation
import UIKit

struct PhotoResult: Codable {
    let id: String
    let created_at: String
    let width: Int
    let height: Int
    let description: String?
    let urls: UrlsResult
}

struct UrlsResult: Codable {
    let raw: String
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
    let isLiked: Bool
}

final class ImagesListService {
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?

    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")

    func fetchPhotosNextPage() {
        guard lastLoadedPage == nil || !isFetching else {
            return // Если уже идет загрузка, ничего не делаем
        }
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        // Создаем URLRequest для получения JSON данных от Unsplash
        guard let url = URL(string: "https://api.unsplash.com/photos?page=\(nextPage)") else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self,
                    let data = data,
                    error == nil,
                    let photos = try? JSONDecoder().decode([PhotoResult].self, from: data) else {
                return
            }

            // Преобразуем массив PhotoResult в массив Photo
            let newPhotos = photos.map { photoResult in
                Photo(
                    id: photoResult.id,
                    size: CGSize(width: photoResult.width, height: photoResult.height),
                    createdAt: ISO8601DateFormatter().date(from: photoResult.created_at),
                    welcomeDescription: photoResult.description,
                    thumbImageURL: photoResult.urls.thumb,
                    largeImageURL: photoResult.urls.regular,
                    isLiked: false // Вы можете установить начальное состояние "понравилось" здесь
                )
            }

            DispatchQueue.main.async {
                // Добавляем новые фотографии в массив photos
                self.photos += newPhotos

                // Обновляем значение lastLoadedPage
                self.lastLoadedPage = nextPage

                // Публикуем уведомление, чтобы уведомить UI об изменениях
                NotificationCenter.default.post(name: ImagesListService.DidChangeNotification, object: nil)
            }
        }

        task.resume()
    }

    private var isFetching: Bool {
        return lastLoadedPage != nil
    }

    func tableView(
      _ tableView: UITableView,
      willDisplay cell: UITableViewCell,
      forRowAt indexPath: IndexPath
    ) {
        if indexPath.row + 1 == photos.count {
            fetchPhotosNextPage()
        }
    }
}

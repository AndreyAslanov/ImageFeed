//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Андрей Асланов on 14.08.23.
//

import UIKit
@testable import ImageFeed

final class ImageListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImageFeed.ImagesListViewPresenterProtocol?
    var photos: [ImageFeed.Photo]
    
    init(photos: [Photo]) {
        self.photos = photos
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.checkCompletedList(indexPath)
    }
    
    func changeLike() {
        presenter?.changeLike(photoId: "some", isLike: true)
        { [ weak self ] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func updateTableViewAnimated() {
    }
}

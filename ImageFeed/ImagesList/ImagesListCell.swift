//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Андрей Асланов on 31.05.23.
//

import UIKit
import Kingfisher

protocol ImagesListDelegate: AnyObject {
    func imagesListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListDelegate?
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    static let dateFormatterInstance: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    func setupCell(from photo: Photo) {
        
        let url = URL(string: photo.smallImageURL)
        cellImage.kf.indicatorType = .activity
        
        let placeholderImage = UIImage(named: "placeholderImage")
        cellImage.kf.setImage(with: url, placeholder: placeholderImage) { result in
        
            switch result {
            case .success(let image):
                self.cellImage.contentMode = .scaleAspectFill
                self.cellImage.image = image.image
            case .failure(let error):
                print("Ошибка загрузки картинки: \(error)")
                self.cellImage.image = UIImage(named: "placeholderImage")
            }
        }
        dateLabel.text = ImagesListCell.dateFormatterInstance.string(from: photo.createdAt ?? Date())
        setIsLiked(isLiked: photo.isLiked)
    }
    
    func setIsLiked(isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }
    
    @IBAction private func likeButtonClicked(_ sender: UIButton) {
        delegate?.imagesListCellDidTapLike(self)
    }
}


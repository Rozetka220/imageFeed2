//
//  ImagesListCell.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 21.03.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var cellLikeButton: UIButton!
    @IBOutlet weak var cellDataLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
        cellImageView.kf.cancelDownloadTask()
    }
}

//
//  ViewController.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 21.03.2023.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    private var imageListService = ImagesListService()
    
    private var imageListCell = ImagesListCell()
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private var imageListServiceObserver: NSObjectProtocol?
    
    @IBOutlet private var tableView: UITableView!
    
    @IBOutlet private weak var dataLabel: UILabel!
    
    private var photosMok: [String] = Array(0..<20).map{ "\($0)" }
    
    private var photos: [Photo] = []
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        imageListService.fetchPhotosNextPage()
        imageListServiceObserver = NotificationCenter.default.addObserver(forName: ImagesListService.DidChangeNotification, object: nil, queue: .main, using: { [weak self] _ in
            self?.updateTableViewAnimated()
        })
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController else {assertionFailure("Не сработал   segue при открытии картинки в одном окне. Возможно стоит перепроверить идентификатор segue и viewController для отображения картинки во весь экран"); return}
            let indexPath = sender as! IndexPath
            //let image = UIImage(named: photosName[indexPath.row])
            //viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        //        guard let image = UIImage(named: photosName[indexPath.row])  else {
        //            return
        //        }
        //        cell.cellImageView.contentMode = .scaleAspectFill
        //        cell.cellImageView.image = image
        //        cell.cellDataLabel.text = dateFormatter.string(from: Date())
        //        if (indexPath.row % 2 == 0){
        //            cell.cellLikeButton.setImage(UIImage(named: "likeActive"), for: .normal)
        //        } else {
        //            cell.cellLikeButton.setImage(UIImage(named: "likeNotActive"), for: .normal)
        //        }
        //юзать kingfisher
        let photoThumbUrl = URL(string:  photos[indexPath.row].thumbImageURL)
        let processor = RoundCornerImageProcessor(cornerRadius: 16)
        cell.cellImageView.contentMode = .scaleToFill
        cell.cellImageView.kf.indicatorType = .activity
        cell.cellImageView.kf.setImage(with: photoThumbUrl, placeholder: UIImage(named: "Stub"), options: [.processor(processor)]) { [weak self] _ in
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        cell.cellDataLabel.text = dateFormatter.string(from: Date())
        if (indexPath.row % 2 == 0){
            cell.cellLikeButton.setImage(UIImage(named: "likeActive"), for: .normal)
        } else {
            cell.cellLikeButton.setImage(UIImage(named: "likeNotActive"), for: .normal)
        }
        
     
        
    }
    
}

extension ImagesListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        guard let image = UIImage(named: photosMok[indexPath.row]) else {
//            return 0 }
//
//        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
//        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
//        let imageWidth = image.size.width
//        let scale = imageViewWidth / imageWidth
//        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
//        return cellHeight
//    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imageListService.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            print("Ошибка создания кастомной ячейки")
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
    
    private func updateTableViewAnimated(){
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

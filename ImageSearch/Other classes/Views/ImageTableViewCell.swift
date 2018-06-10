//
//  ImageTableViewCell.swift
//  ImageSearch
//
//  Created by Mike Haydan on 09/06/2018.
//  Copyright © 2018 Misha Apps. All rights reserved.
//

import UIKit

final class ImageTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet private weak var cellImageView: DownloaderImageView!
    @IBOutlet private weak var cellTitle: UILabel!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - LifeCycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImageView.cancelDownload()
        cellImageView.image = nil
    }
    
    // MARK: - Public
    
    func configureWith(model: ImageSearchModel, downloader: CacheGateway) {
        cellTitle.text = model.description
        
        activityIndicatorView.startAnimating()
        cellImageView.dwonloadImagefrom(url: model.imageUrl, downloader: downloader) { [weak self] in
            self?.activityIndicatorView.stopAnimating()
        }
    }
}

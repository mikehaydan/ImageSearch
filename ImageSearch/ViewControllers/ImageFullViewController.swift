//
//  ImageFullViewController.swift
//  ImageSearch
//
//  Created by Mike Haydan on 10/06/2018.
//  Copyright © 2018 Misha Apps. All rights reserved.
//

import UIKit

final class ImageFullViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    private var downloader: DownloaderGateway!
    private var downloadTask: URLSessionDataTask?
    
    var imageUrl: String!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareDownloader()
        downloadImage()
    }
    
    deinit {
        downloadTask?.cancel()
    }
    
    // MARK: - IBActions
    
    // MARK: - Private
    
    private func prepareDownloader() {
        downloader = DownloaderGatewayImplementation(apiClient: ApiClientImplementation.defaultConfiguration)
    }
    
    private func downloadImage() {
        activityIndicatorView.startAnimating()
        downloader.downloadImageBy(urlString: imageUrl, dataTaskHandler: { [weak self] (task) in
            self?.downloadTask = task
        }, completion: { [weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.activityIndicatorView.stopAnimating()
            switch result {
            case let .success(response):
                strongSelf.imageView.image = response
            case let .failure(error):
                strongSelf.alert(message: error.localizedDescription)
            }
        })
    }
}

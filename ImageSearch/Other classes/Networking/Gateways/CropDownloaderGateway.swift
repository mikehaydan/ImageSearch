//
//  CropDownloader.swift
//  ImageSearch
//
//  Created by Mike Haydan on 09/06/2018.
//  Copyright © 2018 Misha Apps. All rights reserved.
//

import UIKit

enum CropDownloaderGatewayConstants {
    static let cropIdentifier: String = "crop_"
}

protocol CropDownloaderGateway: DownloaderGateway {
    
}

final class CropDownloaderImplementation: DownloaderGatewayImplementation {
    
    // MARK: - Properties

    private let cropSize: CGSize
    private let cropSerivce: CropSerivce = CropSerivce()
    
    // MARK: - LifeCycle

    init(apiClient: ApiClient, cropSize: CGSize) {
        self.cropSize = cropSize
        
        super.init(apiClient: apiClient)
    }
    
    // MARK: - Public
    
    override func downloadImageBy(urlString: String, dataTaskHandler: ((URLSessionDataTask?) -> ())?, completion: @escaping ImageDownloadCompletion) {
        super.downloadImageBy(urlString: urlString, dataTaskHandler: dataTaskHandler, completion: { [weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case let .success(response):
                let image = strongSelf.cropSerivce.cropTo(image: response, to: strongSelf.cropSize)
                completion(.success(image))
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
    
    override func imageNameFrom(url: String) -> String? {
        if let name = super.imageNameFrom(url: url) {
            return CropDownloaderGatewayConstants.cropIdentifier + name
        } else {
            return nil
        }
    }
}

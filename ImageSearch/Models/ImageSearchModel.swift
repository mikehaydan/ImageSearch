//
//  ImageSearchModel.swift
//  ImageSearch
//
//  Created by Mike Haydan on 09/06/2018.
//  Copyright © 2018 Misha Apps. All rights reserved.
//

import UIKit

struct ImageSearchApiModel: InitializableCodable {
    
    let response: [SearchResponse]
    
    var searchModel: [ImageSearchModel] {
        let result = response.reduce([]) { (models, object) -> [ImageSearchModel] in
            let nextModels = object.photos?.compactMap({ ImageSearchModel(imageUrl: $0.originalSize.url, size: CGSize(width: $0.originalSize.width, height: $0.originalSize.height), description: $0.caption) }) ?? []
            return models + nextModels
        }
        return result
    }
    
    enum CodingKeys: String, CodingKey {
        case response
    }
}

struct SearchResponse: Codable {
    let photos: [Photo]?
    
    enum CodingKeys: String, CodingKey {
        case photos = "photos"
    }
}

struct Photo: Codable {
    let caption: String
    let originalSize: OriginalSize
    
    enum CodingKeys: String, CodingKey {
        case caption
        case originalSize = "original_size"
    }
}

struct OriginalSize: Codable {
    let url: String
    let width: Int
    let height: Int
}

struct ImageSearchModel {
    let imageUrl: String
    let size: CGSize
    let description: String
}

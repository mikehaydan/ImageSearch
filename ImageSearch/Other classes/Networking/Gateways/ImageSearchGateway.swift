//
//  ImageSearchGateway.swift
//  ImageSearch
//
//  Created by Mike Haydan on 09/06/2018.
//  Copyright © 2018 Misha Apps. All rights reserved.
//

import Foundation

typealias SearchCompleion = (Result<[ImageSearchModel]>) -> ()

protocol ImageSearchGateway {
    func searchImageWith(tag: String, completion: @escaping SearchCompleion)
}

final class ImageSearchGatewayImplementation: ImageSearchGateway {
    
    private enum Keys {
        static let tag: String = "tag"
        static let apiKey: String = "api_key"
    }
    
    // MARK: - Properties
    
    let apiClient: ApiClient
    
    // MARK: - LifeCycle
    
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    // MARK: - Public
    
    func searchImageWith(tag: String, completion: @escaping SearchCompleion) {
        let parameters: [String: String] = [Keys.tag: tag, Keys.apiKey: Constants.apiKey]
        let request = URLRequest.requestWithURL(path: Urls.searchImage, queryParameters: parameters)
        apiClient.execute(request: request) { (result: Result<ApiResponse<ImageSearchApiModel>>) in
            switch result {
            case let .success(response):
                let resultToBeReturned = response.entity.searchModel
                completion(.success(resultToBeReturned))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

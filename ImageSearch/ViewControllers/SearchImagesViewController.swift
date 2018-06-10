//
//  SearchImagesViewController.swift
//  ImageSearch
//
//  Created by Mike Haydan on 09/06/2018.
//  Copyright © 2018 Misha Apps. All rights reserved.
//

import UIKit

private enum SearchImagesViewControllerConstants {
    static let cellIdentifier: String = "ImageTableViewCell"
    static let fullImageSegue = "fullImageSegue"
}

final class SearchImagesViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var tableView: UITableView!
    
    private var searchGateway: ImageSearchGateway!
    private var downloader: CacheGateway!
    
    private var dataSource: [ImageSearchModel] = []
    private var imageUrl: String = ""
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareController()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == SearchImagesViewControllerConstants.fullImageSegue {
            let controller = segue.destination as! ImageFullViewController
            controller.imageUrl = imageUrl
        }
    }
    
    // MARK: - Private
    
    private func prepareController() {
        prepareNetwork()
    }
    
    private func prepareNetwork() {
        let apiClient = ApiClientImplementation.defaultConfiguration
        searchGateway = ImageSearchGatewayImplementation(apiClient: apiClient)
        let operationQueue = OperationQueue()
        let downloadClient = ApiClientImplementation(urlSessionConfiguration: .default, completionHandlerQueue: operationQueue)
        let imageDownloader = CropDownloaderImplementation(apiClient: downloadClient, cropSize: CGSize(width: 300, height: 300))
        self.downloader = CacheGatewayImplementation(downloader: imageDownloader)
    }
    
    private func clearTableView() {
        dataSource.removeAll()
        reloadTableViewAnimated()
    }
    
    private func reloadTableViewAnimated() {
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    // MARK: - Public
    
}


//MARK: - UITableViewDataSource

extension SearchImagesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchImagesViewControllerConstants.cellIdentifier, for: indexPath) as! ImageTableViewCell
        cell.configureWith(model: model, downloader: downloader)
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension SearchImagesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        imageUrl = dataSource[indexPath.row].imageUrl
        performSegue(withIdentifier: SearchImagesViewControllerConstants.fullImageSegue, sender: nil)
    }
}

// MARK: - UISearchBarDelegate

extension SearchImagesViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchBar.text else {
            return
        }
        clearTableView()
        downloader.cancelDownload()
        if !text.isEmpty {
            activityIndicatorView.startAnimating()
            searchGateway.searchImageWith(tag: text) { [weak self] (result) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.activityIndicatorView.stopAnimating()
                switch result {
                case let .success(response):
                    strongSelf.dataSource = response
                    strongSelf.reloadTableViewAnimated()
                case let .failure(error):
                    strongSelf.alert(message: error.localizedDescription)
                }
            }
        }
    }
}

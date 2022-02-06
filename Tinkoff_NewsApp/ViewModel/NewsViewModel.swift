//
//  NewsViewModel.swift
//  Tinkoff_NewsApp
//
//  Created by максим  кондратьев  on 06.02.2022.
//

import Foundation

class  NewsViewModel {
    
    private var newsArray =  [News]()
    private var networkService : NetworkManager!
    private var pageNumber: Int
    
    
    init(networkService : NetworkManager) {
        self.networkService = networkService
        self.pageNumber = 1
    }
    
    func fetchNews(pageNumber: Int , completion: @escaping(Result<[News]?,Error>) -> Void) {
        networkService.getNews(pageNumber: pageNumber) { [weak self] (result) in
            switch result {
            case .success(let data):
                if let data = data {
                    self?.newsArray = data
                    completion(.success(data))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
                           
        }
    }
}

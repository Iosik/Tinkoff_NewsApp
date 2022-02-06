//
//  NewsViewModel.swift
//  Tinkoff_NewsApp
//
//  Created by максим  кондратьев  on 06.02.2022.
//

import Foundation

class  NewsViewModel {
    
     var newsArray =  [News]()
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
    
    func savingDataFromWeb(pageNumber: Int, completion: @escaping (Error)->Void ) {
        fetchNews(pageNumber: pageNumber) { (result) in
            
            switch result {
            
            case .success(let decodedData):
                do {
                    // Create JSON Encoder
                    let encoder = JSONEncoder()
                    // Encode Note
                    let data = try encoder.encode(decodedData)

                    // Write/Set Data
                    UserDefaults.standard.removeObject(forKey: "news")
                    UserDefaults.standard.set(data, forKey: "news")
                }
                
                catch (let error){
                    completion(error)
                }
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func configureDataStore() {
        if let data = UserDefaults.standard.data(forKey: "news") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                // Decode Note
                //newsArray тип [News]
              newsArray = try decoder.decode([News].self, from: data)
              
            } catch {
                print("Unable to Decode Notes (\(error))")
            }
        }
    }
}

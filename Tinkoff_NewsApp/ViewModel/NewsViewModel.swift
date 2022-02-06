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
    var onUpdate: ()->Void = {}
    var onUpdateError: ()-> Void = {}
    
    
    init(networkService : NetworkManager) {
        self.networkService = networkService
     
    }
    
    func fetchNews(pageNumber: Int ,pageSize: Int, completion: @escaping(Result<[News]?,Error>) -> Void) {
        networkService.getNews(pageNumber: pageNumber, pageSize: pageSize) { [weak self] (result) in
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

    func pullToRefresh(completionHandler: @escaping (Result<[News], Error>)->Void) {
        
        networkService.getNews(pageNumber: 1, pageSize: 20) { [weak self] (result) in
            switch result {
            case .success(let data):
                if let decodedData = data {
                    self?.newsArray = decodedData
                    do {
                        // Create JSON Encoder
                        let encoder = JSONEncoder()
                        // Encode Note
                        let newdata = try encoder.encode(self?.newsArray)
                        
                        UserDefaults.standard.set(newdata, forKey: "news")
                    }
                    catch {
                    }
                    completionHandler(.success(decodedData))
                }
            case .failure(let error):
                completionHandler(.failure(error))
                
            }
        }
    }
        
    func configureDataStore(page:Int, completion: @escaping ([News])->Void) {
        if let data = UserDefaults.standard.data(forKey: "news") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                // Decode Note
                //newsArray тип [News]
              let objects = try decoder.decode([News].self, from: data)
              let first20 =  objects.enumerated().compactMap{ $0.offset < 20 ? $0.element : nil }
               
                completion(first20)
                
            } catch {
                print("Unable to Decode Notes (\(error))")
            }
        } else {
        
        fetchNews(pageNumber: page, pageSize: 20) { [weak self] (result) in
                switch result {
                case .success(let decodedData):
                    do {
                        // Create JSON Encoder
                        let encoder = JSONEncoder()
                        // Encode Note
                        let data = try encoder.encode(decodedData)
                        UserDefaults.standard.set(data, forKey: "news")
                       
                        self?.onUpdate()
                    }
                    catch {
                    }
                case .failure(_):
                  print("error")
                    self?.onUpdateError()
                }
        }
        }
        
    }

    
    func countingClicks(indexPath: IndexPath , viewModel: NewsViewModel) {

        var element = viewModel.newsArray[indexPath.row]
        print(element)

        if var count = element.counter {
            count += 1
            element.counter = count
        } else {
            element.counter = 1
        }
        viewModel.newsArray[indexPath.row] = element

        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(newsArray)
            UserDefaults.standard.set(data, forKey: "news")
        }
        catch {
            print(error)
        }
    }
 
        
  
    
    func loadMorePopularMovies(completion: @escaping (Result<[News],Error>)-> Void) {

        let pageNumber =  1
        let  pg = pageNumber + 1
        if newsArray.count <  37 {
            
        networkService.getNews(pageNumber: pg, pageSize: 20) { [weak self] (result) in
            
            switch result {
            case .success(let data):
                if let data = data {
                    self?.newsArray.append(contentsOf: data)
                    completion(.success(data))
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()
            // Encode Note
            let data = try encoder.encode(self.newsArray)
            
            UserDefaults.standard.set(data, forKey: "news")
        }
        catch {
            onUpdate()
        }
        }
        else {
            onUpdate()
        }
        
    }
        
}


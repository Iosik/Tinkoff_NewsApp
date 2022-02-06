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
//    func configureDataStore() {
//        if let data = UserDefaults.standard.data(forKey: "news") {
//            do {
//                // Create JSON Decoder
//                let decoder = JSONDecoder()
//                // Decode Note
//                //newsArray тип [News]
//              newsArray = try decoder.decode([News].self, from: data)
//
//            } catch {
//                print("Unable to Decode Notes (\(error))")
//            }
//        }
//
//    }
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
                    
                                        // Write/Set Data
                                        //UserDefaults.standard.removeObject(forKey: "news")
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
        
//        fetchNews(pageNumber: 1, pageSize: 5) { (result) in
//
//            switch result {
//
//            case .success(let decodedData):
//                do {
//                    // Create JSON Encoder
//                    let encoder = JSONEncoder()
//                    // Encode Note
//                    let data = try encoder.encode(decodedData)
//
//                    // Write/Set Data
//                    //UserDefaults.standard.removeObject(forKey: "news")
//                    UserDefaults.standard.set(data, forKey: "news")
//                }
//
//                catch {
//
//                }
//            case .failure(_):
//              print("error")
//            }
//        }
    
    
    }
    
    func configureDataStore(page:Int) {
        if let data = UserDefaults.standard.data(forKey: "news") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                // Decode Note
                //newsArray тип [News]
              let obj = try decoder.decode([News].self, from: data)
                newsArray.append(contentsOf: obj)
              
            } catch {
                print("Unable to Decode Notes (\(error))")
            }
        } else {
            fetchNews(pageNumber: page, pageSize: 20) { (result) in
                
                switch result {
                
                case .success(let decodedData):
                    do {
                        // Create JSON Encoder
                        let encoder = JSONEncoder()
                        // Encode Note
                        let data = try encoder.encode(decodedData)
                        // Write/Set Data
                        //UserDefaults.standard.removeObject(forKey: "news")
                        UserDefaults.standard.set(data, forKey: "news")
                    }
                    
                    catch {
                       
                    }
                case .failure(_):
                  print("error")
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
            // Create JSON Encoder
            let encoder = JSONEncoder()
            // Encode Note
            let data = try encoder.encode(viewModel.newsArray)
            
            // Write/Set Data
           // UserDefaults.standard.removeObject(forKey: "news")
            UserDefaults.standard.set(data, forKey: "news")
        }
        catch {
            print(error)
        }
    }
    
     func loadMorePopularMovies() {

        let pageNumber =  1
        let  pg = pageNumber + 1
        if newsArray.count <  37 {
            
        networkService.getNews(pageNumber: pg, pageSize: 20) { [weak self] (result) in
            
            switch result {
            case .success(let data):
                if let data = data {
                    self?.newsArray.append(contentsOf: data)
                }
            case .failure(_):
             print("e")
            }
        }
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()
            // Encode Note
            let data = try encoder.encode(self.newsArray)
            
            // Write/Set Data
           // UserDefaults.standard.removeObject(forKey: "news")
            UserDefaults.standard.set(data, forKey: "news")
        }
        catch {
            print(error)
        }
        }
     }
        

        
    
//    func savingDataFromWeb(pageNumber: Int, completion: @escaping (Error)->Void ) {
//        fetchNews(pageNumber: pageNumber) { (result) in
//
//            switch result {
//
//            case .success(let decodedData):
//                do {
//                    // Create JSON Encoder
//                    let encoder = JSONEncoder()
//                    // Encode Note
//                    let data = try encoder.encode(decodedData)
//
//                    // Write/Set Data
//                    UserDefaults.standard.removeObject(forKey: "news")
//                    UserDefaults.standard.set(data, forKey: "news")
//                }
//
//                catch (let error){
//                    completion(error)
//                }
//            case .failure(let error):
//                completion(error)
//            }
//        }
//    }
   
}

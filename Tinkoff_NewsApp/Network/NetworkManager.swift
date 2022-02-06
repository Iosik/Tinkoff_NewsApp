//
//  NetworkManager.swift
//  Tinkoff_NewsApp
//
//  Created by максим  кондратьев  on 06.02.2022.
//

import Foundation

class NetworkManager {
    
   
    
    private let baseUrl = "https://newsapi.org/v2/"
    private let headers = "top-headlines?country=us&page="
    private let apiKey = "a27c0a3bfdbf44ba8ec42398ed92f23f"
   // private let apiKey = "cc4981b5a8d143c4a13bf5dae5626be7" no more valid
   
    
    func getNews(pageNumber: Int,pageSize: Int, completion: @escaping (Result<[News]?,Error>)->Void) {
        let urlString = "\(baseUrl)\(headers)\(pageNumber)&pageSize=\(pageSize)&apiKey=\(apiKey)"
        guard  let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                    print(error.localizedDescription)
                }
               
            }
            guard let data = data  else {return}
            
            let decodedData = try? JSONDecoder().decode(JsonResponse.self, from: data)
            
            if let data = decodedData {
                DispatchQueue.main.async {
                    completion(.success(data.articles))
                }
            }
        }.resume()
    }
           
}

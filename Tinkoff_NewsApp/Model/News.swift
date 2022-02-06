//
//  News.swift
//  Tinkoff_NewsApp
//
//  Created by максим  кондратьев  on 06.02.2022.
//

import Foundation

struct News: Codable {
   
    let title: String?
    let description: String?
    let url: String?
    
    var counter : Int? = 0  // новое свойство
}

struct JsonResponse: Codable  {
    let status: String
    let totalResults: Int
    let articles: [News]
}


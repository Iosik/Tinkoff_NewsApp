//
//  ViewController.swift
//  Tinkoff_NewsApp
//
//  Created by максим  кондратьев  on 06.02.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var viewModel: NewsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = NewsViewModel(networkService: NetworkManager())
        viewModel?.savingDataFromWeb(pageNumber: 1, completion: { (error) in
           
                print(error.localizedDescription)
                //to show error handler
        })
        viewModel?.configureDataStore()
        print(viewModel!.newsArray )
        
}

}

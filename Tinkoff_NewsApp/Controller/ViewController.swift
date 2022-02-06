//
//  ViewController.swift
//  Tinkoff_NewsApp
//
//  Created by максим  кондратьев  on 06.02.2022.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    
    var viewModel: NewsViewModel!
    let tableView = UITableView()
    var spinner = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        viewModel = NewsViewModel(networkService: NetworkManager())

        viewModel?.configureDataStore(page: 1)
        
}
  
    
    let pulltoRefresh: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
            return refreshControl
        }()
        
    
        @objc private func refresh(sender: UIRefreshControl) {
            viewModel.pullToRefresh { [weak self] (result) in
                switch result {
                
                case .success(_):
                    DispatchQueue.main.async {
                        //indicator activivty stop
                        self?.tableView.reloadData()
                    }
                 
                case .failure(_):
                    print("ERRRROR")
                    DispatchQueue.main.async {
                        //indicator activivty stop
                        self?.tableView.reloadData()
                      
                    }
                }
            }
            sender.endRefreshing()
        }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.refreshControl = pulltoRefresh
        //spinner.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewsCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.newsArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! NewsCell
        //cell.textLabel?.text = newsArray[indexPath.row].title
        if let viewModel = viewModel {
            cell.configure(with: viewModel, index: indexPath)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        viewModel.countingClicks(indexPath: indexPath, viewModel: viewModel)

        tableView.reloadData()
        
        let  element = viewModel.newsArray[indexPath.row]
            
        guard  let urlToString = element.url else {
            return
        }
        guard  let url = URL(string: urlToString) else {
            return
        }
        
        let configuration = SFSafariViewController.Configuration()
        let safariVC = SFSafariViewController(url: url, configuration: configuration)
        safariVC.modalPresentationStyle = .formSheet
        //present(safariVC, animated: true, completion: nil)
     
           
    }
}

extension ViewController : UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        // Change 15.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 15.0 {
            viewModel.loadMorePopularMovies()
            self.tableView.reloadData()
        }
    }

}

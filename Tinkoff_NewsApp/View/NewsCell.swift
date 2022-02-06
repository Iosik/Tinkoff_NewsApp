//
//  NewsCell.swift
//  Tinkoff_NewsApp
//
//  Created by максим  кондратьев  on 06.02.2022.
//

import UIKit

class NewsCell: UITableViewCell {
    
    //var viewModel : NewsViewModel?
    
    lazy var newsTitle: UILabel  = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 3
        v.lineBreakMode = .byClipping
        v.font = .systemFont(ofSize: 20, weight: .medium)
        return v
    }()
    
    lazy var newsDescription: UILabel  = {
        let v = UILabel()
        v.numberOfLines = 2
        v.translatesAutoresizingMaskIntoConstraints = false
        v.lineBreakMode = .byClipping
        v.font = .systemFont(ofSize: 14, weight: .regular)
        v.textColor = .systemGray
        return v
    }()
    
    lazy var countLabel: UILabel =  {
         let v = UILabel()
         v.translatesAutoresizingMaskIntoConstraints = false
        v.font = .systemFont(ofSize: 14, weight: .medium)
         return v
     }()
    
    lazy var stackView: UIStackView = {
        let v = UIStackView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .vertical
        v.alignment = .leading
        v.distribution = .fill
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
        self.countLabel.isHidden = true
        }
    
    func configure(with viewModel: NewsViewModel , index: IndexPath) {
        let count = "\(index.row + 1). "
        newsTitle.text = count + viewModel.newsArray[index.row].title!
        newsDescription.text = viewModel.newsArray[index.row].description
        if let  counter = viewModel.newsArray[index.row].counter {
            self.countLabel.isHidden = false
            countLabel.text =  String(describing: counter)
        }
    
        }
    
    func configureUI() {
        stackView.addArrangedSubview(newsTitle)
        stackView.addArrangedSubview(newsDescription)
        stackView.addArrangedSubview(countLabel)
        
        contentView.addSubview(stackView)
        //contentView.addSubview(countLabel)
        selectionStyle = .none
        let padding :CGFloat = 16
        accessoryType = .disclosureIndicator
        
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
//            countLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: padding),
//            //countLabel.heightAnchor.constraint(equalToConstant: 70),
//
//            countLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
//            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
                                        ])
}
}

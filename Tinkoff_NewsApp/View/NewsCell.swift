//
//  NewsCell.swift
//  Tinkoff_NewsApp
//
//  Created by максим  кондратьев  on 06.02.2022.
//

import UIKit

class NewsCell: UITableViewCell {
    
    lazy var newsTitle: UILabel  = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 0
        v.lineBreakMode = .byClipping
        return v
    }()
    
    lazy var newsDescription: UILabel  = {
        let v = UILabel()
        v.numberOfLines = 0
        v.translatesAutoresizingMaskIntoConstraints = false
        v.lineBreakMode = .byClipping
        return v
    }()
    
    lazy var countLabel: UILabel =  {
         let v = UILabel()
         v.translatesAutoresizingMaskIntoConstraints = false
         return v
     }()
    
    lazy var stackView: UIStackView = {
        let v = UIStackView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .vertical
        v.distribution = .fillEqually
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
    
    func configureUI() {
        stackView.addArrangedSubview(newsTitle)
        stackView.addArrangedSubview(newsDescription)
        contentView.addSubview(stackView)
        contentView.addSubview(countLabel)
        selectionStyle = .none
        let padding :CGFloat = 16
        
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            stackView.trailingAnchor.constraint(equalTo: countLabel.leadingAnchor, constant: -padding),
            
            countLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 50),
            countLabel.widthAnchor.constraint(equalToConstant:  50),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
                                        ])
}
}

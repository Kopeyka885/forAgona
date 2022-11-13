//
//  FilmCollectionViewCell.swift
//  StartProject-ios
//
//  Created by Kamil Kadyrov on 01.10.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

class FilmCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = "FilmCollectionViewCell"
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = Asset.darkGray.color
        return view
    }()
    
    let ratingView = RatingView()
    
    let title: UILabel = {
        let view = UILabel()
        view.text = "-"
        view.font = FontFamily.SFProText.regular.font(size: 16)
        view.textAlignment = .left
        view.sizeToFit()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(ratingView)
        addSubview(title)
        
        imageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(50)
        }
        title.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom)
            make.height.equalTo(50)
        }
        ratingView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.top).offset(10)
            make.trailing.equalTo(imageView.snp.trailing).inset(10)
            make.width.equalTo(25)
            make.height.equalTo(15)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}

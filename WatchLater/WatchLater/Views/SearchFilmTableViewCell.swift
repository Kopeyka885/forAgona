//
//  SearchFilmTableViewCell.swift
//  StartProject-ios
//
//  Created by Камиль Кадыров on 30.10.2022.
//

import UIKit

class SearchFilmTableViewCell: UITableViewCell {

    static let reuseID = "SearchFilmTableViewCell"
    
    let image: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = Asset.darkGray.color
        return view
    }()
    
    let title: UILabel = {
        let view = UILabel()
        view.text = "-"
        view.font = FontFamily.SFProText.regular.font(size: 16)
        view.textAlignment = .left
        view.sizeToFit()
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(image)
        addSubview(title)
        
        image.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(50)
        }
        title.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(image.snp.bottom)
            make.height.equalTo(50)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

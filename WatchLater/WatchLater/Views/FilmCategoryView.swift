//
//  FilmCategoryView.swift
//  StartProject-ios
//
//  Created by Камиль Кадыров on 22.10.2022.
//

import UIKit

class FilmCategoryView: UIView {
    private let label: UILabel = {
        let view = UILabel()
        view.font = FontFamily.SFProDisplay.bold.font(size: 31)
        view.textAlignment = .left
        return view
    }()
    
    let allButton: UIButton = {
        let button = UIButton()
        button.setTitle(Text.Common.all, for: .normal)
        button.setTitleColor(Asset.agonaBlue.color, for: .normal)
        button.titleLabel?.font = FontFamily.SFProText.regular.font(size: 20)
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    var collectionView: SearchFilmsCollectionView!
    
    init(categoryName: String, collectionView: SearchFilmsCollectionView) {
        super.init(frame: .zero)
        self.collectionView = collectionView
        label.text = categoryName
        
        addSubview(label)
        addSubview(allButton)
        addSubview(collectionView)
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        allButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(Grid.horizontalInset)
            make.height.equalTo(50)
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(Grid.verticalOffset_s)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(200)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

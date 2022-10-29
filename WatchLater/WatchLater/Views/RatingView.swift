//
//  RatingView.swift
//  StartProject-ios
//
//  Created by Kamil Kadyrov on 02.10.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

class RatingView: UIView {
    
    let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 7
        view.layer.borderColor = Asset.agonaBlue.color.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "0.0"
        label.textColor = Asset.agonaBlue.color
        label.font = FontFamily.SFProText.bold.font(size: 10)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(mainView)
        addSubview(label)
        
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

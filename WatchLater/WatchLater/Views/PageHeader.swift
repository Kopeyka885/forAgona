//
//  PageHeader.swift
//  StartProject-ios
//
//  Created by Камиль Кадыров on 20.10.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

class PageHeader: UIView {
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = FontFamily.SFProDisplay.bold.font(size: 35)
        label.textAlignment = .left
        return label
    }()
    
    private let topBorder: UIView = {
        let lineView = UIView()
        lineView.layer.borderWidth = 2
        lineView.layer.borderColor = UIColor.lightGray.cgColor
        return lineView
    }()
    
    init(text: String) {
        super.init(frame: .zero)
        label.text = text
        addSubview(label)
        addSubview(topBorder)
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(20)
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        topBorder.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.height.equalTo(1)
            make.centerX.equalToSuperview()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

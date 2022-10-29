//
//  BottomBorderedTextFieldView.swift
//  StartProject-ios
//
//  Created by Kamil Kadyrov on 11.08.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

class BottomBorderedTextFieldView: UIView {
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.textAlignment = .center
        textField.clearButtonMode = .always
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let bottomBorder: UIView = {
        let lineView = UIView()
        lineView.layer.borderWidth = 2
        lineView.layer.borderColor = UIColor.lightGray.cgColor
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textField)
        addSubview(bottomBorder)
        
        textField.snp.makeConstraints { make in make.leading.trailing.centerY.equalToSuperview() }
        bottomBorder.snp.makeConstraints { make in
            make.leading.trailing.bottom.width.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

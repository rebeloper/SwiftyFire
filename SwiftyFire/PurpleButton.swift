//
//  PurpleButton.swift
//  SwiftyFire
//
//  Created by Alex Nagy on 15/05/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import UIKit

class PurpleButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(title: String) {
        super.init(frame: .zero)
        backgroundColor = .purple
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

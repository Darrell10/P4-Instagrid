//
//  addPhotoButton.swift
//  Instagrid
//
//  Created by Frederick Port on 21/08/2019.
//  Copyright © 2019 StudiOS 21. All rights reserved.
//

import UIKit

class addPhotoButton: UIButton {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
        }
        
        func setup() {
            let image = UIImage(named: "Plus.png")
            backgroundColor = .white
            imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
            setImage(image, for: UIControl.State.normal)
        }
        
}

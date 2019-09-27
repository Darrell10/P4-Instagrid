//
//  ArrowSwipe.swift
//  P4 Instagrid
//
//  Created by Frederick Port on 22/09/2019.
//  Copyright © 2019 StudiOS 21. All rights reserved.
//

import UIKit

class ArrowSwipe: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        image = UIImage(named:"Arrow Up.png")
    }

}

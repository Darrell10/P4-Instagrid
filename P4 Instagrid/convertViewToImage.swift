//
//  convertViewToImage.swift
//  P4 Instagrid
//
//  Created by Frederick Port on 01/09/2019.
//  Copyright © 2019 StudiOS 21. All rights reserved.
//

import UIKit

class convertViewToImage: UIImage {
    static func convert(_ view: UIView, defaultImage: UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0)
        defer { UIGraphicsEndImageContext() }
        view.snapshotView(afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext() ?? defaultImage
    }
}

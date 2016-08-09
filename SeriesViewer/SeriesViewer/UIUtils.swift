//
//  UIUtils.swift
//  SeriesViewer
//
//  Created by Victoria Denisyuk on 8/9/16.
//  Copyright © 2016 Victoria Denisyuk. All rights reserved.
//

import UIKit

@IBDesignable class RoundedView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
}

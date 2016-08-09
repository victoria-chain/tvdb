//
//  SeriesCell.swift
//  SeriesViewer
//
//  Created by Victoria Denisyuk on 8/8/16.
//  Copyright © 2016 Victoria Denisyuk. All rights reserved.
//

import UIKit

class SeriesCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func prepareForReuse() {
        imageView.image = UIImage(named: "ic_tv")
    }
}

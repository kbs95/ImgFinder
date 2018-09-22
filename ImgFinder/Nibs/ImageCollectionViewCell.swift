//
//  ImageCollectionViewCell.swift
//  ImgFinder
//
//  Created by Karanbir Singh on 21/09/18.
//  Copyright © 2018 Abcplusd. All rights reserved.
//

import UIKit
import SDWebImage
import FLAnimatedImage

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: FLAnimatedImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 10
        backgroundColor = .white
        imageView.sd_setIndicatorStyle(.gray)
        imageView.clipsToBounds = true
    }

}

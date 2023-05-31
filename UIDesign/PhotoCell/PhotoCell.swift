//
//  PhotoCell.swift
//  UIDesign
//
//  Created by Htet Myat Tun on 31/05/2023.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func assignImage(img: String) {
        self.image.image = UIImage(named: img)
    }
}

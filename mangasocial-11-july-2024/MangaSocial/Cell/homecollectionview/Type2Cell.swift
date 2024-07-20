//
//  ItemCell.swift
//  MangaSocial
//
//  Created by ATULA on 19/01/2024.
//

import UIKit

class Type2Cell: UICollectionViewCell {
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var chapter: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        image.layer.cornerRadius = 8
        releaseDate.layer.masksToBounds = true
        releaseDate.layer.borderWidth = 0.4
        releaseDate.layer.cornerRadius = 8
    }

}

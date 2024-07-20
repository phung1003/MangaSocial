//
//  Type1Cell.swift
//  MangaSocial
//
//  Created by ATULA on 18/07/2024.
//

import UIKit

class Type1Cell: UICollectionViewCell {

    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var chapter: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        image.layer.cornerRadius = 8

        // Initialization code
    }

}

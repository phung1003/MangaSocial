//
//  homeCell.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 06/03/2023.
//

import UIKit

class homeCell: UICollectionViewCell {
    
    @IBOutlet weak var image:UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var chapterView:UIView!
    @IBOutlet weak var chapter: UILabel!
    @IBOutlet weak var date : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

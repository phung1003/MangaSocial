//
//  genresTitleCell.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 12/03/2023.
//

import UIKit

class genresTitleCell: UICollectionViewCell {
    @IBOutlet weak var titleLb:UILabel!
    var handler : (()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func onClose(_ sender: UIButton){
        handler?()
    }

}

//
//  headerOffReadMangaCell.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 20/03/2023.
//

import UIKit

class headerOffReadMangaCell: UICollectionViewCell {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var mangaName: UILabel!
    var backHandler : (()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func didTapBack(_ sender: UIButton){
        backHandler?()
    }

}

//
//  mangaCell.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 07/03/2023.
//

import UIKit

class mangaCell: UICollectionViewCell {
    
    @IBOutlet weak var image:UIImageView!
    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var chapterView:UIView!
    @IBOutlet weak var chapter:UILabel!
    @IBOutlet weak var timeLb:UILabel!
    @IBOutlet weak var newImage:UIImageView!
    @IBOutlet weak var bookmarkImage:UIImageView!
    
    @IBOutlet weak var star1:UIImageView!
    @IBOutlet weak var star2:UIImageView!
    @IBOutlet weak var star3:UIImageView!
    @IBOutlet weak var star4:UIImageView!
    @IBOutlet weak var star5:UIImageView!
    
    var handler : (()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func starRating(rating: Double){
        if rating >= 1.0{
            star1.image = UIImage(named: "star")
        }
        if rating >= 2.0{
            star2.image = UIImage(named: "star")
        }
        if rating >= 3.0{
            star3.image = UIImage(named: "star")
        }
        if rating >= 4.0 {
            star4.image = UIImage(named: "star")
        }
        if rating >= 5.0 {
            star5.image = UIImage(named: "star")
        }
    }
}

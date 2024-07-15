//
//  mpCell.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 06/03/2023.
//

import UIKit

class mpCell: UICollectionViewCell {
    @IBOutlet weak var image:UIImageView!
    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var ratingNum: UILabel!
    @IBOutlet weak var chapter: UILabel!
    @IBOutlet weak var readNowBtn: UIButton!
    
    @IBOutlet weak var star1:UIImageView!
    @IBOutlet weak var star2:UIImageView!
    @IBOutlet weak var star3:UIImageView!
    @IBOutlet weak var star4:UIImageView!
    @IBOutlet weak var star5:UIImageView!
    
    var handler : (()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        if rating > 3.3 && rating < 3.7{
            star4.image = UIImage(named: "rating")
        }
        else if rating >= 3.7 {
            star4.image = UIImage(named: "star")
        }
        
        if rating > 4.3 && rating < 4.7 {
            star5.image = UIImage(named: "rating")
        }
        else if rating >= 4.7 {
            star5.image = UIImage(named: "star")
        }
    }
    
    @IBAction func didTapReadNow(_ sender: UIButton){
        handler?()
    }

}

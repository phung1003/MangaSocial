//
//  genresCell.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 07/03/2023.
//

import UIKit

class genresCell: UICollectionViewCell {
    
    @IBOutlet weak var genresName:UILabel!
    @IBOutlet weak var genreImg:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
   
//    var once = true
//
//    override func layoutSubviews() {
//       super.layoutSubviews()
//        if once {
//            setGradientBackground(colorTop: .blue, colorMiddle: .purple, colorBottom: .red)
//            once = false
//        }
//     }
//
//    override func draw(_ rect: CGRect) { //Your code should go here.
//        super.draw(rect)
//        self.layer.cornerRadius = self.frame.size.width / 2
//    }
//    
//    func setGradientBackground(colorTop: UIColor, colorMiddle: UIColor ,colorBottom: UIColor){
//            let gradientLayer = CAGradientLayer()
//            gradientLayer.colors = [colorBottom.cgColor, colorMiddle ,colorTop.cgColor]
//            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
//            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
//            gradientLayer.locations = [0, 1]
//            gradientLayer.frame = bounds
//            layer.insertSublayer(gradientLayer, at: 0)
//    }

}

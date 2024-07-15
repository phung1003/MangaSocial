//
//  CommentCell.swift
//  MangaSocial
//
//  Created by ATULA on 23/01/2024.
//

import UIKit

class CommentCell: UICollectionViewCell {
//    override func layoutSubviews() {
//        // Shadow
//        self.layer.cornerRadius = 5
//        self.layer.shadowOpacity = 1
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowPath = UIBezierPath(
//            roundedRect: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height),
//            cornerRadius: 5).cgPath
//        self.layer.shadowOffset = CGSize(width: 0, height: 5)
//        self.layer.shadowOpacity = 0.5
//        self.backgroundColor = UIColor.white
//    }
    

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var whiteLine: UIImageView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!

    var replyHandler : (()->())?
    var deleteHandler: (()->())?
    var editHandler:(() -> ())?
    override func awakeFromNib() {
        super.awakeFromNib()
        avatar.makeRounded()

        // Initialization code
    }
    
    @IBAction func deleteComment() {
        deleteHandler?()
    }
    
    @IBAction func rep() {
        replyHandler?()
    }
    
    @IBAction func editComment() {
        editHandler?()
    }

}


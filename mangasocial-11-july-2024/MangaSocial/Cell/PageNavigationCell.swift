//
//  PageNavigationCell.swift
//  MangaSocial
//
//  Created by ATULA on 22/07/2024.
//

import UIKit

class PageNavigationCell: UICollectionViewCell {

    @IBOutlet weak var pageLb: UILabel!
    @IBOutlet weak var preBut: UIButton!
    @IBOutlet weak var nexBut: UIButton!
    @IBOutlet weak var pageView: UIView!
    
    var preHandler : (()->())?
    var nextHandler : (()->())?
    var showAllHandler : (()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.showAll))
        pageView.addGestureRecognizer(tap)
        pageView.layer.cornerRadius = 10.0
    }
    
    @IBAction func onPre(_ sender: UIButton) {
        preHandler?()
    }
    
    @IBAction func onNext(_ sender: UIButton) {
        nextHandler?()
    }
    
    @IBAction func showAllBTN() {
        showAllHandler?()
    }
    
    @objc func showAll() {
        showAllHandler?()
    }

}

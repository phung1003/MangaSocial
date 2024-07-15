//
//  headerReadMangaCell.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 20/03/2023.
//

import UIKit

class headerReadMangaCell: UICollectionViewCell {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var mangaName: UILabel!
    @IBOutlet weak var chapterLb: UILabel!
    @IBOutlet weak var chapterLb2: UILabel!
    @IBOutlet weak var preBut: UIButton!
    @IBOutlet weak var nexBut: UIButton!
    @IBOutlet weak var chapterView: UIView!
    
    var backHandler : (()->())?
    var searchHandler : (()->())?
    var saveHandler : (()->())?
    var profileHandler : (()->())?
    var preHandler : (()->())?
    var nextHandler : (()->())?
    var showAllHandler : (()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.showAllChap))
        chapterView.addGestureRecognizer(tap)
    }
    
    @IBAction func didTapBack(_ sender: UIButton) {
        backHandler?()
    }
    
    @IBAction func didTapSearch(_ sender: UIButton) {
        searchHandler?()
    }
    
    @IBAction func didTapSave(_ sender: UIButton) {
        saveHandler?()
    }
    
    @IBAction func didTapProfile(_ sender: UIButton) {
        profileHandler?()
    }
    
    @IBAction func onPreChap(_ sender: UIButton) {
        preHandler?()
    }
    
    @IBAction func onNextChap(_ sender: UIButton) {
        nextHandler?()
    }
    
    @IBAction func showAllChapBTN() {
        showAllHandler?()
    }
    
    @objc func showAllChap() {
        showAllHandler?()
    }

}

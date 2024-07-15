//
//  savedCell.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 16/03/2023.
//

import UIKit

class savedCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mangaName : UILabel!
    @IBOutlet weak var chapterCLV: UICollectionView!
    var competitionHandler : ((Int)->())?
    var deleteHander: (()->())?
    
    var listChapterSaved = [SaveChapterModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chapterCLV.register(UINib(nibName: "chapterCell", bundle: nil), forCellWithReuseIdentifier: "chapterCell")
    }
    
    @IBAction func onTapDelete(_ sender: UIButton){
        deleteHander?()
    }
}

extension savedCell : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listChapterSaved.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chapterCell", for: indexPath) as! chapterCell
        cell.chapterLb.text = listChapterSaved[indexPath.row].chapter
        cell.time.text = ""
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        competitionHandler?(indexPath.row)
    }
}

extension savedCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: chapterCLV.bounds.width - 20, height: 23)
    }
}

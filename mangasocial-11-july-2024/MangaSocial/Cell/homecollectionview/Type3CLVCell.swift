//
//  HomeRecentCLVCell.swift
//  MangaSocialApp
//
//  Created by khongtinduoc on 1/5/24.
//

import UIKit

class Type3CLVCell: TypeCell {

    @IBOutlet weak var moreBTN: UIButton!
    
    @IBAction func didTapMore() {
        print("Yes")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        homeCLV.register(UINib(nibName: "Type3Cell", bundle: nil), forCellWithReuseIdentifier: "Type3Cell")
        homeCLV.backgroundColor = UIColor.clear
    }

}
extension Type3CLVCell : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Type3Cell", for: indexPath) as! Type3Cell
        cell.backgroundColor = colorFromHex(hex: "#EB991D")
        cell.releaseDate.text = "\(data[indexPath.row].time_release)"
        cell.name.text = data[indexPath.row].title_manga
        cell.chapter.text = "\(data[indexPath.row].chapter_new)"
        cell.layer.cornerRadius = 10.0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let parent = self.parentViewController as? HomeViewController{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DetailMangaVC") as! DetailMangaVC
            var name = data[indexPath.row].url_manga
            if let url = URL(string: name) {
                vc.linkManga += url.lastPathComponent
            }
            vc.linkManga = name
            vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            parent.present(vc, animated: true, completion: nil)
        }
    }
}

extension Type3CLVCell : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 5
        }
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: collectionView.frame.width, height: 50)
        }
        
        return CGSize(width:collectionView.frame.width, height: 50)
    }
}





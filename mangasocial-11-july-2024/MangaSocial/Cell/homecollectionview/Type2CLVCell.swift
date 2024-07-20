//
//  HomeRecentCLVCell.swift
//  MangaSocialApp
//
//  Created by khongtinduoc on 1/5/24.
//

import UIKit

class Type2CLVCell: TypeCell {
   

    override func awakeFromNib() {
        super.awakeFromNib()
        homeCLV.register(UINib(nibName: "Type2Cell", bundle: nil), forCellWithReuseIdentifier: "Type2Cell")
        homeCLV.backgroundColor = UIColor.clear
    }

}
extension Type2CLVCell : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Type2Cell", for: indexPath) as! Type2Cell
        cell.releaseDate.text = "Update: \(data[indexPath.row].time_release)"
        cell.rate.text = data[indexPath.row].rate
        cell.name.text = data[indexPath.row].title_manga
        cell.chapter.text = "Chapter: \(data[indexPath.row].chapter_new)"
        cell.image.kf.setImage(with: URL(string: data[indexPath.row].image_poster_link_goc))
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

extension Type2CLVCell : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 10
        }
        return 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: 119, height: 227)
        }
        
        return CGSize(width:119, height: 227)
    }
}





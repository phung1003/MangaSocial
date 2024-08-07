//
//  HomeRecentCLVCell.swift
//  MangaSocialApp
//
//  Created by khongtinduoc on 1/5/24.
//

import UIKit

class HomeNewReleaseCell: UICollectionViewCell {
    var homeData:HomeMangaSocialModel = HomeMangaSocialModel()
    @IBOutlet weak var homeCLV:UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        homeCLV.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
        homeCLV.backgroundColor = UIColor.clear
    }

}
extension HomeNewReleaseCell : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeData.listNewRelease.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
        cell.releaseDate.text = "Update: \(homeData.listNewRelease[indexPath.row].time_release)"
        cell.rate.text = homeData.listNewRelease[indexPath.row].rate
        cell.name.text = homeData.listNewRelease[indexPath.row].title_manga
        cell.chapter.text = "Chapter: \(homeData.listNewRelease[indexPath.row].chapter_new)"
        cell.image.kf.setImage(with: URL(string: homeData.listNewRelease[indexPath.row].image_poster_link_goc), placeholder: UIImage(named: "default"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let parent = self.parentViewController as? HomeViewController{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DetailMangaVC") as! DetailMangaVC
            var name = homeData.listNewRelease[indexPath.row].url_manga
            if let url = URL(string: name) {
                vc.linkManga += url.lastPathComponent
            }
            vc.linkManga = name
            vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            parent.present(vc, animated: true, completion: nil)
        }
    }
}

extension HomeNewReleaseCell : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 10
        }
        return 24
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





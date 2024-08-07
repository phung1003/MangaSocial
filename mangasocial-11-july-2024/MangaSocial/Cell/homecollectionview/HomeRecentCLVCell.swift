//
//  HomeRecentCLVCell.swift
//  MangaSocialApp
//
//  Created by khongtinduoc on 1/7/24.
//

import UIKit

class HomeRecentCLVCell: UICollectionViewCell {

    var homeData:HomeMangaSocialModel = HomeMangaSocialModel()
    @IBOutlet weak var homeCLV:UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        homeCLV.register(UINib(nibName: "RecentCell", bundle: nil), forCellWithReuseIdentifier: "RecentCell")
        homeCLV.backgroundColor = UIColor.clear
    }

}
extension HomeRecentCLVCell : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeData.listRecent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentCell", for: indexPath) as! RecentCell
        cell.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        cell.layer.cornerRadius = 16
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        
     
        

        
        cell.name.text = homeData.listRecent[indexPath.row].title_manga
        cell.chapter.text = "Chapter: \(homeData.listRecent[indexPath.row].chapter_new)"
        cell.genre.text =  "Genre: \(homeData.listRecent[indexPath.row].categories)"
        cell.author.text = "Author: \(homeData.listRecent[indexPath.row].author)"
       
        cell.image.kf.setImage(with: URL(string:  homeData.listRecent[indexPath.row].image_poster_link_goc), placeholder: UIImage(named: "default"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let parent = self.parentViewController as? HomeViewController{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DetailMangaVC") as! DetailMangaVC
            var name = homeData.listRecent[indexPath.row].url_manga
            if let url = URL(string: name) {
                vc.linkManga += url.lastPathComponent
            }
            vc.linkManga = name
            
            vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            parent.present(vc, animated: true, completion: nil)
        }
    }
}

extension HomeRecentCLVCell : UICollectionViewDelegateFlowLayout{
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
            return CGSize(width: collectionView.frame.width/4 , height: collectionView.frame.height)
        }
        return CGSize(width: 188, height: 240)
    }
}

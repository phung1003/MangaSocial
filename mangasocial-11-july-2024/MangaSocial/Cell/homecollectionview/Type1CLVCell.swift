//
//  HomeRecommendedCLVCell.swift
//  MangaSocialApp
//
//  Created by khongtinduoc on 1/6/24.
//

import UIKit

class Type1CLVCell: TypeCell {

    @IBOutlet weak var moreBTN: UIButton!
    
    @IBAction func didTapMore() {
        print("Yes")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        homeCLV.register(UINib(nibName: "Type1Cell", bundle: nil), forCellWithReuseIdentifier: "Type1Cell")
        homeCLV.backgroundColor = UIColor.clear
    }

}
extension Type1CLVCell : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Type1Cell", for: indexPath) as! Type1Cell
        cell.releaseDate.text = data[indexPath.row].time_release
        cell.name.text = data[indexPath.row].title_manga
        cell.chapter.text = "Chapter: \(data[indexPath.row].chapter_new)"
        cell.image.kf.setImage(with: URL(string: data[indexPath.row].image_poster_link_goc))
        cell.detail.text = data[indexPath.row].description_manga
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

extension Type1CLVCell : UICollectionViewDelegateFlowLayout{
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
            return CGSize(width: homeCLV.frame.width / 2 - 5 , height: 175)
        }
        
        return CGSize(width:homeCLV.frame.width - 5, height: 175)
    }
}



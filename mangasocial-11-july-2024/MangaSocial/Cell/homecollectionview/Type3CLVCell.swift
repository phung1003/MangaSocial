//
//  HomeRecentCLVCell.swift
//  MangaSocialApp
//
//  Created by khongtinduoc on 1/5/24.
//

import UIKit

class Type3CLVCell: TypeCell {

    @IBOutlet weak var moreBTN: UIButton!
    
    
    fileprivate func getType(_ parent: HomeViewController) -> String {
        var type: String = ""
        if data == parent.homeData.listTop15 {
            type = "best_15_comics_week"
        } else if data == parent.homeData.listRecent {
            type = "recent_comics"
        } else if data == parent.homeData.listCooming {
            type = "cooming_soon_comics"
        } else if data == parent.homeData.listNewRelease {
            type = "new_release_comics"
        } else if data == parent.homeData.listRecommended {
            type = "recommended_comics"
        } else if data == parent.homeData.listComedy {
            type = "comedy_comics"
        } else if data == parent.homeData.listFree {
            type = "free_comics"
        } else if data == parent.homeData.listRankMonth {
            type = "rank_manga_month"
        } else if data == parent.homeData.listRankWeek {
            type = "rank_manga_week"
        }
        return type
    }
    
    @IBAction func didTapMore() {
        print("Yes")
        if let parent = self.parentViewController as? HomeViewController{
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AllMangaVC") as! AllMangaVC
            vc.titleText = title.text!
            vc.dataType = getType(parent)
            vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            parent.present(vc, animated: true, completion: nil)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        moreBTN.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        moreBTN.layer.cornerRadius = 8
        moreBTN.layer.borderWidth = 1
        moreBTN.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        moreBTN.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)

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





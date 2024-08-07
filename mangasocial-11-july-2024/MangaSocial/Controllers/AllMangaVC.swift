//
//  AllMangaVC.swift
//  MangaSocial
//
//  Created by ATULA on 22/07/2024.
//

import UIKit
import JGProgressHUD
import Firebase
class AllMangaVC: UIViewController {
    
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var allMangaCLV: UICollectionView!
    
    var titleText: String = ""
    var data = MangaByTypeModel()
    var dataType: String = ""
    var curPage = 1
    
    var screenEnterTime: Date?

    let hud = JGProgressHUD()

    
    func viewConfig() {
        titleLB.text = titleText
        setGradientBackground()
        self.hud.style = .dark
        self.hud.textLabel.text = "Loading"
        
    }
    
    func setGradientBackground() {

        let colorTop =  UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        let colorMid = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        let colorBottom = UIColor(red: 0, green: 0, blue: 0, alpha: 0.68).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorMid,colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func fetchData(page: Int) {
        hud.show(in: self.view)
        APIService.shared.getHomeByType(dataType, page) { [self] response, error in
            hud.dismiss()
            if let listData = response {
                data = listData
                allMangaCLV.reloadData()
            }
        }
    }
    
    
    @IBAction func didTapBack(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [AnalyticsParameterScreenName: "AllMangaVC"])
        screenEnterTime = Date()

        allMangaCLV.register(UINib(nibName: "Type1Cell", bundle: nil), forCellWithReuseIdentifier: "Type1Cell")
        allMangaCLV.register(UINib(nibName: "PageNavigationCell", bundle: nil), forCellWithReuseIdentifier: "PageNavigationCell")

        viewConfig()
        fetchData(page: curPage)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsLogTimeUsing(screen: "AllMangaVC", enterTime: screenEnterTime)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }

    

}

extension AllMangaVC : UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return data.list_manga.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageNavigationCell", for: indexPath) as! PageNavigationCell
            cell.nextHandler = { [self] in
                if curPage == data.total_page {
                    showAlert(title: "Error", message: "This is the last page")
                } else {
                    fetchData(page: curPage+1)
                    curPage = curPage+1
                    cell.pageLb.text = "Page \(curPage)"

                }
            }
            
            cell.preHandler = { [self] in
                if curPage == 1 {
                    showAlert(title: "Error", message: "This is the last page")
                } else {
                    fetchData(page: curPage-1)
                    curPage = curPage-1
                    cell.pageLb.text = "Page \(curPage)"

                }
            }
            
            cell.showAllHandler = { [self] in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupPageVC") as! PopupPageVC
                vc.modalPresentationStyle = .overFullScreen
                vc.maxPage = data.total_page
                vc.appear(sender: self)
                vc.callBack = { [self]
                    index in
                    fetchData(page: index)
                    curPage = index
                    cell.pageLb.text = "Page \(curPage)"

                }
            }
            return cell
        }
        
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Type1Cell", for: indexPath) as! Type1Cell
            cell.releaseDate.text = data.list_manga[indexPath.row].time_release
            cell.name.text = data.list_manga[indexPath.row].title_manga
            cell.chapter.text = "Chapter: \(data.list_manga[indexPath.row].chapter_new)"
            cell.image.kf.setImage(with: URL(string: data.list_manga[indexPath.row].image_poster_link_goc), placeholder: UIImage(named: "default"))
            cell.detail.text = data.list_manga[indexPath.row].description_manga
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DetailMangaVC") as! DetailMangaVC
            var name = data.list_manga[indexPath.row].url_manga
            if let url = URL(string: name) {
                vc.linkManga += url.lastPathComponent
                
            }
            vc.linkManga = name
            vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}

extension AllMangaVC : UICollectionViewDelegateFlowLayout{
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
        if indexPath.section == 1 {
            return CGSize(width: collectionView.frame.width, height: 80)
        }
        return CGSize(width: collectionView.frame.width  , height: 175)
        
    }
}



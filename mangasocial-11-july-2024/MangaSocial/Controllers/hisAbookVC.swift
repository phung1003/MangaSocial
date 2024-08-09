//
//  hisAbookVC.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 07/03/2023.
//

import UIKit
import RealmSwift
import GoogleMobileAds
import Firebase


protocol ContainerToMaster {
    func changeTab(text:String)
}

class hisAbookVC: UIViewController, GADFullScreenContentDelegate {
    var interstitial: GADInterstitialAd?
    
    var containerToMaster:ContainerToMaster?
    
    @IBOutlet weak var hisAbookCLV:UICollectionView!
    var type = ""
//    var historyArray = [HistoryManga]()
    var bookMarkArray = [BookmarkManga]()
    var historyData = [HistoryAPIModel]()
    
    var screenEnterTime: Date?

    
    lazy var realm = try! Realm()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if NetworkMonitor.shared.isConnected {
            print("You're on connected")
        }else{
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: false, completion: nil)
//            return
        }
        fetchData()
        fetchAPI()
    }
    
    fileprivate func loadAd() {
        if interstitial != nil && NetworkMonitor.adCount >= 4{
            NetworkMonitor.adCount = 0
            print(NetworkMonitor.adCount)
            interstitial?.present(fromRootViewController: self)
        } else {
            NetworkMonitor.adCount += 1
            print(NetworkMonitor.adCount)
            print("Ad wasn't ready")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadAd()
    }
    
    override func viewDidLoad() {
      let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-5372862349743986/6839460573",
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
        }
        )
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [AnalyticsParameterScreenName: "hisAbookVC"])
        screenEnterTime = Date()

        super.viewDidLoad()
        self.view.layer.cornerRadius = 8
        hisAbookCLV.backgroundColor = .clear
        hisAbookCLV.register(UINib(nibName: "mangaCell", bundle: nil), forCellWithReuseIdentifier: "mangaCell")
        
    
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsLogTimeUsing(screen: "hisAbookVC", enterTime: screenEnterTime)
    }
    
    private func fetchData(){
        lazy var realm = try! Realm()
//        historyArray = realm.objects(HistoryManga.self).filter("idUser == %@", APIService.userId).toArray(ofType: HistoryManga.self)
//        historyArray.reverse()
        
        
        bookMarkArray = realm.objects(BookmarkManga.self).filter("idUser == %@", APIService.userId).toArray(ofType: BookmarkManga.self)
        bookMarkArray.reverse()
        hisAbookCLV.reloadData()
    }
    
    func fetchAPI() {
        APIService.shared.getHistory { [self] respone, error in
            if let data = respone {
                historyData = data
                hisAbookCLV.reloadData()
            }
        }
    }
    
    func changeTab(text: String) {
        type = text
        hisAbookCLV.reloadData()
    }
}


extension hisAbookVC : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if type == "history"{
            return historyData.count
        }
        
        return bookMarkArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if type == "history"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mangaCell", for: indexPath) as! mangaCell
            cell.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
            cell.layer.cornerRadius = 16
            cell.chapterView.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor
            cell.chapterView.layer.cornerRadius = 8
            cell.chapterView.layer.borderWidth = 1
            cell.chapterView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
            cell.newImage.isHidden = true
            
//            cell.name.text = historyArray[indexPath.row].title
//            cell.chapter.text = historyArray[indexPath.row].chapter
//            cell.image.kf.setImage(with: URL(string: historyArray[indexPath.row].image), placeholder: UIImage(named: "default"))
//            cell.timeLb.text = historyArray[indexPath.row].time
//            
//            let dataFilter = realm.objects(BookmarkManga.self).filter("link = %@ AND idUser == %@",historyArray[indexPath.row].link, APIService.userId).toArray(ofType: BookmarkManga.self).first
//            if dataFilter != nil {
//                cell.bookmarkImage.image = UIImage(named: "receipttext 2")
//            }
//            else{
//                cell.bookmarkImage.image = UIImage(named: "receipttext")
//            }
            
            cell.name.text = historyData[indexPath.row].title_manga
            cell.chapter.text = historyData[indexPath.row].title_chapter
            cell.image.kf.setImage(with: URL(string: historyData[indexPath.row].poster), placeholder: UIImage(named: "default"))
            cell.timeLb.text = historyData[indexPath.row].readAt
            
            let dataFilter = realm.objects(BookmarkManga.self).filter("link = %@ AND idUser == %@",historyData[indexPath.row].link_manga, APIService.userId).toArray(ofType: BookmarkManga.self).first
           
            if dataFilter != nil {
                cell.bookmarkImage.image = UIImage(named: "receipttext 2")
            }
            else{
                cell.bookmarkImage.image = UIImage(named: "receipttext")
            }
            
            return cell
        }
        
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mangaCell", for: indexPath) as! mangaCell
            cell.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
            cell.layer.cornerRadius = 16
            cell.chapterView.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor
            cell.chapterView.layer.cornerRadius = 8
            cell.chapterView.layer.borderWidth = 1
            cell.chapterView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
            cell.newImage.isHidden = true
            cell.timeLb.isHidden = true
            
            cell.name.text = bookMarkArray[indexPath.row].title
            cell.chapter.text = bookMarkArray[indexPath.row].chapter
            cell.bookmarkImage.image = UIImage(named: "receipttext 2")
            cell.image.kf.setImage(with: URL(string: bookMarkArray[indexPath.row].image), placeholder: UIImage(named: "default"))
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if type == "history"{
            let object = historyData[indexPath.row]
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailMangaVC") as! DetailMangaVC
            vc.modalPresentationStyle = .fullScreen
            vc.linkManga = object.link_manga
            self.present(vc, animated: false, completion: nil)
        }
        else{
            let object = bookMarkArray[indexPath.row]
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailMangaVC") as! DetailMangaVC
            vc.modalPresentationStyle = .fullScreen
            vc.linkManga = object.link
            self.present(vc, animated: false, completion: nil)
        }
    }
}

extension hisAbookVC : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: hisAbookCLV.bounds.width / 4 - 10, height: hisAbookCLV.bounds.height/3 - 10)
        }
        
        return CGSize(width: hisAbookCLV.bounds.width - 10, height: hisAbookCLV.bounds.height / 1.25 - 10)
    }
}

//
//  ProfileVC.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 16/03/2023.
//

import UIKit
import RealmSwift
import GoogleMobileAds
import Kingfisher
import Firebase

class ProfileVC: UIViewController, GADFullScreenContentDelegate {
    
    @IBOutlet weak var topView:UIView!
    @IBOutlet weak var savedListCLV:UICollectionView!
    
    lazy var realm = try! Realm()
    
    var listMangaSaved = [SaveMangaModel]()

    var interstitial: GADInterstitialAd?
    
    var profile = ProfileModel()
    
    var screenEnterTime: Date?

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
    
    override func viewWillAppear(_ animated: Bool) {
        print(APIService.userId)
        savedListCLV.register(UINib(nibName: "savedCell", bundle: nil), forCellWithReuseIdentifier: "savedCell")

        fetchData()
        viewConfig()

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

        super.viewDidLoad()
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [AnalyticsParameterScreenName: "ProfileVC"])
        screenEnterTime = Date()

        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsLogTimeUsing(screen: "ProfileVC", enterTime: screenEnterTime)
    }
    
    func fetchData(){
        listMangaSaved = realm.objects(SaveMangaModel.self).filter("idUser == %@", APIService.userId)
            .toArray(ofType: SaveMangaModel.self)
        listMangaSaved.reverse()
        
        savedListCLV.reloadData()
        print(listMangaSaved)
    }
    
    private func viewConfig(){
        setGradientBackground()
        
        
        topView.backgroundColor = .white
        topView.layer.backgroundColor = UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1).cgColor
        savedListCLV.backgroundColor = .clear
        
       
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
    
    func deleteRealm(idUser: Int) {
        var imageURL = [URL]()
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            for item in listMangaSaved {
                let item2 = URL(fileURLWithPath: dirPath).appendingPathComponent(item.image)
                imageURL.append(item2)
            }

        }
        for item in imageURL {
            do {
                try FileManager.default.removeItem(atPath: item.path)
            } catch {
                print("Could not delete file, probably read-only filesystem")
            }
        }
        let dataFilters = realm.objects(SaveMangaModel.self).filter("idUser == %@", APIService.userId)
        let dataFilters2 = realm.objects(SaveChapterModel.self).filter("idUser == %@", APIService.userId)
        for i in dataFilters2 {
            for j in i.images {
                let imageURL2 = URL(fileURLWithPath: paths.first!).appendingPathComponent(j.fileName)
                do {
                    try FileManager.default.removeItem(atPath: imageURL2.path)
                } catch {
                    print("Could not delete file, probably read-only filesystem")
                }
            }
        }
        try! realm.write {
            realm.delete(dataFilters)
            realm.delete(dataFilters2)
        }
       
        print("Delete Success")
    }
    

    
    @IBAction func didTapBack(_ sender: UIButton){
        
        self.dismiss(animated: true)
    }

}

extension ProfileVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listMangaSaved.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "savedCell", for: indexPath) as! savedCell
        cell.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        cell.layer.cornerRadius = 16
        cell.chapterCLV.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        cell.mangaName.text = listMangaSaved[indexPath.row].title
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(listMangaSaved[indexPath.row].image)
            cell.imageView.image = UIImage(contentsOfFile: imageURL.path)
           // Do whatever you want with the image
        }
    
        if listMangaSaved[indexPath.row].genre == "manga" {
            cell.listChapterSaved = realm.objects(SaveChapterModel.self).filter("linkManga = %@ AND idUser == %@",listMangaSaved[indexPath.row].link, APIService.userId).toArray(ofType: SaveChapterModel.self)
            cell.competitionHandler = { index in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "readMangaOffVC") as! readMangaOffVC
                vc.modalPresentationStyle = .fullScreen
                vc.listImage = self.realm.objects(SaveChapterModel.self).filter("linkManga = %@ AND chapter = %@ AND idUser == %@",self.listMangaSaved[indexPath.row].link,cell.listChapterSaved[index].chapter, APIService.userId).toArray(ofType: SaveChapterModel.self)
                vc.titleManga = self.listMangaSaved[indexPath.row].title
                self.present(vc, animated: false, completion: nil)
            }
        }
        else if listMangaSaved[indexPath.row].genre == "novel" {
            cell.listChapterSaved = realm.objects(SaveChapterModel.self).filter("linkManga = %@ AND idUser == %@",listMangaSaved[indexPath.row].link, APIService.userId).toArray(ofType: SaveChapterModel.self)
            cell.competitionHandler = { index in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "readNovelOffVC") as! readNovelOffVC
                vc.modalPresentationStyle = .fullScreen
                vc.dataSources = self.realm.objects(SaveChapterModel.self).filter("linkManga = %@ AND chapter = %@ AND idUser == %@",self.listMangaSaved[indexPath.row].link,cell.listChapterSaved[index].chapter, APIService.userId).toArray(ofType: SaveChapterModel.self)
                vc.titleManga = self.listMangaSaved[indexPath.row].title
                self.present(vc, animated: false, completion: nil)
            }
        }
        
        cell.deleteHander = { [self] in
            //delete poster
            let imageURL = URL(fileURLWithPath: paths.first!).appendingPathComponent(listMangaSaved[indexPath.row].image)
            print(imageURL)
            do {
                try FileManager.default.removeItem(atPath: imageURL.path)
            } catch {
                print("Could not delete file, probably read-only filesystem")
            }
            let dataFilters = realm.objects(SaveMangaModel.self).filter("link = %@ AND idUser == %@", listMangaSaved[indexPath.row].link, APIService.userId)
            let dataFilters2 = realm.objects(SaveChapterModel.self).filter("linkManga = %@ AND idUser == %@",listMangaSaved[indexPath.row].link, APIService.userId)
            for i in dataFilters2 {
                for j in i.images {
                    let imageURL2 = URL(fileURLWithPath: paths.first!).appendingPathComponent(j.fileName)
                    do {
                        try FileManager.default.removeItem(atPath: imageURL2.path)
                    } catch {
                        print("Could not delete file, probably read-only filesystem")
                    }
                }
            }
            try! realm.write {
                realm.delete(dataFilters)
                realm.delete(dataFilters2)
            }
            fetchData()
            savedListCLV.reloadData()
            print("Delete Success")
        }
        
        return cell
    }
}

extension ProfileVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = savedListCLV.bounds.width
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "savedCell", for: indexPath) as! savedCell
        cell.mangaName.text = listMangaSaved[indexPath.row].title
        cell.mangaName.sizeToFit()
        return CGSize(width: width - 10, height: cell.mangaName.bounds.height + 150)
    }
}

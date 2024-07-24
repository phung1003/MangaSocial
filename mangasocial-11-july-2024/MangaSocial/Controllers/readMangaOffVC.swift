//
//  readMangaOffVC.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 17/03/2023.
//

import UIKit
import Firebase

class readMangaOffVC: UIViewController {
    
    @IBOutlet weak var offlineCLV:UICollectionView!
    @IBOutlet weak var upBut: UIButton!
    
    var titleManga = ""
    
    var listImage = [SaveChapterModel]()
    var imagesMode = [ImageModel]()
    
    var initDatas: [PhotoItem] = []
    var dataSources: [PhotoItem] = []
    
    var screenEnterTime: Date?


    override func viewDidLoad() {
        
        super.viewDidLoad()
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [AnalyticsParameterScreenName: "readMangaOffVC"])
        screenEnterTime = Date()

        viewConfig()
        fetchData()
        offlineCLV.register(UINib(nibName: "imageMangaCell", bundle: nil), forCellWithReuseIdentifier: "imageMangaCell")
        offlineCLV.register(UINib(nibName: "headerOffReadMangaCell", bundle: nil), forCellWithReuseIdentifier: "headerOffReadMangaCell")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsLogTimeUsing(screen: "readMangaOffVC", enterTime: screenEnterTime)
    }
    
    private func viewConfig(){
        setGradientBackground()
        offlineCLV.backgroundColor = .clear
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
    
    private func fetchData(){
        for i in listImage.first!.images {
            print(i.fileName)
            imagesMode.append(ImageModel.imageWith(url: i.fileName))
        }
        readNonCacheChapter(images: imagesMode)
    }
    
    func readNonCacheChapter(images: [ImageModel]){
        if images.count > 0{
            var photoItems = [PhotoItem]()
            for imageChapter in images{
                let photo = PhotoItem.photoWithImageURL(imageChapter.thumbnail_url)
                photo.viewWidth = CGFloat(imageChapter.width)
                photo.viewHeight = CGFloat(imageChapter.height)
                photoItems.append(photo)
            }
            initDatas.removeAll()
            initDatas.append(contentsOf: photoItems)
            dataSources.removeAll()
            dataSources.append(contentsOf: initDatas)
        }
    }
    
    @IBAction func upBut(_ sender: UIButton) {
        offlineCLV.setContentOffset(CGPoint(x:0,y:0), animated: true)
    }

}

extension readMangaOffVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return dataSources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerOffReadMangaCell", for: indexPath) as! headerOffReadMangaCell
            cell.mangaName.text = titleManga
            cell.topView.layer.backgroundColor = UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1).cgColor
            cell.backHandler = {
                
                self.dismiss(animated: true)
            }
            return cell
        }
        
        if indexPath.row > 2 {
            upBut.isHidden = false
        }
        else{
            upBut.isHidden = true
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageMangaCell", for: indexPath) as! imageMangaCell
        cell.page.text = String(indexPath.row)
        let photoModel = dataSources[indexPath.row]
        if let image = photoModel.underlyingImage{
            cell.imageManga.image = image
        }else{
            if let imageUrl = photoModel.photoURL{
                let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
                let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
                let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
                let dirPath = paths.first
                let url = URL(fileURLWithPath: dirPath!).appendingPathComponent(imageUrl)
                cell.imageManga.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) { [weak self] (result) in
                    switch result {
                    case .success(let value):
                        for (index, item) in self?.initDatas.enumerated() ?? [].enumerated(){
                            let urlddd = value.source.url?.path
                            let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
                            let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
                            let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
                            let dirPath = paths.first
                            let url = URL(fileURLWithPath: dirPath!).appendingPathComponent(item.photoURL ?? "")
                            if url.path == urlddd {
                                let temp = PhotoItem.init(image: value.image)
                                self?.initDatas.remove(at: index)
                                self?.initDatas.insert(temp, at: index)
                            }
                        }
                        for (index, item) in self?.dataSources.enumerated() ?? [].enumerated(){
                            let urlddd = value.source.url?.path
                            let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
                            let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
                            let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
                            let dirPath = paths.first
                            let url = URL(fileURLWithPath: dirPath!).appendingPathComponent(item.photoURL ?? "")
                            if url.path == urlddd{
                                let temp = PhotoItem.init(image: value.image)
                                self?.dataSources.remove(at: index)
                                self?.dataSources.insert(temp, at: index)
                                collectionView.reloadItems(at: [IndexPath.init(row: index, section: 1)])
                                break
                            }
                        }
                    case .failure(_):
                        break
                    }
                }
            }
        }
        return cell
    }
}

extension readMangaOffVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: offlineCLV.bounds.width, height: 75)
        }
        
        let photoModel = dataSources[indexPath.row]
        let width = UIScreen.main.bounds.size.width
        let height = (photoModel.viewHeight / photoModel.viewWidth) * UIScreen.main.bounds.size.width
        if height < 20{
            return view.bounds.size
        }
        return CGSize.init(width: width, height: height)
    }
}

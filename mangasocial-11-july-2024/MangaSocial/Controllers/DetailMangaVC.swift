//
//  DetailMangaVC.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 08/03/2023.
//

import UIKit
import RealmSwift
import JGProgressHUD
import GoogleMobileAds
import Kingfisher
import Firebase

class DetailMangaVC: UIViewController {
   // @IBOutlet weak var chapterCLV:UICollectionView!
    
    @IBOutlet weak var imageManga:UIImageView!
    @IBOutlet weak var nameLb:UILabel!
    @IBOutlet weak var ratingLb:UILabel!
    @IBOutlet weak var authorLb:UILabel!
    @IBOutlet weak var genresLb:UILabel!
    @IBOutlet weak var statusLb:UILabel!
    @IBOutlet weak var viewLB:UILabel!
    @IBOutlet weak var summaryLb:UILabel!
    
    @IBOutlet weak var bookmarkBut:UIButton!
    @IBOutlet weak var readFirstBut:UIButton!
    @IBOutlet weak var readLastBut:UIButton!
    @IBOutlet weak var bookMarkBut: UIButton!
    @IBOutlet weak var chapterBut:UIButton!
    @IBOutlet weak var star1:UIImageView!
    @IBOutlet weak var star2:UIImageView!
    @IBOutlet weak var star3:UIImageView!
    @IBOutlet weak var star4:UIImageView!
    @IBOutlet weak var star5:UIImageView!
    
    var linkManga = ""
    //var chapter_number : Int = 0
    var rating : Double = 0.0
    var detailManga = DetailManga()
    
    lazy var realm = try! Realm()
    
    var isSave = false
    
    var screenEnterTime: Date?

    
    let hud = JGProgressHUD()
    
    private var interstitial: GADInterstitialAd?
    
    func starRating(rating: Double){
        if rating >= 1.0{
            star1.image = UIImage(named: "star")
        }
        if rating >= 2.0{
            star2.image = UIImage(named: "star")
        }
        if rating >= 3.0{
            star3.image = UIImage(named: "star")
        }
        if rating > 3.3 && rating < 3.7{
            star4.image = UIImage(named: "rating")
        }
        else if rating >= 3.7 {
            star4.image = UIImage(named: "star")
        }
        
        if rating > 4.3 && rating < 4.7 {
            star5.image = UIImage(named: "rating")
        }
        else if rating >= 4.7 {
            star5.image = UIImage(named: "star")
        }
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
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [AnalyticsParameterScreenName: "DetailMangaVC"])
        screenEnterTime = Date()

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
        if NetworkMonitor.shared.isConnected {
            print("You're on connected")
        }else{
            //            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            //            vc.modalPresentationStyle = .fullScreen
            //            self.present(vc, animated: false, completion: nil)
            //            return
        }
        
        
        
        viewConfig()
        fetchData()
        //  chapterCLV.register(UINib(nibName: "chapterCell", bundle: nil), forCellWithReuseIdentifier: "chapterCell")
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        let dataFilter1 = realm.objects(HistoryManga.self).filter("link = %@",linkManga).toArray(ofType: HistoryManga.self).first
//
//        if let dataFilter = dataFilter1{
//            let alert = UIAlertController(title: "Remind", message: "You are reading \(dataFilter.chapter). Do you want to continue reading?", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Yes", style: .default){
//                _ in
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "readMangaVC") as! readMangaVC
//                vc.modalPresentationStyle = .fullScreen
//                vc.linkManga = self.linkManga
//                vc.currentIndex = dataFilter.chapterIndex
//                vc.mangaInfo = self.detailManga
//                self.present(vc, animated: false, completion: nil)
//            })
//            alert.addAction(UIAlertAction(title: "No", style: .default){
//                _ in
//                try! self.realm.write {
//                    self.realm.delete(dataFilter)
//                }
//            })
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//            self.present(alert, animated: true)
//        }
//        
//        let dataFilter2 = realm.objects(BookmarkManga.self).filter("link = %@",linkManga).toArray(ofType: BookmarkManga.self).first
//        if dataFilter2 != nil {
//            bookmarkBut.setImage(UIImage(named: "Property 1=Iconsax, Property 2=Linear, Property 3=receipttext"), for: .normal)
//            isSave = true
//        }
//    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsLogTimeUsing(screen: "DetailMangaVC", enterTime: screenEnterTime)
    }
    
    private func viewConfig(){
        setGradientBackground()
  //      chapterCLV.backgroundColor = .clear
        summaryLb.sizeToFit()
        
        readFirstBut.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        readFirstBut.layer.cornerRadius = 8
        readFirstBut.layer.borderWidth = 1
        readFirstBut.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        
        readLastBut.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        readLastBut.layer.cornerRadius = 8
        readLastBut.layer.borderWidth = 1
        readLastBut.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        
        chapterBut.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        chapterBut.layer.cornerRadius = 8
        chapterBut.layer.borderWidth = 1
        chapterBut.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        
        hud.style = .dark
        hud.textLabel.text = "Loading"
        
    }
    
    fileprivate func parseData(listData: DetailManga) {
        print(linkManga)
        detailManga = listData
        nameLb.text = detailManga.title_manga
        ratingLb.text = detailManga.rate
        authorLb.text = detailManga.author
        genresLb.text = detailManga.genre_manga
        statusLb.text = detailManga.status_manga
        viewLB.text = detailManga.views
        summaryLb.text = detailManga.summary_manga
        if let rate = Double(detailManga.rate) {
            starRating(
                rating: rate)
        }
        else {
            starRating(rating: 3.0)
        }
        imageManga.kf.setImage(with: URL(string: detailManga.poster_manga))
        if detailManga.r18 {
            r18Alert()
        }
    }
    
    func fetchData(){
        hud.show(in: self.view)
        APIService.shared.getDetailManga(link: linkManga) { [self] (response, error) in
            if let listData = response{
                DispatchQueue.main.async{ [self] in
                    parseData(listData: listData)
         //           chapterCLV.reloadData()
                    hud.dismiss()
                    
                    
                    
                    
                }
            } else
            {
                hud.dismiss()
            }
        }
        
        
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
    
    @IBAction func didTapBack(_ sender: UIButton){
        
        self.dismiss(animated: true)
    }
    
    fileprivate func mangaShow(index: Int) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "readMangaVC") as! readMangaVC
        vc.modalPresentationStyle = .fullScreen
        var pageData = realm.objects(PageRead.self).filter("idUser == %@", APIService.userId).toArray(ofType: PageRead.self)
        
        
        if let item = pageData.first(where: {$0.name == detailManga.list_chapter[index].link_chapter})
        {
            vc.maxPage = item.page
            detailManga.list_chapter[index].maxPage = item.page
        }
        
        vc.linkChapter = detailManga.list_chapter[index].link_chapter
        vc.currentIndex = index
        vc.mangaInfo = detailManga
        vc.linkManga = linkManga
        self.present(vc, animated: false, completion: nil)
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM DD yyyy"
        let time = dateFormatter.string(from: date)
        
        let dataFilter = realm.objects(HistoryManga.self).filter("link = %@ AND idUser == %@",linkManga, APIService.userId).toArray(ofType: HistoryManga.self).first
        
        if let dataFilter = dataFilter {
            try! realm.write {
                dataFilter.chapter = detailManga.list_chapter[index].name_chapter
            }
        }else{
            saveData(image: detailManga.poster_manga, title: detailManga.title_manga, chapter: detailManga.list_chapter[index].name_chapter, chapterIndex: index, time: time, link: linkManga)
        }
    }
    
    fileprivate func novelShow(index: Int) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReadNovelVC") as! ReadNovelVC
        vc.modalPresentationStyle = .fullScreen
        var pageData = realm.objects(PageRead.self).filter("idUser == %@", APIService.userId).toArray(ofType: PageRead.self)
        
        
        if let item = pageData.first(where: {$0.name == detailManga.list_chapter[index].link_chapter})
        {
            detailManga.list_chapter[index].maxPage = item.page
        }
        
        vc.linkChapter = detailManga.list_chapter[index].link_chapter
        vc.currentIndex = index
        vc.mangaInfo = detailManga
        vc.linkManga = linkManga
        self.present(vc, animated: false, completion: nil)
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM DD yyyy"
        let time = dateFormatter.string(from: date)
        
        let dataFilter = realm.objects(HistoryManga.self).filter("link = %@ AND idUser == %@",linkManga, APIService.userId).toArray(ofType: HistoryManga.self).first
        
        if let dataFilter = dataFilter {
            try! realm.write {
                dataFilter.chapter = detailManga.list_chapter[index].name_chapter
            }
        }else{
            saveData(image: detailManga.poster_manga, title: detailManga.title_manga, chapter: detailManga.list_chapter[index].name_chapter, chapterIndex: index, time: time, link: linkManga)
        }
    }
    
    @IBAction func readFirst(_ sender: UIButton){
        if interstitial != nil && NetworkMonitor.adCount >= 4{
            print(NetworkMonitor.adCount)
            NetworkMonitor.adCount = 0
            interstitial?.present(fromRootViewController: self)
        } else {
            print(NetworkMonitor.adCount)
            NetworkMonitor.adCount += 1
            print("Ad wasn't ready")
        }
        if (detailManga.list_chapter.count != 0) {
            if detailManga.genres == "novel"
            {
                novelShow(index: detailManga.list_chapter.count - 1)
            }
            mangaShow(index: detailManga.list_chapter.count - 1)
        } else {
            showAlert()
        }
    }
    
    
    func showAlert() {
        let alert = UIAlertController(title: "No Chapter", message: "This Manga Doesn't Have Any Chapter", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    func r18Alert() {
        let alert = UIAlertController(title: "Warning!", message: "This manga contains adult content. You must be at least eighteen to view this manga.", preferredStyle: .alert)
        let action = UIAlertAction(title: "I'm 18", style: .default)
        let cancel = UIAlertAction(title: "Go back", style: .default){action in
            self.dismiss(animated: true)
        }
        alert.addAction(cancel)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    
    @IBAction func allChapter() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "popupChapterVC") as! popupChapterVC
        vc.linkManga = linkManga
        vc.modalPresentationStyle = .overFullScreen
        vc.mangaInfo = detailManga
        vc.appear(sender: self)
        vc.mode = 1
        

        
    }
    
    @IBAction func readLast(_ sender: UIButton){
        if interstitial != nil && NetworkMonitor.adCount >= 4{
            print(NetworkMonitor.adCount)
            NetworkMonitor.adCount = 0
            interstitial?.present(fromRootViewController: self)
        } else {
            print(NetworkMonitor.adCount)
            NetworkMonitor.adCount += 1
            print("Ad wasn't ready")
        }
        if !detailManga.list_chapter.isEmpty {
            if detailManga.genres == "novel"
            {
                novelShow(index: 0)
            }
            mangaShow(index: 0)
            
        } else {
            showAlert()
        }
    }
    
    private func saveData(image: String, title: String, chapter: String, chapterIndex: Int,time: String, link: String) {
        let data = HistoryManga()
        data.image = image
        data.title = title
        data.chapter = chapter
        data.chapterIndex = chapterIndex
        data.time = time
        data.link = link
        data.idUser = APIService.userId
        try! realm.write {
            realm.add(data)
            print("Add success")
        }
    }
    
    private func saveToBookMark(image: String, title: String, chapter: String, link: String) {
        let data = BookmarkManga()
        data.image = image
        data.title = title
        data.chapter = chapter
        data.link = link
        data.idUser = APIService.userId
        try! realm.write {
            realm.add(data)
            print("Add BM success")
        }
    }
    
    func showAlert2(message: String) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        var cancel = UIAlertAction(title: "Cancel", style: .cancel)
        var action = UIAlertAction(title: "OK", style: .default){action in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        alert.addAction(action)
        alert.addAction(cancel)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func didTapBookmark(_ sender: UIButton){
        if APIService.userId <= 0
        {
            showAlert2(message: "Please Log In To Continue")
        }
        else {
            if isSave == false {
                isSave = true
                bookmarkBut.setImage(UIImage(named: "Property 1=Iconsax, Property 2=Linear, Property 3=receipttext"), for: .normal)
                saveToBookMark(image: detailManga.poster_manga, title: detailManga.title_manga, chapter: detailManga.list_chapter[0].name_chapter, link: linkManga)
            }else{
                isSave = false
                bookmarkBut.setImage(UIImage(named: "receipttext 1"), for: .normal)
                let dataFilter = realm.objects(BookmarkManga.self).filter("link = %@ AND idUser == %@",linkManga, APIService.userId)
                try! realm.write {
                    realm.delete(dataFilter)
                }
            }
        }
    }
    
    
    
    @IBAction func didTapProfile(_ sender: UIButton){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileMenuVC") as! ProfileMenuVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
}

//extension DetailMangaVC : UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return detailManga.list_chapter.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chapterCell", for: indexPath) as! chapterCell
//        cell.chapterLb.text = detailManga.list_chapter[indexPath.row].name_chapter
//       
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        if interstitial != nil && NetworkMonitor.adCount >= 4{
//            print(NetworkMonitor.adCount)
//            NetworkMonitor.adCount = 0
//            interstitial?.present(fromRootViewController: self)
//        } else {
//            print(NetworkMonitor.adCount)
//            NetworkMonitor.adCount += 1
//            print("Ad wasn't ready")
//        }
//        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "readMangaVC") as! readMangaVC
//        vc.modalPresentationStyle = .fullScreen
//        vc.linkChapter = detailManga.list_chapter[indexPath.row].link_chapter
//        print(detailManga.list_chapter[indexPath.row].link_chapter)
//        vc.currentIndex = indexPath.row
//        vc.mangaInfo = detailManga
//        self.present(vc, animated: false, completion: nil)
//        let date = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM DD yyyy"
//        let time = dateFormatter.string(from: date)
//        let dataFilter = realm.objects(HistoryManga.self).filter("link = %@",linkManga).toArray(ofType: HistoryManga.self).first
//        
//        if let dataFilter = dataFilter {
//            try! realm.write {
//                dataFilter.chapter = detailManga.list_chapter[indexPath.row].name_chapter
//            }
//        }else{
//            saveData(image: detailManga.poster_manga, title: detailManga.title_manga, chapter: detailManga.list_chapter[indexPath.row].name_chapter, chapterIndex: indexPath.row, time: time, link: linkManga)
//        }
//        
//    }
//    
//    
//}
//

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}

extension DetailMangaVC : GADFullScreenContentDelegate {
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
    
    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
    }
}

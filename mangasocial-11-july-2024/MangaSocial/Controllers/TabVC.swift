//
//  TabVC.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 07/03/2023.
//

import UIKit
import RealmSwift
import JGProgressHUD
import GoogleMobileAds

class TabVC: UIViewController {
    
    @IBOutlet weak var topView:UIView!
    @IBOutlet weak var titleLb:UILabel!
    @IBOutlet weak var tabCLV:UICollectionView!
    @IBOutlet weak var homeBtn:UIButton!
    @IBOutlet weak var luBtn:UIButton!
    @IBOutlet weak var hotBtn:UIButton!
    @IBOutlet weak var newBtn:UIButton!
    
    @IBOutlet weak var pageLb:UILabel!
    
    var TabView = ""
    var homeData = HomeMangaSocialModel()
    var mangaArray = [itemMangaModel]()
    
    var mangaPage : Int = 1
    
    lazy var realm = try! Realm()
    
    let hud = JGProgressHUD()
    

    
    private var interstitial: GADInterstitialAd?
    
    override func viewWillAppear(_ animated: Bool) {
        if interstitial != nil && NetworkMonitor.adCount >= 4{
            print(NetworkMonitor.adCount)
            NetworkMonitor.adCount = 0
            interstitial?.present(fromRootViewController: self)
            
        } else {
            print(NetworkMonitor.adCount)
            NetworkMonitor.adCount += 1
            print("Ad wasn't ready")
        }
        viewConfig()
        
        if NetworkMonitor.shared.isConnected {
            print("You're on connected")
        }else{
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: false, completion: nil)
//            return
        }
    }
    
    private func fetchData() {
        mangaArray.removeAll()
        switch (TabView) {
        case ("Coming"):
            mangaArray = homeData.listCooming
            tabViewDisplay(t2: true, t3: false, t4: false)

            break
        case ("Rank Week"):
            mangaArray = homeData.listRankWeek
            tabViewDisplay(t2: false, t3: true, t4: false)

            break
        case("Rank Month"):
            mangaArray = homeData.listRankMonth
            tabViewDisplay(t2: false, t3: false, t4: true)

            break
        default:
            break
        }
        titleLb.text = TabView
        tabCLV.reloadData()
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

        
        super.viewDidLoad()
        

      
        
        tabCLV.register(UINib(nibName: "mangaCell", bundle: nil), forCellWithReuseIdentifier: "mangaCell")
        fetchData()
    }
    
    private func viewConfig(){
        setGradientBackground()
        topView.backgroundColor = .white
        topView.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        tabCLV.backgroundColor = .clear
        hud.style = .dark
        hud.textLabel.text = "Loading"
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
    
    func tabViewDisplay(t2: Bool, t3: Bool, t4: Bool){
        if t2 == true{
            luBtn.setTitleColor(UIColor(red: 0.988, green: 0.541, blue: 0.016, alpha: 1), for: .normal)
        }
        else{
            luBtn.setTitleColor(UIColor.white, for: .normal)
        }
        
        if t3 == true{
            hotBtn.setTitleColor(UIColor(red: 0.988, green: 0.541, blue: 0.016, alpha: 1), for: .normal)
        }
        else{
            hotBtn.setTitleColor(UIColor.white, for: .normal)
        }
        
        if t4 == true{
            newBtn.setTitleColor(UIColor(red: 0.988, green: 0.541, blue: 0.016, alpha: 1), for: .normal)
        }
        else{
            newBtn.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    
    @IBAction func didTapHome(_ sender: UIButton){
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        vc.modalPresentationStyle = .fullScreen
        vc.homeData = self.homeData
        vc.check = 1
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func didLastUpdate(_ sender: UIButton){
        
        loadAd()
       
        
        TabView = "Coming"
        fetchData()
        titleLb.text = "Coming"
        mangaPage = 1
        pageLb.text = "Page \(mangaPage) of 50"
        tabViewDisplay(t2: true, t3: false, t4: false)
        
    }
    
    @IBAction func didTapHotManga(_ sender: UIButton){
        
        loadAd()
        TabView = "Rank Week"
        titleLb.text = "Rank Week"
        mangaPage = 1
        pageLb.text = "Page \(mangaPage) of 50"
        tabViewDisplay(t2: false, t3: true, t4: false)
        fetchData()
    }
    
    @IBAction func didTapNewManga(_ sender: UIButton){
 
        loadAd()

        TabView = "Rank Month"
        titleLb.text = "Rank Month"
        mangaPage = 1
        pageLb.text = "Page \(mangaPage) of 50"
        tabViewDisplay(t2: false, t3: false, t4: true)
        fetchData()
    }
    
    @IBAction func didTapFloatingBut(_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupVc") as! PopupVc
        vc.modalPresentationStyle = .overFullScreen
        vc.appear(sender: self)
    }
    
    @IBAction func didTapGenre(_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GenresVC") as! GenresVC
        vc.homeData = homeData
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    
    @IBAction func didTapSearch(_ sender: UIButton){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "searchVC") as! searchVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func onPrePage(_ sender: UIButton){
        loadAd()
        if NetworkMonitor.shared.isConnected {
            print("You're on connected")
        }else{
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: false, completion: nil)
//            return
        }
       
        
    }
    
    @IBAction func onNextPage(_ sender: UIButton){
        if NetworkMonitor.shared.isConnected {
            print("You're on connected")
        }else{
            //            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            //            vc.modalPresentationStyle = .fullScreen
            //            self.present(vc, animated: false, completion: nil)
            //            return
        }
        
        loadAd()
    }
    
    @IBAction func didTapProfile(_ sender: UIButton){
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileMenuVC") as! ProfileMenuVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
}

extension TabVC : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mangaArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mangaCell", for: indexPath) as! mangaCell
        cell.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        cell.layer.cornerRadius = 16
        cell.layer.borderWidth = 1
        cell.chapterView.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor
        cell.chapterView.layer.cornerRadius = 8
        cell.chapterView.layer.borderWidth = 1
        cell.chapterView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        cell.name.text = mangaArray[indexPath.row].title_manga
        let s = mangaArray[indexPath.row].chapter_new
        if let son = s.range(of: "chapter"){
            let s2 = s.suffix(from: son.lowerBound)
            let s3 = s2.replacingOccurrences(of: "chapter-", with: "")
            let s4 = s3.replacingOccurrences(of: "/", with: "")
            let s5 = s4.replacingOccurrences(of: "-", with: ".")
            cell.chapter.text = "Chapter \(s5)"
        }
        cell.image.kf.setImage(with: URL(string: mangaArray[indexPath.row].image_poster_link_goc))
        cell.timeLb.text = mangaArray[indexPath.row].time_release
      //  cell.starRating(rating: Double(mangaArray[indexPath.row].rate)!)
        cell.starRating(rating: 3.0)
        let dataFilter = realm.objects(BookmarkManga.self).filter("link = %@ AND idUser == %@",mangaArray[indexPath.row].url_manga, APIService.userId).toArray(ofType: BookmarkManga.self).first
        if dataFilter != nil {
            cell.bookmarkImage.image = UIImage(named: "receipttext 2")
        }
        else{
            cell.bookmarkImage.image = UIImage(named: "receipttext")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailMangaVC") as! DetailMangaVC
        vc.modalPresentationStyle = .fullScreen
        
        var name = mangaArray[indexPath.row].url_manga
        if let url = URL(string: name) {
            vc.linkManga += url.lastPathComponent
            print(vc.linkManga)
        }
        vc.linkManga = name
        self.present(vc, animated: false, completion: nil)
    }
}

extension TabVC : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: tabCLV.bounds.width / 4 - 10, height: tabCLV.bounds.height/3 - 10)
        }
        
        return CGSize(width: tabCLV.bounds.width - 10, height: tabCLV.bounds.height / 1.5 - 10)
    }
}

extension TabVC : GADFullScreenContentDelegate {
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

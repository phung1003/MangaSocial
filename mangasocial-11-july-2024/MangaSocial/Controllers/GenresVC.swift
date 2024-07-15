//
//  GenresVC.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 07/03/2023.
//

import UIKit
import Kingfisher
import JGProgressHUD
import RealmSwift
import GoogleMobileAds

class GenresVC: UIViewController, GADFullScreenContentDelegate {
    
    @IBOutlet weak var genresCLV:UICollectionView!

    var homeData = HomeMangaSocialModel()
    var genresList = [GenresModel]()
    var genresTitle = ""
    var lastpage = 0
    var currentpage = 1
    var genresKey = ""
    var interstitial: GADInterstitialAd?
    
    let hud = JGProgressHUD()
    
    
    lazy var realm = try! Realm()
    
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
        
        if NetworkMonitor.shared.isConnected {
            print("You're on connected")
        }else{
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: false, completion: nil)
//            return
        }
        setGradientBackground()
        
        fetchData()
        hud.style = .dark
        hud.textLabel.text = "Loading"

        genresCLV.backgroundColor = .clear
        genresCLV.register(UINib(nibName: "genresCell", bundle: nil), forCellWithReuseIdentifier: "genresCell")
        genresCLV.register(UINib(nibName: "genresTitleCell", bundle: nil), forCellWithReuseIdentifier: "genresTitleCell")
        genresCLV.register(UINib(nibName: "mangaCell", bundle: nil), forCellWithReuseIdentifier: "mangaCell")
    }
    
    func setGradientBackground() {

        let colorTop =  UIColor(red: 0.953, green: 0.639, blue: 0.016, alpha: 1).cgColor
        let colorMid = UIColor(red: 0.946, green: 0.789, blue: 0.478, alpha: 1).cgColor
        let colorBottom = UIColor(red: 0.953, green: 0.639, blue: 0.016, alpha: 0.68).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorMid,colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func fetchData(){
//        genresList.append(GenresModel(key: "4-koma", title: "4-koma"))
//        genresList.append(GenresModel(key: "action", title: "Action"))
//        genresList.append(GenresModel(key: "action-adventure", title: "Action Adventure"))
//        genresList.append(GenresModel(key: "action-fantasy", title: "Action Fantasy"))
//        genresList.append(GenresModel(key: "adaptation", title: "Adaptation"))
////        genresList.append(GenresModel(key: "adult", title: "Adult"))
//        genresList.append(GenresModel(key: "adventure", title: "Adventure"))
//        genresList.append(GenresModel(key: "animals", title: "ANIMALS"))
//        genresList.append(GenresModel(key: "another-chance", title: "Another chance"))
//        genresList.append(GenresModel(key: "anthology", title: "ANTHOLOGY"))
//        genresList.append(GenresModel(key: "cheat", title: "Cheat"))
//        genresList.append(GenresModel(key: "cheat-ability", title: "Cheat Ability"))
//        genresList.append(GenresModel(key: "childhood-friends", title: "Childhood Friends"))
//        genresList.append(GenresModel(key: "college-life", title: "College life"))
//        genresList.append(GenresModel(key: "comedy", title: "Comedy"))
//        genresList.append(GenresModel(key: "comic", title: "Comic"))
//        genresList.append(GenresModel(key: "coming-soon", title: "Coming Soon"))
//        genresList.append(GenresModel(key: "cooking", title: "Cooking"))
//        genresList.append(GenresModel(key: "crime", title: "Crime"))
//        genresList.append(GenresModel(key: "cultivation", title: "Cultivation"))
//        genresList.append(GenresModel(key: "demon", title: "Demon"))
//        genresList.append(GenresModel(key: "demons", title: "Demons"))
//        genresList.append(GenresModel(key: "doujinshi", title: "Doujinshi"))
//        genresList.append(GenresModel(key: "drama", title: "Drama"))
//        genresList.append(GenresModel(key: "dungeon", title: "Dungeon"))
////        genresList.append(GenresModel(key: "ecchi", title: "Ecchi"))
//        genresList.append(GenresModel(key: "erotica", title: "Erotica"))
//        genresList.append(GenresModel(key: "fantasy", title: "Fantasy"))
//        genresList.append(GenresModel(key: "fantasy-r-18", title: "FANTASY .R-18"))
//        genresList.append(GenresModel(key: "fantasy-manhwa", title: "FANTASY MANHWA"))
//        genresList.append(GenresModel(key: "food", title: "Food"))
//        genresList.append(GenresModel(key: "full-color", title: "Full Color"))
//        genresList.append(GenresModel(key: "fusion-fantasy", title: "Fusion Fantasy"))
//        genresList.append(GenresModel(key: "gal-ni-yasashii-otaku-kun", title: "Gal ni Yasashii Otaku-kun"))
//        genresList.append(GenresModel(key: "game", title: "Game"))
//        genresList.append(GenresModel(key: "games", title: "Games"))
////        genresList.append(GenresModel(key: "gender-bender", title: "Gender Bender"))
//        genresList.append(GenresModel(key: "genderswap", title: "GENDERSWAP"))
//        genresList.append(GenresModel(key: "genius", title: "Genius"))
//        genresList.append(GenresModel(key: "gods", title: "gods"))
//        genresList.append(GenresModel(key: "gore", title: "GORE"))
//        genresList.append(GenresModel(key: "gyvaru", title: "GYARU"))
////        genresList.append(GenresModel(key: "harem", title: "Harem"))
//        genresList.append(GenresModel(key: "historical", title: "Historical"))
//        genresList.append(GenresModel(key: "horror", title: "Horror"))
//        genresList.append(GenresModel(key: "hot-blood", title: "Hot blood"))
//        genresList.append(GenresModel(key: "hunter", title: "Hunter"))
//        genresList.append(GenresModel(key: "isekai", title: "Isekai"))
//        genresList.append(GenresModel(key: "japanese", title: "Japanese"))
//        genresList.append(GenresModel(key: "josei", title: "Josei"))
//        genresList.append(GenresModel(key: "kids", title: "Kids"))
//        genresList.append(GenresModel(key: "korean", title: "Korean"))
//        genresList.append(GenresModel(key: "ladies", title: "Ladies"))
//        genresList.append(GenresModel(key: "levening", title: "Levening"))
//        genresList.append(GenresModel(key: "long-strip", title: "LONG STRIP"))
//        genresList.append(GenresModel(key: "magic", title: "Magic"))
//        genresList.append(GenresModel(key: "magical-girls", title: "Magical Girls"))
//        genresList.append(GenresModel(key: "manga", title: "Manga"))
//        genresList.append(GenresModel(key: "manhua", title: "Manhua"))
//        genresList.append(GenresModel(key: "manhwa", title: "Manhwa"))
//        genresList.append(GenresModel(key: "martial-arts", title: "Martial arts"))
//        genresList.append(GenresModel(key: "mature", title: "Mature"))
//        genresList.append(GenresModel(key: "mc", title: "MC"))
//        genresList.append(GenresModel(key: "mecha", title: "Mecha"))
//        genresList.append(GenresModel(key: "medical", title: "Medical"))
//        genresList.append(GenresModel(key: "military", title: "Military"))
//        genresList.append(GenresModel(key: "modern-fantasy", title: "Modern Fantasy"))
//        genresList.append(GenresModel(key: "monster", title: "Monster"))
//        genresList.append(GenresModel(key: "monster-girls", title: "Monster girls"))
//        genresList.append(GenresModel(key: "monsters", title: "Monsters"))
//        genresList.append(GenresModel(key: "murim", title: "Murim"))
//        genresList.append(GenresModel(key: "music", title: "Music"))
//        genresList.append(GenresModel(key: "mystery", title: "Mystery"))
//        genresList.append(GenresModel(key: "necromancer", title: "Necromancer"))
//        genresList.append(GenresModel(key: "office-workers", title: "Office workers"))
//        genresList.append(GenresModel(key: "one-shot", title: "One shot"))
//        genresList.append(GenresModel(key: "op-mc", title: "Op-Mc"))
//        genresList.append(GenresModel(key: "otherworld", title: "Otherworld"))
//        genresList.append(GenresModel(key: "overpowered", title: "Overpowered"))
//        genresList.append(GenresModel(key: "police", title: "Police"))
//        genresList.append(GenresModel(key: "philosophical", title: "Philosophical"))
//        genresList.append(GenresModel(key: "psychological", title: "Psychological"))
//        genresList.append(GenresModel(key: "r-18", title: "R-18"))
//        genresList.append(GenresModel(key: "rebirth", title: "Rebirth"))
//        genresList.append(GenresModel(key: "regression", title: "Regression"))
//        genresList.append(GenresModel(key: "reincarnation", title: "Reincarnation"))
//        genresList.append(GenresModel(key: "returner", title: "Returner"))
//        genresList.append(GenresModel(key: "revenge", title: "Revenge"))
//        genresList.append(GenresModel(key: "romance", title: "Romance"))
//        genresList.append(GenresModel(key: "royal-family", title: "Royal family"))
//        genresList.append(GenresModel(key: "royalty", title: "Royalty"))
//        genresList.append(GenresModel(key: "school-life", title: "School Life"))
//        genresList.append(GenresModel(key: "sci-fi", title: "Sci fi"))
//        genresList.append(GenresModel(key: "seinen", title: "Sseinen"))
//        genresList.append(GenresModel(key: "shotacon", title: "Shotacon"))
//        genresList.append(GenresModel(key: "shoujo", title: "Shoujo"))
//        genresList.append(GenresModel(key: "shoujo-ai", title: "Shoujo Ai"))
//        genresList.append(GenresModel(key: "shoujoai", title: "Shoujoai"))
//        genresList.append(GenresModel(key: "shounen", title: "Shounen"))
//        genresList.append(GenresModel(key: "shounen-ai", title: "Shounen ai"))
//        genresList.append(GenresModel(key: "slice-of-life", title: "Slice of life"))
////        genresList.append(GenresModel(key: "smut", title: "Smut"))
//        genresList.append(GenresModel(key: "sports", title: "Sports"))
//        genresList.append(GenresModel(key: "suggestive", title: "Suggestive"))
//        genresList.append(GenresModel(key: "super-power", title: "Super Power"))
//        genresList.append(GenresModel(key: "superhero", title: "Superhero"))
//        genresList.append(GenresModel(key: "supernatural", title: "Supernatural"))
//        genresList.append(GenresModel(key: "survival", title: "Survival"))
//        genresList.append(GenresModel(key: "system", title: "System"))
//        genresList.append(GenresModel(key: "teacher", title: "Teacher"))
//        genresList.append(GenresModel(key: "thriller", title: "Thriller"))
//        genresList.append(GenresModel(key: "time-travel", title: "Time travel"))
//        genresList.append(GenresModel(key: "tower", title: "Tower"))
//        genresList.append(GenresModel(key: "tragedy", title: "Tragedy"))
//        genresList.append(GenresModel(key: "vampire", title: "Vampire"))
//        genresList.append(GenresModel(key: "vampires", title: "Vampires"))
//        genresList.append(GenresModel(key: "video-games", title: "Video games"))
//        genresList.append(GenresModel(key: "vietnamese", title: "Vietnamese"))
//        genresList.append(GenresModel(key: "villainess", title: "Villainess"))
//        genresList.append(GenresModel(key: "violence", title: "Violence"))
//        genresList.append(GenresModel(key: "virtual-reality", title: "Virtual reality"))
//        genresList.append(GenresModel(key: "vr", title: "VR"))
//        genresList.append(GenresModel(key: "web-comic", title: "Web Comic"))
//        genresList.append(GenresModel(key: "webtoon", title: "Webtoon"))
//        genresList.append(GenresModel(key: "webtoons", title: "Webtoons"))
//        genresList.append(GenresModel(key: "wuxia", title: "Wuxia"))
//        genresList.append(GenresModel(key: "yaoi", title: "Yaoi"))
//        genresList.append(GenresModel(key: "yuri", title: "Yuri"))
//        genresList.append(GenresModel(key: "zombies", title: "Zombies"))
        APIService.shared.getAllGenre{ [self](data, error) in
            if let data = data {
                genresList = data
                genresCLV.reloadData()
            }
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
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabVC") as! TabVC
        vc.homeData = homeData
        vc.modalPresentationStyle = .fullScreen
        vc.TabView = "Coming"
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func didTapHotManga(_ sender: UIButton){
       
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabVC") as! TabVC
        vc.homeData = homeData
        vc.modalPresentationStyle = .fullScreen
        vc.TabView = "Rank Week"
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func didTapNewManga(_ sender: UIButton){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabVC") as! TabVC
        vc.homeData = homeData
        vc.modalPresentationStyle = .fullScreen
        vc.TabView = "Rank Month"
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func didTapSearch(_ sender: UIButton){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "searchVC") as! searchVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func didTapFloatingBut(_ sender: UIButton){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupVc") as! PopupVc
        vc.modalPresentationStyle = .overFullScreen
        vc.appear(sender: self)
    }
    
    @IBAction func didTapProfile(_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileMenuVC") as! ProfileMenuVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    

}

extension GenresVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
     
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
      
        
        return genresList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        if isSelectedItem == true {
//            if indexPath.section == 0 {
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genresTitleCell", for: indexPath) as! genresTitleCell
//                if lastpage == 0 {
//                    cell.titleLb.text = "\(genresTitle)"
//                }
//                else{
//                    cell.titleLb.text = "\(genresTitle) page \(currentpage)/\(lastpage)"
//                }
//                cell.titleLb.textColor = UIColor(red: 0.953, green: 0.639, blue: 0.016, alpha: 1)
//                cell.handler = {
//                    self.isSelectedItem = false
//                    self.genresCLV.backgroundColor = .clear
//                    self.currentpage = 1
//                    self.lastpage = 0
//                    self.genresCLV.reloadData()
//                }
//                return cell
//            }
//
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mangaCell", for: indexPath) as! mangaCell
//            cell.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
//            cell.layer.cornerRadius = 16
//            cell.layer.borderWidth = 1
//            cell.chapterView.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor
//            cell.chapterView.layer.cornerRadius = 8
//            cell.chapterView.layer.borderWidth = 1
//            cell.chapterView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
//            cell.name.text = mangaArray[indexPath.row].title_manga
//            let s = mangaArray[indexPath.row].lastest_chapter_manga
//            if let son = s.range(of: "chapter"){
//                let s2 = s.suffix(from: son.lowerBound)
//                let s3 = s2.replacingOccurrences(of: "chapter-", with: "")
//                let s4 = s3.replacingOccurrences(of: "/", with: "")
//                let s5 = s4.replacingOccurrences(of: "-", with: ".")
//                cell.chapter.text = "Chapter \(s5)"
//            }
//            cell.image.kf.setImage(with: URL(string: mangaArray[indexPath.row].poster_manga))
//            cell.timeLb.text = mangaArray[indexPath.row].release_manga
//            //cell.starRating(rating: Double(mangaArray[indexPath.row].rating_manga)!)
//            let dataFilter = realm.objects(BookmarkManga.self).filter("link = %@",mangaArray[indexPath.row].link_manga).toArray(ofType: BookmarkManga.self).first
//            if dataFilter != nil {
//                cell.bookmarkImage.image = UIImage(named: "receipttext 2")
//            }
//            else{
//                cell.bookmarkImage.image = UIImage(named: "receipttext")
//            }
//            return cell
//        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genresCell", for: indexPath) as! genresCell
        cell.genresName.text = genresList[indexPath.row].category_name
        cell.genreImg.kf.setImage(with: URL(string: genresList[indexPath.row].image))
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GenreSearchVC") as! GenreSearchVC
        vc.modalPresentationStyle = .fullScreen
        vc.genre = genresList[indexPath.row].category_name
        self.present(vc, animated: false, completion: nil)
    }
}

extension GenresVC : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    }
    
   

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: genresCLV.bounds.width / 2 - 10, height:206)
        }
        
        return CGSize(width: genresCLV.bounds.width / 2 - 10, height: 103)
        
    }
}

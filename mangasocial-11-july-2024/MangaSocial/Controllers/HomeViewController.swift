//
//  HomeViewController.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 06/03/2023.
//

import UIKit
import Kingfisher
import JGProgressHUD
import GoogleMobileAds
import OrderedCollections

class HomeViewController: UIViewController {
    
    @IBOutlet weak var topView:UIView!
    @IBOutlet weak var homeCLV:UICollectionView!
    @IBOutlet weak var search:UITextField!
    @IBOutlet weak var serverCLV: UICollectionView!
    @IBOutlet weak var serverImage: UIImageView!
    @IBOutlet weak var serverBtn: UIButton!
    var loginCheck = false
    var getDataCheck = false
    var modeCheck = false
    var homeData:HomeMangaSocialModel = HomeMangaSocialModel()
    var timer : Timer?
    var currentCellIndex = 0
    var mpArray = [LastestManga]()
    var lastestArray = [LastestManga]()
    var interstitial: GADInterstitialAd?
    let hud = JGProgressHUD()
    var check = 0
    
    var serverList: OrderedDictionary<String,String> = ["0": "mangainn.net", "1": "ww5.manganelo.tv", "2": "mangareader.cc", "3": "ninemanga.com", "4": "bestlightnovel.com", "19": "azoranov.com", "6": "mangakomi.io" , "7": "readm.org", "8": "mangajar.com", "9": "swatmanga.com", "11": "novelhall.com", "12": "mto.to", "10": "mangajar.com", "5": "mangajar.com/manga", "13": "de.ninemanga.com", "14": "br.ninemanga.com", "15": "ru.ninemanga.com", "16": "es.ninemanga.com", "17": "fr.ninemanga.com", "18": "it.ninemanga.com"]
    var webServerList: OrderedDictionary<String, String> = ["1": "ww5.manganelo.tv", "2": "mangareader.cc", "3": "ninemanga.com", "4": "bestlightnovel.com", "7": "readm.org" , "12": "mto.to", "13": "de.ninemanga.com", "14": "br.ninemanga.com", "15": "ru.ninemanga.com", "16": "es.ninemanga.com", "17": "fr.ninemanga.com", "18": "it.ninemanga.com"]
    
    let mangaReader = [1,2,2,1]
    let bestLightNovel = [1,2,2,3]
    let novelHall = [3,2]
    let nineManga = [3,2,2]
    let manganelo = [1]
    let readM = [1,2,2]
    
//    var serverList = ["0", "1", "2", "3", "4", "19", "6", "7", "8", "9", "19", "11", "12", "13", "14", "15", "16", "17", "18"]
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height

    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(moveToNextIndex), userInfo: nil, repeats: true)
    }
    
    func hudDismiss() {
        
        if loginCheck && getDataCheck && modeCheck{
            hud.dismiss()
        }
    }
    
    @objc func moveToNextIndex(){
        if currentCellIndex < mpArray.count - 1 {
            currentCellIndex += 1
        }else {
            currentCellIndex = 0
        }
        let index = IndexPath.init(item: currentCellIndex, section: 0)
    }
    
    fileprivate func getMode() {
        APIService.shared.check() { [self]data, error in
            print(data)
            if data == "on" {
                serverList = webServerList
                serverCLV.reloadData()
            }
            self.fetchData()
            self.modeCheck = true
            self.hudDismiss()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hud.show(in: self.view)
        startLogin()
        
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
        viewConfig()
        loadAd()
        self.fetchData()
    }
    
    fileprivate func login(email: String, password: String) {
        APIService.shared.Login(email: email, password: password)
        { data, error in
            self.getMode()
            DispatchQueue.main.async { [self] in
                if let data = data{
                    if data.errCode == 200 {
                        APIService.userId = data.account.id_user
                        print(APIService.userId)
                        UserDefaults.standard.set(data.account.id_user, forKey: "id_user")
                        UserDefaults.standard.set(email, forKey: "email")
                        UserDefaults.standard.set(password, forKey: "password")
                        APIService.isLogin = true
                        loginCheck = true
                        print("Done Login")
                        self.hudDismiss()
                    }
                }
                else {
                    loginCheck = true
                    self.hudDismiss()
                }
            }
        }
    }
    
    fileprivate func startLogin() {
        if let storedValue = UserDefaults.standard.string(forKey: "id_user")
        {
            let n = Int(storedValue)!
            if n > -1 {
                APIService.userId = n
                if let email = UserDefaults.standard.string(forKey: "email"), let password = UserDefaults.standard.string(forKey: "password") {
                    login(email: email, password: password)
                }
            } else {
                getMode()
                print("No User")
                loginCheck = true
                hudDismiss()
            }
        } else {
            getMode()
            loginCheck = true
            hudDismiss()
        }
    }
    
    fileprivate func fetchData() {
    
        APIService.shared.getHomeMangaSocial() { [self] (response, error) in
            if let listData = response{
                DispatchQueue.main.async {
                    self.homeData = listData
                    self.homeCLV.reloadData()
                    self.getDataCheck = true
                    self.hudDismiss()
                    print("Done Get Data")
                }
            } else{
                print("Error Get Data")
                getDataCheck = true
                hudDismiss()
            }
            
        }
    }
    
    override func viewDidLoad() {
        if let storedValue = UserDefaults.standard.string(forKey: "server") {
            APIService.serverIndex = storedValue
        } else {
            APIService.serverIndex = "2"
        }
    
        
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
        
        
        viewConfig()
        

        super.viewDidLoad()
        
        homeCLV.register(UINib(nibName: "HomeRecentCLVCell", bundle: nil), forCellWithReuseIdentifier: "HomeRecentCLVCell")
        homeCLV.register(UINib(nibName: "HomeRecommendedCLVCell", bundle: nil), forCellWithReuseIdentifier: "HomeRecommendedCLVCell")
        homeCLV.register(UINib(nibName: "HomeNewReleaseCell", bundle: nil), forCellWithReuseIdentifier: "HomeNewReleaseCell")
        homeCLV.register(UINib(nibName: "HomeTop15CLVCell", bundle: nil), forCellWithReuseIdentifier: "HomeTop15CLVCell")
        homeCLV.register(UINib(nibName: "HomeComingCLVCell", bundle: nil), forCellWithReuseIdentifier: "HomeComingCLVCell")
        homeCLV.register(UINib(nibName: "Type1CLVCell", bundle: nil), forCellWithReuseIdentifier: "Type1CLVCell")
        homeCLV.register(UINib(nibName: "Type2CLVCell", bundle: nil), forCellWithReuseIdentifier: "Type2CLVCell")
        homeCLV.register(UINib(nibName: "Type3CLVCell", bundle: nil), forCellWithReuseIdentifier: "Type3CLVCell")


        serverCLV.register(UINib(nibName: "ServerCell", bundle: nil), forCellWithReuseIdentifier: "ServerCell")
        serverCLV.reloadData()
        
        
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(endEdit))
        edgePan.edges = .left
        self.view.addGestureRecognizer(edgePan)
        
    }
    
    @objc func endEdit() {
        view.endEditing(true)
    }
    
    private func viewConfig(){
        setGradientBackground()
        search.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        search.layer.cornerRadius = 15.0
        search.layer.masksToBounds = true
        search.addLeftImage(name: "search")
        topView.backgroundColor = .white
        topView.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        homeCLV.backgroundColor = .clear
        
        serverCLV.backgroundColor = .gray
        serverCLV.layer.cornerRadius = 6
        serverCLV.layer.borderWidth = 1
        
        serverImage.image = UIImage(named: APIService.serverIndex)
        
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
    
    @IBAction func didTapHome(_ sender: UIButton){
        
    
    }
    
    @IBAction func changeMode() {
        APIService.shared.changeMode{data, error in}
    }
    
    @IBAction func showServer() {
        if serverCLV.isHidden == true
        {
//            serverBtn.backgroundColor = .gray
//            serverImage.backgroundColor = .gray
            serverCLV.isHidden = false
        }
        else {
//            serverBtn.backgroundColor = .clear
//            serverImage.backgroundColor = .clear
            serverCLV.isHidden = true
        }
    }
    
    @IBAction func done(_ sender: UITextField) {
        sender.resignFirstResponder()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "searchVC") as! searchVC
        vc.modalPresentationStyle = .fullScreen
        if let text = search.text {
            vc.textFind = text
            self.present(vc, animated: false, completion: nil)
        }
        
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
    
    @IBAction func didTapProfile(_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileMenuVC") as! ProfileMenuVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == serverCLV{
            return 1
        }
        switch APIService.serverIndex {
        case "2":
            return mangaReader.count + 1
        case "4":
            return bestLightNovel.count + 1
        case "11":
            return novelHall.count + 1
        case "13":
            return nineManga.count + 1
        case "14":
            return nineManga.count + 1
        case "15":
            return nineManga.count + 1
        case "16":
            return nineManga.count + 1
        case "17":
            return nineManga.count + 1
        case "18":
            return nineManga.count + 1
        case "1":
            return manganelo.count + 1
        case "3":
            return nineManga.count + 1
        case "7":
            return readM.count + 1
        default:
            return mangaReader.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == serverCLV {
            return serverList.count
        }
        
        return 1
    }
   
    
    fileprivate func createCell(_ collectionView: UICollectionView, _ indexPath: IndexPath,_ identifier: String,_ data: [itemMangaModel],_ title: String) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! TypeCell
        cell.data = data
        cell.title.text = title
        
        cell.homeCLV.reloadData()
        return cell
    }
    
    fileprivate func mangaReader(_ indexPath: IndexPath, _ collectionView: UICollectionView) -> UICollectionViewCell {
        if indexPath.section == 1 {
            return createCell(collectionView, indexPath, "Type1CLVCell", homeData.listNewRelease, "New Release")
        }
        if indexPath.section == 2{
            return createCell(collectionView, indexPath, "Type2CLVCell", homeData.listRecommended, "Recommended Manga")
            
        }
        if indexPath.section == 3{
            return createCell(collectionView, indexPath, "Type2CLVCell", homeData.listTop15, "Top 15 Manga")
            
        }
        else {
            return createCell(collectionView, indexPath, "Type1CLVCell", homeData.listCooming, "Coming Soon")
        }
    }
    
    fileprivate func bestLightNovel(_ indexPath: IndexPath, _ collectionView: UICollectionView) -> UICollectionViewCell {
        if indexPath.section == 1 {
            return createCell(collectionView, indexPath, "Type1CLVCell", homeData.listNewRelease, "Recently Updated Novel")
        }
        if indexPath.section == 2{
            return createCell(collectionView, indexPath, "Type2CLVCell", homeData.listRecommended, "Popuplar Novel This Month")
            
        }
        if indexPath.section == 3{
            return createCell(collectionView, indexPath, "Type2CLVCell", homeData.listTop15, "Top 15 Novel")
            
        }
        else {
            return createCell(collectionView, indexPath, "Type3CLVCell", homeData.listRankWeek, "Top Weekly Novel")
        }
    }
    
    fileprivate func novelHall(_ indexPath: IndexPath, _ collectionView: UICollectionView) -> UICollectionViewCell {
        if indexPath.section == 1 {
            return createCell(collectionView, indexPath, "Type3CLVCell", homeData.listNewRelease, "Latest Release Novel")
        }
        else {
            return createCell(collectionView, indexPath, "Type2CLVCell", homeData.listRecommended, "Recommend")
        }
    }
    
    fileprivate func nineManga(_ indexPath: IndexPath, _ collectionView: UICollectionView, _ title1: String, _ title2: String, _ title3: String) -> UICollectionViewCell {
        if indexPath.section == 1 {
            return createCell(collectionView, indexPath, "Type3CLVCell", homeData.listNewRelease, title1)
        }
        if indexPath.section == 2{
            return createCell(collectionView, indexPath, "Type2CLVCell", homeData.listRecommended, title2)
            
        }
        else {
            return createCell(collectionView, indexPath, "Type2CLVCell", homeData.listTop15, title3)
            
        }
    }
    
    fileprivate func manganelo(_ indexPath: IndexPath, _ collectionView: UICollectionView) -> UICollectionViewCell {
        return createCell(collectionView, indexPath, "Type1CLVCell", homeData.listNewRelease, "LATEST MANGA")
    }
    
    fileprivate func readM(_ indexPath: IndexPath, _ collectionView: UICollectionView) -> UICollectionViewCell {
        if indexPath.section == 1 {
            return createCell(collectionView, indexPath, "Type1CLVCell", homeData.listNewRelease, "Latest Updates")
        }
        if indexPath.section == 2{
            return createCell(collectionView, indexPath, "Type2CLVCell", homeData.listRecommended, "Popular Manga")
            
        }
        else {
            return createCell(collectionView, indexPath, "Type2CLVCell", homeData.listTop15, "Hot Manga Update")
            
        }
    }
    
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == serverCLV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServerCell", for: indexPath) as! ServerCell
            var keys = Array(serverList.keys)
            cell.image.image = UIImage(named: keys[indexPath.row])
            cell.label.text = serverList[keys[indexPath.row]]
            return cell
        }
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeRecentCLVCell", for: indexPath) as! HomeRecentCLVCell
            cell.homeData = self.homeData
            cell.homeCLV.reloadData()
            return cell
        }
        
        switch APIService.serverIndex {
        case "2":
            return mangaReader(indexPath, collectionView)
        case "4":
            return bestLightNovel(indexPath, collectionView)
        case "11":
            return novelHall(indexPath, collectionView)
        case "13":
            return nineManga(indexPath, collectionView, "Neueste Manga Updates", "Elite", "Beliebte")
        case "14":
            return nineManga(indexPath, collectionView, "Últimas Atualizações Mangás", "Top Atualizar", "Top Mangás")
        case "15":
            return nineManga(indexPath, collectionView, "Последние", "Топ манга", "Топ манга")
        case "16":
            return nineManga(indexPath, collectionView, "Últimas Atualizações Mangás", "Actualizar", "Popular")
        case "17":
            return nineManga(indexPath, collectionView, "Dernières Mises À Jour", "Hot Update", "Hot Manga")
        case "18":
            return nineManga(indexPath, collectionView, "Ultimi Agiornamenti Manga", "Aggiornare", "Popolare")
        case "1":
            return manganelo(indexPath, collectionView)
        case "3":
            return nineManga(indexPath, collectionView, "Latest Manga Updates", "Hot Update", "Hot Manga")
        case "7":
            return readM(indexPath, collectionView)
        default:
            return mangaReader(indexPath, collectionView)
        }
  
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == serverCLV {
//            serverBtn.backgroundColor = .clear
//            serverImage.backgroundColor = .clear
            var keys = Array(serverList.keys)
            serverImage.image = UIImage(named: keys[indexPath.row])
            serverCLV.isHidden = true
            APIService.serverIndex = keys[indexPath.row]
            hud.show(in: self.view)
            fetchData()
            UserDefaults.standard.set(keys[indexPath.row], forKey: "server")

        }
        
        if collectionView == homeCLV {
            if interstitial != nil && NetworkMonitor.adCount >= 4{
                NetworkMonitor.adCount = 0
                interstitial?.present(fromRootViewController: self)
            } else {
                NetworkMonitor.adCount += 1
                print("Ad wasn't ready")
            }
            
            let object = homeData.listNewRelease[indexPath.row]
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailMangaVC") as! DetailMangaVC
            vc.modalPresentationStyle = .fullScreen
            vc.linkManga = object.url_manga
            self.present(vc, animated: false, completion: nil)
            
        }
        
    }
}

extension HomeViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == serverCLV {
            return UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        }
        else {
            return UIEdgeInsets(top: 0.0, left: 1.0, bottom: 0.0, right: 1.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 24
        }
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == serverCLV {
            return CGSize(width: 100, height: 50)
        }
        
        
        if indexPath.section == 0{
            return CGSize(width: homeCLV.bounds.width, height: 240)
        } else {
            var cellType = [Int]()
            switch APIService.serverIndex {
            case "2":
                 cellType = mangaReader
            case "4":
                 cellType = bestLightNovel
            case "11":
                 cellType = novelHall
            case "13":
                 cellType = nineManga
            case "14":
                 cellType = nineManga
            case "15":
                 cellType = nineManga
            case "16":
                 cellType = nineManga
            case "17":
                 cellType = nineManga
            case "18":
                 cellType = nineManga
            case "1":
                 cellType = manganelo
            case "3":
                 cellType = nineManga
            case "7":
                 cellType = readM
            default:
                 cellType = mangaReader
            }
            
            switch cellType[indexPath.section - 1] {
            case 1:
                if APIService.serverIndex == "1" {
                    return CGSize(width: homeCLV.bounds.width, height: 185 * 6 /*cell*/ + 50 /*Title*/ + 52 /* Button. */)

                }
                return CGSize(width: homeCLV.bounds.width, height: 185 * 4 /*cell*/ + 50 /*Title*/ + 52 /* Button. */)
            case 2:
                return CGSize(width: homeCLV.bounds.width, height: 237 * 1 /*cell*/ + 50 /*Title*/ )
            case 3:
                return CGSize(width: homeCLV.bounds.width, height: 55 * 6 /*cell*/ + 50 /*Title*/ + 52 /* Button. */)
            default:
                return CGSize(width: homeCLV.bounds.width, height: 185 * 4 /*cell*/ + 50 /*Title*/ + 52 /* Button. */)
            }
        }
        
       
       
        
    }
    
    
}

extension HomeViewController : GADFullScreenContentDelegate {
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




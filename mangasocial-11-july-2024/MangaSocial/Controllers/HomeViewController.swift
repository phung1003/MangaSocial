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
    var webServerList: OrderedDictionary<String, String> = ["1": "ww5.manganelo.tv", "2": "mangareader.cc", "3": "ninemanga.com", "4": "bestlightnovel.com", "6": "mangakomi.io", "7": "readm.org" , "12": "mto.to", "13": "de.ninemanga.com", "14": "br.ninemanga.com", "15": "ru.ninemanga.com", "16": "es.ninemanga.com", "17": "fr.ninemanga.com", "18": "it.ninemanga.com"]
    

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
        topView.layer.backgroundColor = UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1).cgColor
        homeCLV.backgroundColor = .clear
        
        serverCLV.backgroundColor = .gray
        serverCLV.layer.cornerRadius = 6
        serverCLV.layer.borderWidth = 1
        
        serverImage.image = UIImage(named: APIService.serverIndex)
        
        self.hud.style = .dark
        self.hud.textLabel.text = "Loading"
        
        
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == serverCLV {
            return UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        }
        if section == 0 {
            return UIEdgeInsets(top: 0.0, left: 1.0, bottom: 0.0, right: 1.0)
        } else {
            // Normal insets for collection
            return UIEdgeInsets(top: 0.0, left: 1.0, bottom: 0.0, right: 1.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == serverCLV {
            return serverList.count
        }
        if section == 0{
            return 1
        }
        if section == 1{
            return 1
        }
        return 1
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == serverCLV{
            return 1
        }
        return 3
    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView == serverCLV{
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServerCell", for: indexPath) as! ServerCell
//            cell.image.image = UIImage(named: serverList[indexPath.row])
//
//            return cell
//        }
//        
//        if indexPath.section == 0 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeRecentCLVCell", for: indexPath) as! HomeRecentCLVCell
//            cell.homeData = self.homeData
//            cell.homeCLV.reloadData()
//            return cell
//        }
//        if indexPath.section == 1{
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeNewReleaseCell", for: indexPath) as! HomeNewReleaseCell
//            cell.homeData = self.homeData
//            cell.homeCLV.reloadData()
//            return cell
//        }
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeRecommendedCLVCell", for: indexPath) as! HomeRecommendedCLVCell
//        cell.homeData = self.homeData
//        cell.homeCLV.reloadData()
//        return cell
//    }
    
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
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeNewReleaseCell", for: indexPath) as! HomeNewReleaseCell
            cell.homeData = self.homeData
            cell.homeCLV.reloadData()
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeRecommendedCLVCell", for: indexPath) as! HomeRecommendedCLVCell
        cell.homeData = self.homeData
        cell.homeCLV.reloadData()
        return cell
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 10
        }
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == serverCLV {
            return CGSize(width: 100, height: 50)
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            if indexPath.section == 0{
                return CGSize(width: homeCLV.bounds.width, height:homeCLV.bounds.height/10*3 - 5)
            }
            else{
                return CGSize(width: homeCLV.bounds.width, height:530)
            }
        }
        
        if indexPath.section == 0{
            return CGSize(width: homeCLV.bounds.width, height: 240)
        }
        
        return CGSize(width: homeCLV.bounds.width, height: 750)
        
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




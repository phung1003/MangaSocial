//
//  searchVC.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 11/03/2023.
//

import UIKit
import JGProgressHUD
import GoogleMobileAds
import Firebase


class searchVC: UIViewController, GADFullScreenContentDelegate {
    
    @IBOutlet weak var topView:UIView!
    @IBOutlet weak var searchTf:UITextField!
    @IBOutlet weak var searchCLV:UICollectionView!
    
    var mangas = [SearchModel]()
    var fillerData = [DetailManga]()
    var textFind = ""
    
    var interstitial: GADInterstitialAd?
    
    var screenEnterTime: Date?

    
    let hud = JGProgressHUD()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        viewConfig()
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [AnalyticsParameterScreenName: "searchVC"])
        screenEnterTime = Date()

        
        if NetworkMonitor.shared.isConnected {
            print("You're on connected")
        }else{
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: false, completion: nil)
//            return
        }
        searchCLV.register(UINib(nibName: "searchCell", bundle: nil), forCellWithReuseIdentifier: "searchCell")
        if textFind != ""
        {
            DispatchQueue.main.async { [self] in
                findText(text: textFind)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsLogTimeUsing(screen: "searchVC", enterTime: screenEnterTime)
    }
    
    func fetchData() {
        APIService.shared.getAllManga{ [self] (response, error) in
            if let data = response {
                fillerData = data
                searchCLV.reloadData()
            }
        
        }
    }
    private func viewConfig(){
        setGradientBackground()
        topView.layer.backgroundColor = UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1).cgColor

        searchCLV.backgroundColor = .clear
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
    
    func findText(text: String) {
        hud.show(in: self.view)
        APIService.shared.SearchManga(content: text){ [self] (response, error) in
            if let data = response {
                DispatchQueue.main.async { [self] in
                    fillerData.removeAll()
                    fillerData = data
                    hud.dismiss()
                    print(fillerData.count)
                    
                    self.searchCLV.reloadData()
                }
            } else
            {
                hud.dismiss()
            }
        }
    }
    
    @IBAction func didTapSearch(_ sender: UIButton){
        if let text = searchTf.text {
            findText(text: text)
        }
    }
    
    @IBAction func didTapHome(_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func didLastUpdate(_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabVC") as! TabVC
        APIService.shared.getHomeMangaSocial{(data, error) in
            if let data = data {
                vc.homeData = data
                vc.modalPresentationStyle = .fullScreen
                vc.TabView = "Coming"
                self.present(vc, animated: false, completion: nil)
            }
        }
    }
    
    @IBAction func didTapHotManga(_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabVC") as! TabVC
        APIService.shared.getHomeMangaSocial{(data, error) in
            if let data = data {
                vc.homeData = data
                vc.modalPresentationStyle = .fullScreen
                vc.TabView = "Rank Week"
                self.present(vc, animated: false, completion: nil)
            }
        }

    }
    
    @IBAction func didTapNewManga(_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabVC") as! TabVC
        APIService.shared.getHomeMangaSocial{(data, error) in
            if let data = data {
                vc.homeData = data
                vc.modalPresentationStyle = .fullScreen
                vc.TabView = "Rank Month"
                self.present(vc, animated: false, completion: nil)
            }
        }

    }
    
    @IBAction func didTapFloatingBut(_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupVc") as! PopupVc
        vc.modalPresentationStyle = .overFullScreen
        vc.appear(sender: self)
    }
    
    @IBAction func didTapGenre(_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GenresVC") as! GenresVC
        APIService.shared.getHomeMangaSocial{(data, error) in
            if let data = data {
                vc.homeData = data
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false, completion: nil)
            }
        }
    }
    
}

extension searchVC : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fillerData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! searchCell
        cell.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        cell.mangaName.text = fillerData[indexPath.row].title_manga
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let object = fillerData[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailMangaVC") as! DetailMangaVC
        vc.modalPresentationStyle = .fullScreen
        if let name = URL(string: fillerData[indexPath.row].id_manga)?.lastPathComponent{
//            if APIService.webMode {
                vc.linkManga = "https://apimanga.mangasocial.online/web/rmanga/\(APIService.serverIndex)/\(name)"
//            } else
//            {
//                vc.linkManga = "https://apimanga.mangasocial.online/rmanga/\(APIService.serverIndex)/\(name)"
//            }
        }
      
        self.present(vc, animated: false, completion: nil)
    }
}

extension searchVC : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = searchCLV.bounds.width
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! searchCell
        cell.mangaName.text = fillerData[indexPath.row].title_manga
        cell.mangaName.sizeToFit()
        
        return CGSize(width: width, height: cell.mangaName.bounds.height + 10)
    }
}

extension searchVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


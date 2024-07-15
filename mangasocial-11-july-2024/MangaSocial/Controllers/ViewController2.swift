//
//  ViewController2.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 07/03/2023.
//

import UIKit
import GoogleMobileAds

class ViewController2: UIViewController, GADFullScreenContentDelegate {
    
    @IBOutlet weak var topView:UIView!
    @IBOutlet weak var hisAbookView:UIView!
    
    
    @IBOutlet weak var historyTab:UIView!
    @IBOutlet weak var bookMarkTab:UIView!
    
    @IBOutlet weak var historyLb: UILabel!
    @IBOutlet weak var bookMarkLb: UILabel!
    
    @IBOutlet weak var historyLine:UIView!
    @IBOutlet weak var bookMarkLine:UIView!
    
    var item = ""
    var interstitial: GADInterstitialAd?
    

    var containerViewController: hisAbookVC?
    
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
       
        
        if item == "history"{
            tabViewDisplay(t1: false, t2: true, t3: false)
            
        }
        else{
            tabViewDisplay(t1: false, t2: false, t3: true)
        }

        
        
        historyTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(historyTabClick)))
        bookMarkTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bookmarkTabClick)))
    }
    
    private func viewConfig(){
        setGradientBackground()
        topView.backgroundColor = .white
        topView.layer.backgroundColor = UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1).cgColor
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
    
    func tabViewDisplay(t1:Bool,t2:Bool,t3:Bool){
        
        
        if t2 == true{
            historyLb.textColor = .black
            historyLine.backgroundColor = .black
        }
        else{
            historyLb.textColor = .white
            historyLine.backgroundColor = .clear
        }
        
        if t3 == true{
            bookMarkLb.textColor = .black
            bookMarkLine.backgroundColor = .black
        }
        else{
            bookMarkLb.textColor = .white
            bookMarkLine.backgroundColor = .clear
        }
    }
    
    
    @objc func historyTabClick(){
        tabViewDisplay(t1: false, t2: true, t3: false)
        hisAbookView.isHidden = false
        item = "history"
        containerViewController?.changeTab(text: "history")
    }
    
    @objc func bookmarkTabClick(){
        tabViewDisplay(t1: false, t2: false, t3: true)
        hisAbookView.isHidden = false
        item = "bookmark"
        containerViewController?.changeTab(text: "bookmark")
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
    
    
    @IBAction func didTapFloatingBut(_ sender: UIButton){
       
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupVc") as! PopupVc
        vc.modalPresentationStyle = .overFullScreen
        vc.appear(sender: self)
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

extension ViewController2 : ContainerToMaster {
    
    func changeTab(text: String) {
        print("LL")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "hisAbook" {
            containerViewController = segue.destination as? hisAbookVC
            containerViewController?.type = item
            containerViewController?.containerToMaster = self
        }
    }
}

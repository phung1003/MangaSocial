//
//  EditProfileVC.swift
//  MangaSocial
//
//  Created by ATULA on 08/03/2024.
//

import UIKit
import Firebase


class UserProfileVC: UIViewController {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profileCLV: UICollectionView!
    var keys = [String]()
    var values = [Any]()
    var userProfile = ProfileModel()
    
    func viewConfig() {
        avatar.makeRounded()
        setGradientBackground()
    }
    
    var screenEnterTime: Date?

    
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
    
    func fetchData() {
        APIService.shared.getProfile() {data, error in
            if let data2 = data {
                DispatchQueue.main.async { [self] in
                    userProfile = data2
                    avatar.kf.setImage(with: URL(string: data2.avatar_user), placeholder: UIImage(named: "default"))
                    name.text = data2.name_user
                    keys = data2.getKey()
                    values = data2.getValue()
                    profileCLV.reloadData()
                }
                
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        profileCLV.register(UINib(nibName: "ProfileCell", bundle: nil), forCellWithReuseIdentifier: "ProfileCell")
        viewConfig()
        fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [AnalyticsParameterScreenName: "UserProfileVC"])
        screenEnterTime = Date()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsLogTimeUsing(screen: "UserProfileVC", enterTime: screenEnterTime)
    }
    
    @IBAction func didTapEdit(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        vc.modalPresentationStyle = .fullScreen
        vc.userProfile = userProfile
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func didTapBack(_ sender: UIButton){
        self.dismiss(animated: true)
    }
}

extension UserProfileVC : UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        cell.title.text = keys[indexPath.row]
        cell.content.text = values[indexPath.row] as? String
        return cell
    }
    
    
}

extension UserProfileVC : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 10
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func getHeight(pos: Int, width: Double) -> Double {
        var temp = ""
        temp = "\(values[pos])"
        if UIDevice.current.userInterfaceIdiom == .pad {
            var height = temp.height(withConstrainedWidth: width, font: UIFont.systemFont(ofSize: 14)) + 40
            return height
        }
        var height = temp.height(withConstrainedWidth: width, font: UIFont.systemFont(ofSize: 12)) + 40
        return height
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = getHeight(pos: indexPath.row, width: collectionView.frame.width)
        return CGSize(width: collectionView.frame.width , height: height)
        
    }
}


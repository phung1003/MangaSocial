//
//  ViewController.swift
//  MangaSocial
//
//  Created by ATULA on 09/08/2024.
//

import UIKit

class HistoryVC: UIViewController {

    @IBOutlet weak var chooseDate: UIButton!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var serverCLV: UICollectionView!
    @IBOutlet weak var historyCLV: UICollectionView!
    
    
    
    func viewConfig() {
        chooseDate.layer.cornerRadius = 10.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}

/// Đang dở

//extension HistoryVC : UICollectionViewDelegate, UICollectionViewDataSource{
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return keys.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
//        cell.title.text = keys[indexPath.row]
//        cell.content.text = values[indexPath.row] as? String
//        return cell
//    }
//    
//    
//}
//
//extension HistoryVC : UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            return 10
//        }
//        return 10
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//    
//    public func getHeight(pos: Int, width: Double) -> Double {
//        var temp = ""
//        temp = "\(values[pos])"
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            var height = temp.height(withConstrainedWidth: width, font: UIFont.systemFont(ofSize: 14)) + 40
//            return height
//        }
//        var height = temp.height(withConstrainedWidth: width, font: UIFont.systemFont(ofSize: 12)) + 40
//        return height
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let height = getHeight(pos: indexPath.row, width: collectionView.frame.width)
//        return CGSize(width: collectionView.frame.width , height: height)
//        
//    }
//}
//


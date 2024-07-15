//
//  Loading2VC.swift
//  MangaSocialApp
//
//  Created by tuyetvoi on 4/4/23.
//

import UIKit

class Loading2VC: UIViewController {
    @IBOutlet weak var collectionMain:UICollectionView!
    @IBOutlet weak var buttonNext:UIButton!
    var indexSelect = -1
    
    var listDataCate:[String] = ["4-Koma","Adaptation","Award Winning","Doujinshi","Fan Colored","Full Color","Long Strip","Official colored","One Shot","User Created","Web Comic"]
    
    @IBAction func LoadNextApp(){
        if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CartoonMainVC") as? CartoonMainVC{
            vc.modalPresentationStyle = .fullScreen
            present(vc , animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonNext.setTitle("", for: .normal)

        collectionMain.backgroundColor = UIColor.clear
        collectionMain.register(UINib(nibName: "CategoriesSuggestCLVCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesSuggestCLVCell")
    }

}

extension Loading2VC : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indexSelect = indexPath.row
        collectionMain.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listDataCate.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesSuggestCLVCell", for: indexPath) as! CategoriesSuggestCLVCell
        if indexSelect == indexPath.row{
            cell.imageView.image = UIImage(named:"selected-pro")
        }else{
            cell.imageView.image = UIImage(named:"vien-button")
        }
        cell.labelName.text = listDataCate[indexPath.row]
        return cell
    }
}

extension Loading2VC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize.init(width: UIScreen.main.bounds.width / 6 - 10, height: UIScreen.main.bounds.width / 6 - 10)
        }else{
            return CGSize.init(width: UIScreen.main.bounds.width / 3 - 10, height: UIScreen.main.bounds.width / 3 - 10)

        }
    }
}

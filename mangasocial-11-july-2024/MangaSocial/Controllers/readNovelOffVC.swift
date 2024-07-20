

import UIKit

class readNovelOffVC: UIViewController {
    
    @IBOutlet weak var offlineCLV:UICollectionView!
    @IBOutlet weak var upBut: UIButton!
    
    var titleManga = ""
    
    var dataSources = [SaveChapterModel]()
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        print(dataSources)
        viewConfig()
        offlineCLV.register(UINib(nibName: "NovelCell", bundle: nil), forCellWithReuseIdentifier: "NovelCell")
        offlineCLV.register(UINib(nibName: "headerOffReadMangaCell", bundle: nil), forCellWithReuseIdentifier: "headerOffReadMangaCell")
    }
    
    private func viewConfig(){
        setGradientBackground()
        offlineCLV.backgroundColor = .clear
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
    
    
    
    @IBAction func upBut(_ sender: UIButton) {
        offlineCLV.setContentOffset(CGPoint(x:0,y:0), animated: true)
    }

}

extension readNovelOffVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return dataSources.first!.contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerOffReadMangaCell", for: indexPath) as! headerOffReadMangaCell
            cell.mangaName.text = titleManga
            cell.topView.layer.backgroundColor = UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1).cgColor
            cell.backHandler = {
                self.dismiss(animated: true)
            }
            return cell
        }
        
        if indexPath.row > 2 {
            upBut.isHidden = false
        }
        else{
            upBut.isHidden = true
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NovelCell", for: indexPath) as! NovelCell
        cell.content.text = dataSources.first!.contents[indexPath.row].content
       
        return cell
    }
}

extension readNovelOffVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: offlineCLV.bounds.width, height: 75)
        }
        
     
        let width = UIScreen.main.bounds.size.width
        let height = dataSources.first!.contents[indexPath.row].content.height(withConstrainedWidth: width, font: UIFont.systemFont(ofSize: 14))
        return CGSize.init(width: width, height: height)
    }
}

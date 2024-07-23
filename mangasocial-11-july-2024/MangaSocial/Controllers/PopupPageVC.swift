//
//  popupChapterVC.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 20/03/2023.
//

import UIKit

class PopupPageVC: UIViewController {
    
    @IBOutlet weak var backView:UIView!
    @IBOutlet weak var contentView:UIView!
    @IBOutlet weak var pageCLV:UICollectionView!
    
    var maxPage = 0

    var currentIndex = 0
    var callBack : ((Int)->())?
    var mode = 0
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        configView()
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBackView)))
        pageCLV.register(UINib(nibName: "chapterCell", bundle: nil), forCellWithReuseIdentifier: "chapterCell")
    }
    

    func configView(){
        self.view.backgroundColor = .clear
        self.backView.backgroundColor = .black.withAlphaComponent(0.6)
        self.backView.alpha = 0
        self.contentView.alpha = 0
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.black.cgColor
        self.contentView.dropShadow(color: .white, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        self.contentView.layer.cornerRadius = 8
    }
    
    @objc func didTapBackView(){
        hide()
    }
    
    func appear(sender: UIViewController){
        sender.present(self, animated: true)
        self.show()
    }
    
    private func show(){
        UIView.animate(withDuration: 1, delay: 0.1){
            if let son = self.backView{
                self.backView.alpha = 1
                self.contentView.alpha = 1
            }
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0, delay: 0.0, options: .curveEaseOut){
            self.backView.alpha = 0
            self.contentView.alpha = 0
        }completion: { _ in
            self.dismiss(animated: false)
            self.removeFromParent()
        }
    }


}

extension PopupPageVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxPage
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chapterCell", for: indexPath) as! chapterCell
        cell.chapterLb.text = "Page \(indexPath.row+1)"
        cell.layer.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        cell.layer.cornerRadius = 4
        return cell
    }
    

    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            self.hide()
            callBack?(indexPath.row+1)
    }
        
}

extension PopupPageVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: pageCLV.bounds.width - 10, height: 29)
    }
}

extension PopupPageVC : UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

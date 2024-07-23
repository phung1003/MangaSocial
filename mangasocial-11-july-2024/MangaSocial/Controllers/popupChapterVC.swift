//
//  popupChapterVC.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 20/03/2023.
//

import UIKit
import Realm
import RealmSwift
class popupChapterVC: UIViewController {
    
    @IBOutlet weak var backView:UIView!
    @IBOutlet weak var contentView:UIView!
    @IBOutlet weak var tf: UITextField!
    @IBOutlet weak var chapterCLV:UICollectionView!
    
    var linkManga = ""
    var mangaInfo = DetailManga()
    var fillerData = [ChapterInfo]()
    var saveData = [PageRead]()
    var currentIndex = 0
    var callBack : ((Int)->())?
    var mode = 0
    
    var realm = try! Realm()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configView()
        fetchData()
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBackView)))
        chapterCLV.register(UINib(nibName: "chapterCell", bundle: nil), forCellWithReuseIdentifier: "chapterCell")
    }
    
    func fetchData(){
        fillerData = mangaInfo.list_chapter
        saveData = realm.objects(PageRead.self).filter("idUser == %@", APIService.userId).toArray(ofType: PageRead.self)
        
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
    
    @IBAction func textDidChange() {
        if tf.text == "" {
            fillerData = mangaInfo.list_chapter
        }
        else{
            fillerData = mangaInfo.list_chapter.filter{$0.name_chapter.contains(tf.text ?? "")}
        }
        fillerData.reverse()
        chapterCLV.setContentOffset(CGPoint(x:0,y:0), animated: true)
        chapterCLV.reloadData()
    }

}

extension popupChapterVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fillerData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chapterCell", for: indexPath) as! chapterCell
        cell.chapterLb.text = fillerData[indexPath.row].name_chapter
        cell.layer.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor

        if let item = saveData.first(where: {$0.name == fillerData[indexPath.row].link_chapter})
        {
            cell.time.text = "Page Read: \(item.page)"
            fillerData[indexPath.row].maxPage = item.page
            cell.chapterLb.textColor = UIColor.orange
        }
        else {
            cell.time.text = ""
            cell.chapterLb.textColor = UIColor.white
        }
        
        
        
        cell.layer.cornerRadius = 4
        return cell
    }
    
    fileprivate func showManga(_ indexPath: IndexPath) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM DD yyyy"
        let time = dateFormatter.string(from: date)
        
        let dataFilter = realm.objects(HistoryManga.self).filter("link = %@ AND idUser == %@",linkManga, APIService.userId).toArray(ofType: HistoryManga.self).first
        
        if let dataFilter = dataFilter {
            try! realm.write {
                dataFilter.chapter = mangaInfo.list_chapter[indexPath.row].name_chapter
                dataFilter.chapterIndex = currentIndex
                dataFilter.time = time
            }
        }else{
            var data = HistoryManga(image: mangaInfo.poster_manga, title: mangaInfo.title_manga, chapter: mangaInfo.list_chapter[indexPath.row].name_chapter, chapterIndex: indexPath.row, time: time, link: linkManga, idUser: APIService.userId)
            try! realm.write {
                realm.add(data)
                print("Add success")
            }
        }
        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "readMangaVC") as! readMangaVC
        vc1.modalPresentationStyle = .fullScreen
        vc1.linkChapter = fillerData[indexPath.row].link_chapter
        vc1.currentIndex = indexPath.row
        vc1.mangaInfo = mangaInfo
        vc1.maxPage = fillerData[indexPath.row].maxPage
        vc1.linkManga = linkManga
        self.present(vc1, animated: false, completion: nil)
    }
    
    fileprivate func showNovel(_ indexPath: IndexPath) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM DD yyyy"
        let time = dateFormatter.string(from: date)
        
        let dataFilter = realm.objects(HistoryManga.self).filter("link = %@ AND idUser == %@",linkManga, APIService.userId).toArray(ofType: HistoryManga.self).first
        
        if let dataFilter = dataFilter {
            try! realm.write {
                dataFilter.chapter = mangaInfo.list_chapter[indexPath.row].name_chapter
                dataFilter.chapterIndex = currentIndex
                dataFilter.time = time
            }
        }else{
            var data = HistoryManga(image: mangaInfo.poster_manga, title: mangaInfo.title_manga, chapter: mangaInfo.list_chapter[indexPath.row].name_chapter, chapterIndex: indexPath.row, time: time, link: linkManga, idUser: APIService.userId)
            try! realm.write {
                realm.add(data)
                print("Add success")
            }
        }
        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "ReadNovelVC") as! ReadNovelVC
        vc1.modalPresentationStyle = .fullScreen
        vc1.linkChapter = fillerData[indexPath.row].link_chapter
        vc1.currentIndex = indexPath.row
        vc1.mangaInfo = mangaInfo
        vc1.linkManga = linkManga
        self.present(vc1, animated: false, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        
        
        if mode == 0 {
            self.hide()
            callBack?(indexPath.row)
        }
        else {
            if mangaInfo.genres == "novel" {
                showNovel(indexPath)
            }
            showManga(indexPath)
        }
    }
}

extension popupChapterVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: chapterCLV.bounds.width - 10, height: 29)
    }
}

extension popupChapterVC : UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

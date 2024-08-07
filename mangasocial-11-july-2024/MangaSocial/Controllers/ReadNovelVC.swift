//
//  ReadNovelVC.swift
//  MangaSocial
//
//  Created by ATULA on 26/01/2024.
//

import UIKit
import Kingfisher
import RealmSwift
import JGProgressHUD
import GoogleMobileAds
import Firebase

class ReadNovelVC: UIViewController, GADFullScreenContentDelegate {

    @IBOutlet weak var readNovelCLV:UICollectionView!

    @IBOutlet weak var upBut: UIButton!
    
  
    
    lazy var realm = try! Realm()
    
    let hud = JGProgressHUD()
    private var interstitial: GADInterstitialAd?
    var linkChapter = ""
    var mangaInfo = DetailManga()
    var currentIndex = 0
    var dataSources: [NovelModel] = [NovelModel]()
    var commentData: [CommentModel] = [CommentModel]()
    var linkManga = ""
    var commentStruct = CommentStructure()
    var indexSelected = -1
    var editIndex = -1
    var profile = ProfileModel()
    
    var screenEnterTime: Date?

    func maxContentOffset(scrollView: UIScrollView) -> CGPoint {
        var y = (scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)
        if y < 0 {
            y = -y
        }
        return CGPoint(
            x: scrollView.contentSize.width - scrollView.bounds.width + scrollView.contentInset.right,
            y: y)
    }
    
    var keyboardHeight = 0.0
    var originPoint = CGPoint()
    @objc func keyboardWillShow(_ notification: Notification) {
        if keyboardHeight == 0.0 {
            originPoint = readNovelCLV.contentOffset
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                keyboardHeight = keyboardRectangle.height
                var point = readNovelCLV.contentOffset
                point.y += keyboardHeight
                readNovelCLV.setContentOffset(point, animated: true)
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        // Reset the keyboard height when the keyboard hides
        keyboardHeight = 0.0
        readNovelCLV.setContentOffset(originPoint, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
    fileprivate func getComment() {
        APIService.shared.getComment(linkChapter: linkChapter) { (response, error) in
            if let data = response {
                DispatchQueue.main.async { [self] in
                    commentData = data
                    commentStruct.data.removeAll()
                    commentStruct.load(commentData: commentData)
                
                    readNovelCLV.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        APIService.shared.getProfile(){ data, error in
            if let data = data
            {
                DispatchQueue.main.async { [self] in
                    profile = data
                }
                
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM DD yyyy"
        let time = dateFormatter.string(from: date)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let dataFilter = realm.objects(HistoryManga.self).filter("link = %@ AND idUser == %@",linkManga, APIService.userId).toArray(ofType: HistoryManga.self).first
        
        if let dataFilter = dataFilter {
            try! realm.write {
                dataFilter.chapter = mangaInfo.list_chapter[currentIndex].name_chapter
                dataFilter.chapterIndex = currentIndex
                dataFilter.time = time
            }
        }else{
            var data = HistoryManga(image: mangaInfo.poster_manga, title: mangaInfo.title_manga, chapter: mangaInfo.list_chapter[currentIndex].name_chapter, chapterIndex: currentIndex, time: time, link: linkManga, idUser: APIService.userId)
            try! realm.write {
                realm.add(data)
                print("Add success")
            }
        }
        loadAd()
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        let data = realm.objects(PageRead.self).filter("name = %@ AND idUser == %@", linkChapter, APIService.userId)
//        if let data = data.first {
//            try! realm.write {
//                data.page = 0
//            }
//        }
//        else
//        {
//            var data = PageRead(name: linkChapter, page: 0, idUser: APIService.userId)
//            try! realm.write {
//                realm.add(data)
//            }
//            mangaInfo.list_chapter[currentIndex].maxPage = 0
//
//        }
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [AnalyticsParameterScreenName: "ReadNovelVC"])
        screenEnterTime = Date()

        viewConfig()
        fetchData()
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-5372862349743986/3836446225",
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
        readNovelCLV.register(UINib(nibName: "UserCommentCell", bundle: nil), forCellWithReuseIdentifier: "UserCommentCell")
        readNovelCLV.register(UINib(nibName: "headerReadMangaCell", bundle: nil), forCellWithReuseIdentifier: "headerReadMangaCell")
        readNovelCLV.register(UINib(nibName: "NovelCell", bundle: nil), forCellWithReuseIdentifier: "NovelCell")
        readNovelCLV.register(UINib(nibName: "CommentCell", bundle: nil), forCellWithReuseIdentifier: "CommentCell")
        readNovelCLV.register(UINib(nibName: "ReplyCell", bundle: nil), forCellWithReuseIdentifier: "ReplyCell")

        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(endEdit))
        edgePan.edges = .left
        self.view.addGestureRecognizer(edgePan)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsLogTimeUsing(screen: "ReadNovelVC", enterTime: screenEnterTime)
    }
    
    @objc func endEdit() {
        print("as")
        view.endEditing(true)
    }
    
    private func viewConfig(){
    
        setGradientBackground()
        readNovelCLV.backgroundColor = .clear
//        chapterCLV.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
//        chapterCLV.layer.cornerRadius = 8
        hud.style = .dark
      

        upBut.isHidden = true
    }
    
    private func fetchData(){
        hud.show(in: self.view)
        print(linkChapter)
        APIService.shared.getNovelChapter(link: linkChapter) { [self]data, error in
            hud.dismiss()
            if let listdata = data {
                dataSources.append(listdata)
                readNovelCLV.reloadData()
                
            }
        }
        
       
        getComment()
    }
    
    public func reload(){
        print(linkChapter)
        hud.show(in: self.view)
        dataSources.removeAll()
        APIService.shared.getNovelChapter(link: linkChapter) { [self]data, error in
            hud.dismiss()
            if let listdata = data {
                dataSources.append(listdata)
                readNovelCLV.reloadData()
                
            }
        }
        
        getComment()
    }
    
    
    func showAlert2(message: String) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        var cancel = UIAlertAction(title: "Cancel", style: .cancel)
        var action = UIAlertAction(title: "OK", style: .default){action in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        alert.addAction(action)
        alert.addAction(cancel)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
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
    
    @IBAction func didTapUp(_ sender: UIButton){
        readNovelCLV.setContentOffset(CGPoint(x:0,y:0), animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }

}


extension ReadNovelVC : UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if section == 0 {
            return 1
        }
        if section == 2 {
            return 1
        }
        if section == 3 {
            return commentStruct.data.count
        }
        return dataSources.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerReadMangaCell", for: indexPath) as! headerReadMangaCell
            cell.topView.layer.backgroundColor = UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1).cgColor
            cell.mangaName.text = mangaInfo.title_manga
            cell.chapterLb.text = mangaInfo.list_chapter[currentIndex].name_chapter
            cell.chapterLb2.text = mangaInfo.list_chapter[currentIndex].name_chapter
            cell.preBut.layer.backgroundColor = UIColor(red: 0.979, green: 0.149, blue: 0.149, alpha: 1).cgColor
            cell.preBut.layer.cornerRadius = 4
            cell.nexBut.layer.backgroundColor = UIColor(red: 0.979, green: 0.149, blue: 0.149, alpha: 1).cgColor
            cell.nexBut.layer.cornerRadius = 4
            cell.chapterView.layer.cornerRadius = 4
            
            
            cell.backHandler = { [self] in
                self.dismiss(animated: true)
            }
            
            cell.searchHandler = { [self] in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "searchVC") as! searchVC
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false, completion: nil)
            }
            
            cell.saveHandler = { [self] in
                if APIService.userId <= 0 {
                    showAlert2(message: "Please Log In To Continue")
                }
                else {
                    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud.show(in: self.view)
                    let dataFilter1 = realm.objects(SaveMangaModel.self).filter("link = %@ AND idUser == %@", linkManga, APIService.userId).toArray(ofType: SaveMangaModel.self).first
                    if dataFilter1 == nil {
                        downloadImage(with: mangaInfo.poster_manga, fileName: "\(mangaInfo.title_manga) - poster")
                        saveMangaToCore(image: "\(mangaInfo.title_manga) - poster", title: mangaInfo.title_manga, link: linkManga)
                    }
                    
                    let dataFilter2 = realm.objects(SaveNovelModel.self).filter("linkManga = %@ AND chapter = %@ AND idUser == %@", linkManga, mangaInfo.list_chapter[currentIndex].name_chapter, APIService.userId).toArray(ofType: SaveChapterModel.self).first
                    if dataFilter2 == nil {
                        let data = SaveChapterModel(linkManga: linkManga, chapter: mangaInfo.list_chapter[currentIndex].name_chapter, idUser: APIService.userId)
                        var index = 0
                        for i in dataSources {
                            let item = Content(content: i.content)
                            data.contents.append(item)
                            index += 1
                        }
                        print(data.contents[0])
                        try! realm.write {
                            realm.add(data)
                            
                        }
                    }
                    
                    self.hud.dismiss(animated: true)
                }
            }
            
            cell.profileHandler = { [self] in
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileMenuVC") as! ProfileMenuVC
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false, completion: nil)
            }
            
            cell.preHandler = { [self] in
                if currentIndex + 1 > mangaInfo.list_chapter.count - 1 {
                    currentIndex = mangaInfo.list_chapter.count - 1
                    showAlert(title: "Error", message: "This is the first chapter")
                    print(currentIndex)
                    //cell.preBut.isHidden = true
                }
                else{
                    let data = realm.objects(PageRead.self).filter("name = %@ AND idUser == %@", linkChapter, APIService.userId)
                    if let data = data.first {
                        try! realm.write {
                            data.page = 0
                        }
                    }
                    else
                    {
                        var data = PageRead(name: linkChapter, page: 0, idUser: APIService.userId)
                        try! realm.write {
                            realm.add(data)
                        }
                        mangaInfo.list_chapter[currentIndex].maxPage = 0
                    }
                    
                    
                    currentIndex += 1
                    
                    cell.chapterLb.text = mangaInfo.list_chapter[currentIndex].name_chapter
                    cell.chapterLb2.text = mangaInfo.list_chapter[currentIndex].name_chapter
                    linkChapter = mangaInfo.list_chapter[currentIndex].link_chapter
                    reload()
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM DD yyyy"
                    let time = dateFormatter.string(from: date)
                    let dataFilter = realm.objects(HistoryManga.self).filter("link = %@ AND idUser == %@",linkManga, APIService.userId).toArray(ofType: HistoryManga.self).first
                    
                    if let dataFilter = dataFilter {
                        try! realm.write {
                            dataFilter.chapter = mangaInfo.list_chapter[currentIndex].name_chapter
                            dataFilter.chapterIndex = currentIndex
                            dataFilter.time = time
                        }
                    }
                }
                
            }
            
            cell.nextHandler = { [self] in
                
                
                
                if currentIndex - 1 < 0 {
                    
                    print(currentIndex)
                    currentIndex = 0
                    showAlert(title: "Error", message: "This is the last chapter")
                    //cell.nexBut.isHidden = true
                }
                else{
                    let data = realm.objects(PageRead.self).filter("name = %@ AND idUser == %@", linkChapter, APIService.userId)
                    if let data = data.first {
                        try! realm.write {
                            data.page = 0
                        }
                    }
                    else
                    {
                        var data = PageRead(name: linkChapter, page: 0, idUser: APIService.userId)
                        try! realm.write {
                            realm.add(data)
                            
                        }
                        mangaInfo.list_chapter[currentIndex].maxPage = 0
                        
                    }
                    
                    currentIndex -= 1
                   
                    
                    cell.chapterLb.text = mangaInfo.list_chapter[currentIndex].name_chapter
                    cell.chapterLb2.text = mangaInfo.list_chapter[currentIndex].name_chapter
                    linkChapter = mangaInfo.list_chapter[currentIndex].link_chapter
                    reload()
                    
                    
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM DD yyyy"
                    let time = dateFormatter.string(from: date)
                    let dataFilter = realm.objects(HistoryManga.self).filter("link = %@ AND idUser == %@",linkManga, APIService.userId).toArray(ofType: HistoryManga.self).first
                    
                    if let dataFilter = dataFilter {
                        try! realm.write {
                            dataFilter.chapter = mangaInfo.list_chapter[currentIndex].name_chapter
                            dataFilter.chapterIndex = currentIndex
                            dataFilter.time = time
                        }
                    }
                }
                
            }
            
            cell.showAllHandler = { [self] in
                      
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "popupChapterVC") as! popupChapterVC
                vc.modalPresentationStyle = .overFullScreen
                vc.mangaInfo = self.mangaInfo
                vc.currentIndex = self.currentIndex
                vc.appear(sender: self)
                vc.callBack = { [self]
                    index in
                    let data = realm.objects(PageRead.self).filter("name = %@ AND idUser == %@", linkChapter, APIService.userId)
                    if let data = data.first {
                        try! realm.write {
                            data.page = 0
                        }
                    }
                    else
                    {
                        var data = PageRead(name: linkChapter, page: 0, idUser: APIService.userId)
                        try! realm.write {
                            realm.add(data)
                        }
                    }
                    
                    currentIndex = index
                    cell.chapterLb.text = mangaInfo.list_chapter[currentIndex].name_chapter
                    cell.chapterLb2.text = mangaInfo.list_chapter[currentIndex].name_chapter
                    linkChapter = mangaInfo.list_chapter[currentIndex].link_chapter
                    reload()
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM DD yyyy"
                    let time = dateFormatter.string(from: date)
                    let dataFilter = realm.objects(HistoryManga.self).filter("link = %@ AND idUser == %@",linkManga, APIService.userId).toArray(ofType: HistoryManga.self).first
                    
                    if let dataFilter = dataFilter {
                        try! realm.write {
                            dataFilter.chapter = mangaInfo.list_chapter[currentIndex].name_chapter
                            dataFilter.chapterIndex = currentIndex
                            dataFilter.time = time
                        }
                    }
                    
                }
            }
            return cell
        }
        
        if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCommentCell", for: indexPath) as! UserCommentCell
            cell.linkChapter = linkChapter
            cell.scroll = {[self] in
                readNovelCLV.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
            }
            if profile.avatar_user != ""{
                cell.Avatar.kf.setImage(with: URL(string: profile.avatar_user), placeholder: UIImage(named: "default"))
            }
            cell.postHandler = {[self] in
                
                getComment()
            }
            return cell
        }
        
        if indexPath.section == 3 {
            if indexSelected == indexPath.row {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReplyCell", for: indexPath) as! ReplyCell
                if !commentStruct.isRoot(pos: indexPath.row) {
                    cell.whiteLine.isHidden = true
                    cell.idRep = commentStruct.getRoot(pos: indexPath.row)
                }
                else {
                    cell.idRep = commentStruct.getComment(pos: indexPath.row).id_comment
                    cell.whiteLine.isHidden = false
                }
                
                cell.scroll = {[self] in
                    readNovelCLV.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
                }
                
                cell.comment.text = commentStruct.getComment(pos: indexPath.row).content
                cell.name.text = commentStruct.getComment(pos: indexPath.row).name_user
                cell.reply.text = "@\(commentStruct.getComment(pos: indexPath.row).name_user) "
                cell.reply.textColor = UIColor.white

                cell.time.text = commentStruct.getComment(pos: indexPath.row).time_comment
                cell.avatar.kf.setImage(with: URL(string: commentStruct.getComment(pos: indexPath.row).avatar_user), placeholder: UIImage(named: "default"))
                if profile.avatar_user != ""{
                    cell.userAvatar.kf.setImage(with: URL(string: profile.avatar_user), placeholder: UIImage(named: "default"))
                }
                cell.postHandler = {[self] in
                    if APIService.userId <= 0 {
                        showAlert2(message: "Please Log In To Continue")
                    }
                    indexSelected = -1
                    getComment()
                }
                if APIService.userId == commentStruct.getComment(pos: indexPath.row).id_user {
                    cell.deleteBtn.isHidden = false
                }
                else {
                    cell.deleteBtn.isHidden = true
                }
                cell.deleteHandler = {[self] in
                    hud.show(in: self.view)
                    APIService.shared.deleteComment(idComment: indexPath.row) { [self] data, error in
                        if let data = data {
                            getComment()
                            hud.dismiss()
                        }
                    }
                }
                
                return cell
            }
              
            if editIndex == indexPath.row {
                

                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCommentCell", for: indexPath) as! UserCommentCell
                
                cell.linkChapter = linkChapter
              
                cell.scroll = {[self] in
                    readNovelCLV.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
                }
                if profile.avatar_user != ""{
                    cell.Avatar.kf.setImage(with: URL(string: profile.avatar_user), placeholder: UIImage(named: "default"))
                }
                cell.viewEdit(originalComment: commentStruct.getComment(pos: editIndex).content)
                
                cell.postHandler = {[self] in
                    
                    getComment()
                }
                
                cell.editHandler = {[self] in
                    hud.show(in: self.view)
                    APIService.shared.editComment(id: commentStruct.getComment(pos: indexPath.row).id_comment, content: cell.Comment.text!) { [self]data, error in
                        editIndex = -1
                        DispatchQueue.main.async { [self] in
                     
                            if let data = data{
                                getComment()
                                cell.viewConfig()
                                hud.dismiss()
                            } else{
                                if let error = error {
                                    hud.dismiss()
                                    showAlert(title: "Error", message: error)
                                    cell.viewConfig()
                                }
                            }
                  
                        }
                    }
                }
                return cell
            }
                
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentCell", for: indexPath) as! CommentCell
            if !commentStruct.isRoot(pos: indexPath.row) {
                cell.whiteLine.isHidden = true
            }
            else {
                cell.whiteLine.isHidden = false
            }
            if APIService.userId == commentStruct.getComment(pos: indexPath.row).id_user {
                cell.deleteBtn.isHidden = false
                cell.editBtn.isHidden = false
            }
            else {
                cell.deleteBtn.isHidden = true
                cell.editBtn.isHidden = true
            }
            
            cell.deleteHandler = {[self] in
                hud.show(in: self.view)
                APIService.shared.deleteComment(idComment: commentStruct.getComment(pos: indexPath.row).id_comment) { [self] data, error in
                    if let data = data {
                        getComment()
                        hud.dismiss()
                    }
                }
            }
            
            cell.editHandler = {[self] in
                editIndex = indexPath.row
                readNovelCLV.reloadData()
            }
            
            cell.comment.text = commentStruct.getComment(pos: indexPath.row).content
            cell.name.text = commentStruct.getComment(pos: indexPath.row).name_user
            cell.time.text = commentStruct.getComment(pos: indexPath.row).time_comment
            cell.avatar.kf.setImage(with: URL(string: commentStruct.getComment(pos: indexPath.row).avatar_user), placeholder: UIImage(named: "default"))
            if profile.avatar_user != ""{
                cell.avatar.kf.setImage(with: URL(string: profile.avatar_user), placeholder: UIImage(named: "default"))
            }
            cell.replyHandler = {[self] in
                indexSelected = indexPath.row
                readNovelCLV.reloadData()
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
        cell.content.text = dataSources[indexPath.row].content
        return cell
    }
    
    func downloadImage(with urlString : String, fileName: String) {
        guard let url = URL.init(string: urlString) else {
            return
        }
        KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                do {
                    // get the documents directory url
                    let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    print("documentsDirectory:", documentsDirectory.path)
                    // choose a name for your image
                    let fileName = fileName
                    // create the destination file url to save your image
                    let fileURL = documentsDirectory.appendingPathComponent(fileName)
                    if let data = value.image.jpegData(compressionQuality:  1),
                        !FileManager.default.fileExists(atPath: fileURL.path) {
                        // writes the image data to disk
                        try data.write(to: fileURL)
                        print("file saved")
                    }
                } catch {
                    print("error:", error)
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    private func saveMangaToCore(image: String, title: String, link: String) {
        let data = SaveMangaModel(image: image, title: title, link: link, idUser: APIService.userId, genre: "novel")
        try! realm.write {
            realm.add(data)
        }
    }
        
    

}

extension ReadNovelVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 2 {
            return UIEdgeInsets(top: 5, left: 10.0, bottom: 5, right: 10.0)
        }
        if section == 1 {
            return UIEdgeInsets(top: 5, left: 10.0, bottom: 5, right: 10.0)
        }
        return UIEdgeInsets.zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if indexPath.section == 0 {
            return CGSize(width: readNovelCLV.bounds.width, height: 230)
        }
        
        if indexPath.section == 2 {
            return CGSize(width: readNovelCLV.bounds.width, height: 150)
        }
        
        if indexPath.section == 3 {
            if indexSelected == indexPath.row {
                if commentStruct.isRoot(pos: indexPath.row) {
                    let width = readNovelCLV.bounds.width
                    var height = commentStruct.getHeight(pos: indexPath.row, width: width) + 170

                    return CGSize(width: readNovelCLV.bounds.width, height: height )
                }
                else {

                    let width = readNovelCLV.bounds.width - readNovelCLV.bounds.width/5
                    var height = commentStruct.getHeight(pos: indexPath.row, width: width) + 170
                    return CGSize(width: width, height: height )
                }
            }
            
            if editIndex == indexPath.row {
                if !commentStruct.isRoot(pos: indexPath.row) {
                    let width = readNovelCLV.bounds.width - readNovelCLV.bounds.width/5

                    return CGSize(width: width, height: 150 )
                }
                return CGSize(width: readNovelCLV.bounds.width, height: 150)
            }
            
            if commentStruct.isRoot(pos: indexPath.row) {

                let width = readNovelCLV.bounds.width
                var height = commentStruct.getHeight(pos: indexPath.row, width: width) + 20
                return CGSize(width: readNovelCLV.bounds.width, height: height )
            }
            else {

                let width = readNovelCLV.bounds.width - readNovelCLV.bounds.width/8
                var height = commentStruct.getHeight(pos: indexPath.row, width: width) + 20
                return CGSize(width: width, height: height )
            }
        }
        
        var height = dataSources[indexPath.row].content.height(withConstrainedWidth: readNovelCLV.bounds.width - 20, font: UIFont.systemFont(ofSize: 14))
        return CGSize.init(width: readNovelCLV.bounds.width, height: height)
    }
}








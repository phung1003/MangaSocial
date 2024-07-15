//
//  CartoonMainVC.swift
//  MangaSocialApp
//
//  Created by tuyetvoi on 4/6/23.
//

import UIKit

class CartoonMainVC: UIViewController {
    @IBOutlet weak var collectionMain:UICollectionView!
    var listImage : [ImageFaceModel] = [ImageFaceModel]()
    @IBOutlet weak var textFieldMain:UITextField!
    @IBOutlet weak var buttonMain:UIButton!

    @IBAction func LoadNextApp(){
        if let sonpro = textFieldMain.text {
            if sonpro.contains("http") == true &&  (sonpro.contains(".jpg") == true
                ||  sonpro.contains(".jpeg") == true
                                                    ||  sonpro.contains(".png") == true
                                                    ||  sonpro.contains(".jpg")) == true{
                if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ResultImageVC") as? ResultImageVC{
                    vc.imageLink = sonpro
                    vc.modalPresentationStyle = .fullScreen
                    present(vc , animated: true, completion: nil)
                }
            }else{
                let alert = UIAlertController(title: "Input Link For Image", message: "input jpg - png - jpeg", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                        case .default:
                        print("default")
                        
                        case .cancel:
                        print("cancel")
                        
                        case .destructive:
                        print("destructive")
                        
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
        }else{
            let alert = UIAlertController(title: "Input Link For Image", message: "Input Image To Generate Manga", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                    case .default:
                    print("default")
                    
                    case .cancel:
                    print("cancel")
                    
                    case .destructive:
                    print("destructive")
                    
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionMain.register(UINib(nibName: "CartoonImageCLVCell", bundle: nil), forCellWithReuseIdentifier: "CartoonImageCLVCell")
        self.collectionMain.backgroundColor = UIColor.clear
        buttonMain.setTitle("", for: .normal)

        APIService.shared.getListImage(){response,error in
            if let response = response{
                self.listImage = response
                self.collectionMain.reloadData()
            }
        }
    }
 
}
extension CartoonMainVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        textFieldMain.text = listImage[indexPath.row].image
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CartoonImageCLVCell", for: indexPath) as! CartoonImageCLVCell
        cell.imageView.kf.setImage(with: URL(string: listImage[indexPath.row].image))

        return cell
    }
}

extension CartoonMainVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize.init(width: UIScreen.main.bounds.width / 6 - 10, height:200)
        }else{
            return CGSize.init(width: UIScreen.main.bounds.width / 3 - 10, height: 200)

        }
    }
}

//
//  ResultImageVC.swift
//  MangaSocialApp
//
//  Created by tuyetvoi on 4/6/23.
//

import UIKit

class ResultImageVC: UIViewController {
    var imageLink : String = ""
    @IBOutlet weak var imageMain:UIImageView!
    @IBOutlet weak var buttonSave:UIButton!

    @IBAction func LoadNextApp(){
        if let son = imageMain.image{
            UIImageWriteToSavedPhotosAlbum(son, nil, nil, nil)
        }

        if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController{
            vc.modalPresentationStyle = .fullScreen
            present(vc , animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSave.setTitle("", for: .normal)

        APIService.shared.GetDataImageCartoon(imageLink){response,error in
            if let response = response{
                let dataDecoded : Data = Data(base64Encoded: response.link, options: .ignoreUnknownCharacters)!
                let decodedimage = UIImage(data: dataDecoded)
                self.imageMain.image = decodedimage
            }
        }
    }

}

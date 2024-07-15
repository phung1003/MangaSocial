//
//  LoadingAppVC.swift
//  MangaSocialApp
//
//  Created by tuyetvoi on 4/3/23.
//

import UIKit

class LoadingAppVC: UIViewController {
    @IBOutlet weak var buttonMale:UIButton!
    @IBOutlet weak var buttonFemale:UIButton!
    @IBOutlet weak var imagemale:UIImageView!
    @IBOutlet weak var imageFemale:UIImageView!
    @IBOutlet weak var buttonNext:UIButton!
    @IBOutlet weak var slideAge:UISlider!
    @IBOutlet weak var labelAge:UILabel!
    
    @IBOutlet weak var labelMale:UILabel!
    @IBOutlet weak var labelFemale:UILabel!

    var isSelected = true
    
    @objc func sliderValueChanged(sender: UISlider) {
        print(sender.value)
        labelAge.text = String( Int(sender.value)) + " Year Old"
    }
    
    @IBAction func LoadNextApp(){
        
        if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Loading2VC") as? Loading2VC{
            vc.modalPresentationStyle = .fullScreen
            present(vc , animated: true, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelMale.textColor = UIColor.green
        labelFemale.textColor = UIColor.black
        
        buttonNext.setTitle("", for: .normal)

        buttonMale.setTitle("", for: .normal)
        buttonFemale.setTitle("", for: .normal)
        slideAge.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: .valueChanged)

        let tapMaleGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageMaleTapped(tapGestureRecognizer:)))
        imagemale.isUserInteractionEnabled = true
        imagemale.addGestureRecognizer(tapMaleGestureRecognizer)
        
        let tapFemaleGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageFeMaleTapped(tapGestureRecognizer:)))
        imageFemale.isUserInteractionEnabled = true
        imageFemale.addGestureRecognizer(tapFemaleGestureRecognizer)
    }
    var image1 = UIImage(named: "vien-button")
    var image2 = UIImage(named: "selected-pro")

    @IBAction func LoadButtonMale(){
        if isSelected == true{
            labelMale.textColor = UIColor.green
            labelFemale.textColor = UIColor.black
        }else{
            labelMale.textColor = UIColor.black
            labelFemale.textColor = UIColor.green
        }
        isSelected = !isSelected

    }
    @IBAction func LoadButtonFeMale(){
        if isSelected == true{
            labelMale.textColor = UIColor.black
            labelFemale.textColor = UIColor.green
        }else{
            labelMale.textColor = UIColor.green
            labelFemale.textColor = UIColor.black
        }
        isSelected = !isSelected
    }
    @objc func imageMaleTapped(tapGestureRecognizer: UITapGestureRecognizer){
        if isSelected == true{
            labelMale.textColor = UIColor.green
            labelFemale.textColor = UIColor.black
        }else{
            labelMale.textColor = UIColor.black
            labelFemale.textColor = UIColor.green
        }
        isSelected = !isSelected

    }
    
    @objc func imageFeMaleTapped(tapGestureRecognizer: UITapGestureRecognizer){

        if isSelected == true{
            labelMale.textColor = UIColor.black
            labelFemale.textColor = UIColor.green
        }else{
            labelMale.textColor = UIColor.green
            labelFemale.textColor = UIColor.black
        }
        isSelected = !isSelected
    }
}

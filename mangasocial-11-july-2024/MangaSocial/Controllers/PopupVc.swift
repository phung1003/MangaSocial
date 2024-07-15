//
//  PopupVc.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 07/03/2023.
//

import UIKit

class PopupVc: UIViewController {
    
    @IBOutlet weak var backView:UIView!
    @IBOutlet weak var contentView:UIView!
    
    @IBOutlet weak var historyView:UIView!
    @IBOutlet weak var bookmarkView:UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBackView)))
        historyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHistory)))
        bookmarkView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBookMark)))

    }
    
   
   
    @objc func didTapHistory(){

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController2") as! ViewController2
        vc.modalPresentationStyle = .fullScreen
        vc.item = "history"
        self.present(vc, animated: false, completion: nil)
    }
    
    @objc func didTapBookMark(){

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController2") as! ViewController2
        vc.modalPresentationStyle = .fullScreen
        vc.item = "bookmark"
        self.present(vc, animated: false, completion: nil)
    }
    
    @objc func didTapBackView(){

        hide()
    }
    
    func configView(){
        self.view.backgroundColor = .clear
        self.backView.backgroundColor = .black.withAlphaComponent(0.6)
        self.backView.alpha = 0
        self.contentView.alpha = 0
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.white.cgColor
        self.contentView.dropShadow(color: .white, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
    }
    
    func appear(sender: UIViewController){
        sender.present(self, animated: true)
        self.show()
    }
    
    private func show(){
        UIView.animate(withDuration: 1, delay: 0.1){
            self.backView.alpha = 1
            self.contentView.alpha = 1
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseOut){
            self.backView.alpha = 0
            self.contentView.alpha = 0
        }completion: { _ in
            self.dismiss(animated: false)
            self.removeFromParent()
        }
    }
}

extension UIView {

  // OUTPUT 1
  func dropShadow(scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.5
    layer.shadowOffset = CGSize(width: -1, height: 1)
    layer.shadowRadius = 1

    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }

  // OUTPUT 2
  func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = offSet
    layer.shadowRadius = radius

    layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
}

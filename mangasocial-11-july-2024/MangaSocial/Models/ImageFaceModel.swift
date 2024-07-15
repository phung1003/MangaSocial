//
//  ImageFaceModel.swift
//  MangaSocialApp
//
//  Created by tuyetvoi on 4/6/23.
//

import UIKit
// https://raw.githubusercontent.com/sonnh7289/python3-download/main/skhanhphuc.json?fbclid=IwAR256hbvZ66yhEYRrr_QASrGkcmr676l5igCvMmOGEOL2tamyFkpA3CDEo8

class ImageFaceModel: NSObject {
    var image : String = ""
    
    func initLoad(_ json:  [String: Any]) -> ImageFaceModel{
        
        if let temp = json["image"] as? String { image = temp}
        
        return self
    }
}


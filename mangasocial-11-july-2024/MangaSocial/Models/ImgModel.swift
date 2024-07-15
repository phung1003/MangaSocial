//
//  ImgModel.swift
//  CartoonImage
//
//  Created by ATULA on 03/04/2023.
//

import UIKit
class ImgModel: NSObject{
    var link = ""
    func initLoad(_ json:  String) -> ImgModel{
        link = json
        return self
    }
    
}


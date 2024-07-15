//
//  GenresModel.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 12/03/2023.
//

import Foundation

class GenresModel: NSObject {
    var category_name = ""
    var decription = ""
    var image = ""
    func initLoad(_ json: [String:Any]) -> GenresModel {
        if let temp = json["category_name"] as? String {
            category_name = temp
        }
        if let temp = json["decription"] as? String {
            decription = temp
        }
        if let temp = json["image"] as? String {
            image = temp
        }
        return self
    }

}

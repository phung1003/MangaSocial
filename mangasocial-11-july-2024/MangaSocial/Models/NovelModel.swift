//
//  NovelModel.swift
//  MangaSocial
//
//  Created by ATULA on 26/01/2024.
//

import Foundation
class NovelModel: NSObject {
    var content: String = ""
 
    func initLoad(_ json: [String:Any]) -> NovelModel {
        if let temp = json["content"] as? String { content = temp}

        return self
    }
}

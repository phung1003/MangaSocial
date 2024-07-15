//
//  ChapterModel.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 09/03/2023.
//

import Foundation

class ChapterModel : NSObject {
    var imageManga: [String] = [String]()
    
    func initLoad(_ json:  [String: Any]) -> ChapterModel{
        if let temp = json["image_chapter"] as? [String] {
            for item in temp {
                imageManga.append(item)
            }
        }
     
        return self
    }
}

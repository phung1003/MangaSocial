//
//  MangaByTypeModel.swift
//  MangaSocial
//
//  Created by ATULA on 22/07/2024.
//

import Foundation
class MangaByTypeModel: NSObject {
    var page: Int = 0
    var total_page: Int = 0
    var list_manga = [itemMangaModel]()
    func initLoad(_ json: [String:Any]) -> MangaByTypeModel {
        if let temp = json["page_info"] as? [[String:Any]]{
            for item in temp {
                if let temp = item["page"] as? Int {
                    page = temp
                }
                if let temp = item["total_page"] as? Int {
                    total_page = temp
                }
            }
        }
        if let temp = json["list_manga"] as? [[String:Any]] {
            for item in temp {
                var item2 = itemMangaModel()
                list_manga.append(item2.initLoad(item))
            }
        }
        
     
        return self
    }

}

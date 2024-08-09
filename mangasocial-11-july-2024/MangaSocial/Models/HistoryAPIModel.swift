//
//  HistoryAPIModel.swift
//  MangaSocial
//
//  Created by ATULA on 09/08/2024.
//

import Foundation
class HistoryAPIModel: NSObject {
    var link_chapter = ""
    var link_manga = ""
    var poster = ""
    var readAt = ""
    var title_chapter = ""
    var title_manga = ""
    var type = ""
    var index_server = ""
    var name_server = ""
    func initLoad(_ json: [String:Any]) -> HistoryAPIModel {
        if let temp = json["link_chapter"] as? String {
            link_chapter = temp
        }
        if let temp = json["link_manga"] as? String {
            link_manga = temp
        }
        if let temp = json["poster"] as? String {
            poster = temp
        }
        if let temp = json["readAt"] as? String {
            readAt = temp
        }
        if let temp = json["title_chapter"] as? String {
            title_chapter = temp
        }
        if let temp = json["title_manga"] as? String {
            title_manga = temp
        }
        if let temp = json["type"] as? String {
            type = temp
        }
        if let temp = json["index_server"] as? String {
            index_server = temp
        }
        if let temp = json["name_server"] as? String {
            name_server = temp
        }
        
        return self
    }
}

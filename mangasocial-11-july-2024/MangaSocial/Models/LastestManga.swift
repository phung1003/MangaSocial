//
//  LastestManga.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 09/03/2023.
//

import Foundation

class LastestManga: NSObject {
    var lastest_chapter : String = ""
    var link_manga : String = ""
    var poster_manga : String = ""
    var rating_manga : String = ""
    var release_date_manga : String = ""
    var title_manga : String = ""

    func initLoad(_ json:  [String: Any]) -> LastestManga{
        
        if let temp = json["lastest_chapter_manga"] as? String { lastest_chapter = temp}
        if let temp = json["link_manga"] as? String {
            link_manga = temp
        }
        if let temp = json["poster_manga"] as? String {
            poster_manga = temp
        }
        if let temp = json["rating_manga"] as? String { rating_manga = temp}
        if let temp = json["release_date_manga"] as? String { release_date_manga = temp}
        if let temp = json["title_manga"] as? String { title_manga = temp}
        return self
    }
}

//
//  SearchMangaModel.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 09/03/2023.
//

import Foundation

class SearchModel : NSObject{
    var alternative_manga : String = ""
    var genre_manga : String = ""
    var lastest_chapter_manga : String = ""
    var link_manga : String = ""
    var poster_manga : String = ""
    var rating_manga : Int = 0
    var release_manga : String = ""
    var status_manga : String = ""
    var title_manga : String = ""
    
    func initLoad(_ json:  [String: Any]) -> SearchModel{
        
        if let temp = json["alternative_manga"] as? String { alternative_manga = temp}
        if let temp = json["genre_manga"] as? String { genre_manga = temp}
        if let temp = json["lastest_chapter_manga"] as? String { lastest_chapter_manga = temp}
        if let temp = json["link_manga"] as? String {
            link_manga = temp
        }
        if let temp = json["poster_manga"] as? String {
            poster_manga = temp
        }
        if let temp = json["rating_manga"] as? Int { rating_manga = temp}
        if let temp = json["release_manga"] as? String { release_manga = temp}
        if let temp = json["status_manga"] as? String { status_manga = temp}
        if let temp = json["title_manga"] as? String { title_manga = temp}
        return self
    }
}

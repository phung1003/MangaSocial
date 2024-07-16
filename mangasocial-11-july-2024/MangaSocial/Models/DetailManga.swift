//
//  DetailManga.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 09/03/2023.
//

import Foundation

class DetailManga: NSObject{
    var author: String = ""
    var genre_manga : String = ""
    var poster_manga : String = ""
    var rate : String =  ""
    var status_manga : String = ""
    var summary_manga : String = ""
    var title_manga : String = ""
    var views : String = ""
    var list_chapter : [ChapterInfo] = [ChapterInfo]()
    var id_manga: String = ""
    var genres: String = ""
    var r18: Bool = false
    
    func initLoad(_ json:  [String: Any]) -> DetailManga{
        
        if let temp = json["author"] as? String { author = temp}
        if let temp = json["categories"] as? String { genre_manga = temp}
        else if let temp = json["catergories"] as? String { genre_manga = temp}
        if let temp = json["poster"] as? String {
            poster_manga = temp
        }
    
        if let temp = json["id_manga"] as? String {id_manga = temp}
        else if let temp = json["id_novel"] as? String {id_manga = temp}

        
        if let temp = json["rate"] as? String { rate = temp}
        if let temp = json["status"] as? String { status_manga = temp}
        if let temp = json["description"] as? String { summary_manga = temp}
        
        if let temp = json["title"] as? String { title_manga = temp}
        else if let temp = json["title_novel"] as? String { title_manga = temp}

        if let temp = json["views"] as? String { views = temp}
        if let temp = json["chapters"] as? [String: String] {
                   for (key, value) in temp {
                       let item = ChapterInfo(link_chapter: value, name_chapter: key)
                       list_chapter.append(item)
                   }
               } else if let temp = json["chapters"] as? [String] {
                   for (index, value) in temp.enumerated() {
                       let name = "Chapter \(index + 1)"
                       let item = ChapterInfo(link_chapter: value, name_chapter: name)
                       list_chapter.append(item)
                   }
               }

               list_chapter.sort {
                   guard let number1 = extractChapterNumber(from: $0.name_chapter),
                         let number2 = extractChapterNumber(from: $1.name_chapter) else {
                       return false
                   }
                   return number1 > number2
               }
        if let temp = json["genres"] as? String {
            genres = temp
        }
        if let temp = json["r18"] as? Bool {
            r18 = temp
        }
        return self
    }
    
    func extractChapterNumber(from name: String) -> Float? {
        // Sử dụng biểu thức chính quy để tìm số
        let regex = try! NSRegularExpression(pattern: "\\d+(\\.\\d+)?")
        let matches = regex.matches(in: name, range: NSRange(name.startIndex..., in: name))
        
        // Nếu tìm thấy số, trả về số đó
        if let match = matches.first, let range = Range(match.range, in: name) {
            return Float(name[range])
        }
        
        return nil
    }
}
class ChapterInfo: NSObject {
    var link_chapter: String = ""
    var name_chapter: String = ""
    var maxPage = 0

    init(link_chapter: String, name_chapter: String) {
        self.link_chapter = link_chapter
        self.name_chapter = name_chapter
    }

    
}


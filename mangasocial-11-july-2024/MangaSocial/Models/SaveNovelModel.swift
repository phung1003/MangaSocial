//
//  SaveChapterModel.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 16/03/2023.
//

import Foundation
import RealmSwift

class SaveNovelModel : Object {
    @objc dynamic var linkManga: String = ""
    @objc dynamic var chapter: String = ""
    @objc dynamic var idUser: Int = -1
    let contents = List<Content>()
    

    convenience init(linkManga: String, chapter: String, idUser: Int) {
        self.init()
        self.linkManga = linkManga
        self.chapter = chapter
        self.idUser = idUser
    }
}

//class Content : Object {
//    @objc dynamic var content : String = ""
//  
//    
//    convenience init(content: String) {
//        self.init()
//        self.content = content
//      
//    }
//}

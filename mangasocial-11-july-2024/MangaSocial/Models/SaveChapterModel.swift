//
//  SaveChapterModel.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 16/03/2023.
//

import Foundation
import RealmSwift






class SaveChapterModel : Object {
    @objc dynamic var linkManga: String = ""
    @objc dynamic var chapter: String = ""
    @objc dynamic var idUser: Int = -1
    let images = List<imageSize>()
    let contents = List<Content>()

    

    convenience init(linkManga: String, chapter: String, idUser: Int) {
        self.init()
        self.linkManga = linkManga
        self.chapter = chapter
        self.idUser = idUser
    }
}

class imageSize : Object {
    @objc dynamic var width : Double = 0.0
    @objc dynamic var heigth : Double = 0.0
    @objc dynamic var fileName : String = ""
    
    convenience init(width: Double, height: Double, fileName: String) {
        self.init()
        self.width = width
        self.heigth = height
        self.fileName = fileName
    }
}

class Content : Object {
    @objc dynamic var content : String = ""
  
    
    convenience init(content: String) {
        self.init()
        self.content = content
      
    }
}

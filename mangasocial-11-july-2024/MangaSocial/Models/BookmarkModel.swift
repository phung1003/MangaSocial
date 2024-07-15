//
//  BookmarkModel.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 13/03/2023.
//

import Foundation
import RealmSwift

class BookmarkManga : Object{
    @objc dynamic var image: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var chapter: String = ""
    @objc dynamic var link: String = ""
    @objc dynamic var idUser: Int = -1
    convenience init(image: String, title: String, chapter: String, link: String, idUser: Int) {
        self.init()
        self.image = image
        self.title = title
        self.chapter = chapter
        self.link = link
        self.idUser = idUser
    }
}



//
//  HistoryModel.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 12/03/2023.
//

import Foundation
import RealmSwift

class HistoryManga: Object {
    @objc dynamic var image: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var chapter: String = ""
    @objc dynamic var  chapterIndex: Int = 0
    @objc dynamic var time: String = ""
    @objc dynamic var link: String = ""
    @objc dynamic var idUser: Int = -1
    convenience init(image: String, title: String, chapter: String, chapterIndex: Int,time: String, link: String, idUser: Int) {
        self.init()
        self.idUser = idUser
        self.image = image
        self.title = title
        self.chapter = chapter
        self.chapterIndex = chapterIndex
        self.time = time
        self.link = link
    }
}

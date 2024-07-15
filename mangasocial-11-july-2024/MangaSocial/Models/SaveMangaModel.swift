//
//  SaveMangaModel.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 16/03/2023.
//

import Foundation
import RealmSwift

class SaveMangaModel : Object{
    @objc dynamic var image: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var link: String = ""
    @objc dynamic var idUser: Int = -1
    @objc dynamic var genre: String = ""

    convenience init(image: String, title: String, link: String, idUser: Int, genre: String) {
        self.init()
        self.image = image
        self.title = title
        self.link = link
        self.idUser = idUser
        self.genre = genre
    }
}

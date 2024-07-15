//
//  PageRead.swift
//  MangaSocial
//
//  Created by ATULA on 18/01/2024.
//

import Foundation
import Realm
import RealmSwift
class PageRead: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var page: Int = 0
    @objc dynamic var idUser: Int = -1
    convenience init(name: String, page: Int, idUser: Int) {
        self.init()
        self.idUser = idUser
        self.name = name
        self.page = page
    }
    
}

//
//  Comment.swift
//  MangaSocial
//
//  Created by ATULA on 23/01/2024.
//

import Foundation
class CommentModel: NSObject {
    var name_user: String = ""
    var id_comment: Int = 0
    var avatar_user: String = ""
    var content: String = ""
    var like_count: Int = 0
    var replied_comment: [CommentModel] = [CommentModel]()
    var time_comment: String = ""
    var id_user: Int = 0
    var msg = ""
    func initLoad(_ json: [String:Any]) -> CommentModel {
        if let temp = json["name_user"] as? String { name_user = temp}
        if let temp = json["id_comment"] as? Int { id_comment = temp}
        if let temp = json["avatar_user"] as? String { avatar_user = temp}
        if let temp = json["content"] as? String { content = temp}
        if let temp = json["like_count"] as? Int { like_count = temp}
        if let temp = json["replied_comment"] as? [[String:Any]]
        {
            for item in temp{
                var item2: CommentModel = CommentModel()
                item2.initLoad(item)
                replied_comment.append(item2)
            }
        }
        if let temp = json["time_comment"] as? String { time_comment = temp}
        if let temp = json["id_user"] as? Int {id_user = temp}
        return self
    }
}

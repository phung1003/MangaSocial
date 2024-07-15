//
//  CommentStructure.swift
//  MangaSocial
//
//  Created by ATULA on 05/02/2024.
//

import Foundation
import UIKit

class CommentStructure: NSObject {
    var data = [(Int, CommentModel)]()
    
    public func load(commentData: [CommentModel]) {
        for item in commentData {
            let temp = (-1, item)
            data.append(temp)
            for item2 in item.replied_comment {
                let temp = (item.id_comment, item2)
                data.append(temp)
            }
        }
    }
    
    public func getRoot(pos: Int) -> Int {
        return data[pos].0
    }
   
    public func getComment(pos: Int) -> CommentModel {
        return data[pos].1
    }
    
    public func getHeight(pos: Int, width: Double) -> Double {
        if UIDevice.current.userInterfaceIdiom == .pad {
            var height = data[pos].1.content.height(withConstrainedWidth: width, font: UIFont.systemFont(ofSize: 18))
            height += data[pos].1.name_user.height(withConstrainedWidth: width, font: UIFont.boldSystemFont(ofSize: 25))
            height += data[pos].1.time_comment.height(withConstrainedWidth: width, font: UIFont.systemFont(ofSize: 12))
            return height
        }
        var height = data[pos].1.content.height(withConstrainedWidth: width, font: UIFont.systemFont(ofSize: 14))
        height += data[pos].1.name_user.height(withConstrainedWidth: width, font: UIFont.boldSystemFont(ofSize: 17))
        height += data[pos].1.time_comment.height(withConstrainedWidth: width, font: UIFont.systemFont(ofSize: 10)) 
        return height
    }
    
    public func isRoot(pos:Int) -> Bool {
        if getRoot(pos: pos) < 0 {
            return true
        }
        return false
    }
}

//
//  ServerModel.swift
//  MangaSocial
//
//  Created by ATULA on 09/08/2024.
//

import Foundation
class ServerModel: NSObject {
    var server_image = ""
    var server_index = ""
    var server_name = ""
    func initLoad(_ json: [String:Any]) -> ServerModel {
        if let temp = json["server_image"] as? String { server_image = temp}
        if let temp = json["server_index"] as? String { server_index = temp}
        if let temp = json["server_name"] as? String { server_name = temp}

        return self
    }
}



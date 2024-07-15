//
//  UserModel.swift
//  MangaSocial
//
//  Created by ATULA on 24/01/2024.
//

import Foundation
class UserModel:NSObject {
    var account: AccountModel = AccountModel()
    var errCode: Int = 0
    var message: String = ""
    func initLoad(_ json: [String:Any]) -> UserModel {
        if let temp = json["account"] as? [String:Any] {
            account = account.initLoad(temp)
        }
        if let temp = json["errCode"] as? Int {
            errCode = temp
        }
        if let temp = json["message"] as? String {
            message = temp
        }
        return self
    }
    
}

class AccountModel: NSObject {
    var email: String = ""
    var id_user: Int = -1
    var password: String = ""
    func initLoad(_ json: [String:Any]) -> AccountModel {
        if let temp = json["email"] as? String {
            email = temp
        }
        if let temp = json["id_user"] as? Int {
            id_user = temp
        }
        if let temp = json["password"] as? String {
            password = temp
        }
        return self
    }
}

//
//  ProfileModel.swift
//  MangaSocial
//
//  Created by ATULA on 25/01/2024.
//

import Foundation
class ProfileModel: NSObject {
    var avatar_user: String = ""
    var date_of_birth: String = ""
    var gender: String = ""
    var introduction: String = ""
    var job: String = ""
    var name_user: String = ""
    var participation_time: String = ""
    var number_comments: String = ""
    var number_reads: String = ""
    func initLoad(_ json: [String:Any]) -> ProfileModel {
        if let temp = json["avatar_user"] as? String {
            avatar_user = temp
        }
        if let temp = json["date_of_birth"] as? String {
            date_of_birth = temp
        }
        if let temp = json["gender"] as? String {
            gender = temp
        }
        if let temp = json["introduction"] as? String {
            introduction = temp
        }
        if let temp = json["job"] as? String {
            job = temp
        }
        if let temp = json["name_user"] as? String {
            name_user = temp
        }
        if let temp = json["number_comments"] as? String {
            number_comments = temp
        }
        if let temp = json["number_reads"] as? String {
            number_reads = temp
        }
        if let temp = json["participation_time"] as? String {
            participation_time = temp
        }
        
        return self
    }
    
    func getKey() -> [String] {
        var temp = [String]()
        temp.append("Username")
        temp.append("Date of birth")
        temp.append("Gender")
        temp.append("Job")
        temp.append("Introduction")

        temp.append("Participation time")
        temp.append("Number of readings")
        temp.append("Number of comments")
        return temp
    }
    
    func getValue() -> [Any] {
        var temp = [Any]()
        temp.append(name_user)
        temp.append(date_of_birth)
        temp.append(gender)
        temp.append(job)
        temp.append(introduction)
        temp.append(participation_time)
        temp.append(number_reads)
        temp.append(number_comments)
        return temp
    }
    
}

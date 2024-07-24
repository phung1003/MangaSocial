//
//  APIManager.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 09/03/2023.
//

import Foundation
import UIKit

enum APIError: Error{
    case custom(message: String)
}

typealias ApiCompletion = (_ data: Any?, _ error: Error?) -> ()

typealias ApiParam = [String: Any]

typealias Handler = (Swift.Result<Any?, APIError>)-> Void
enum ApiMethod: String {
    case GET = "GET"
    case POST = "POST"
}
extension String {
    func addingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
}

extension Dictionary {
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).addingPercentEncodingForURLQueryValue()!
            if value is String {
                let percentEscapedValue = (value as! String).addingPercentEncodingForURLQueryValue()!
                return "\(percentEscapedKey)=\(percentEscapedValue)"
            }
            else {
                return "\(percentEscapedKey)=\(value)"
            }
        }
        return parameterArray.joined(separator: "&")
    }
}
class APIService:NSObject {
    static var userId: Int = 0
    static var serverIndex: String = "1"
    static var isLogin: Bool = false
    static var webMode: Bool = false
    static let shared: APIService = APIService()
    
    //   pod 'SwiftKeychainWrapper'
    func requestImageCartoon(_ url: String,
                             _ path: String,
                             param: ApiParam?,
                             method: ApiMethod,
                             loading: Bool,
                             completion: @escaping ApiCompletion)
    {
        var request:URLRequest!
        
        // set method & param
        if method == .GET {
            let headers: Dictionary = ["Link-Full": path]
            if let paramString = param?.stringFromHttpParameters() {
                request = URLRequest(url: URL(string:"\(url)?\(paramString)")!)
            }
            else {
                request = URLRequest(url: URL(string:url)!)
            }
            request.allHTTPHeaderFields = headers
        }
        else if method == .POST {
            request = URLRequest(url: URL(string:url)!)
            
            // content-type
            let headers: Dictionary = ["Content-Type": "application/json"]
            request.allHTTPHeaderFields = headers
            
            do {
                if let p = param {
                    request.httpBody = try JSONSerialization.data(withJSONObject: p, options: .prettyPrinted)
                }
            } catch { }
        }
        
        request.timeoutInterval = 30
        request.httpMethod = method.rawValue
        
        //
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                
                // check for fundamental networking error
                guard let data = data, error == nil else {
                    completion(nil, error)
                    return
                }
                
                // check for http errors
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200, let res = response {
                }
                
                if let resJson = self.convertToJson(data) {
                    completion(resJson, nil)
                }
                else if let resString = String(data: data, encoding: .utf8) {
                    completion(resString, error)
                }
                else {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    func requestSON(_ url: String,
                    param: ApiParam?,
                    method: ApiMethod,
                    loading: Bool,
                    value: String,
                    completion: @escaping ApiCompletion)
    {
        var request:URLRequest!
        var urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        // set method & param
        if method == .GET {
            if let paramString = param?.stringFromHttpParameters() {
                request = URLRequest(url: URL(string:"\(urlString)?\(paramString)")!)
                let headers: Dictionary = ["Content-Type": "application/json",
                                           "link-full": value]
                request.allHTTPHeaderFields = headers
            }
            else {
                request = URLRequest(url: URL(string:urlString!)!)
                let headers: Dictionary = ["Content-Type": "application/json",
                                           "link-full": value]
                request.allHTTPHeaderFields = headers
            }
        }
        else if method == .POST {
            request = URLRequest(url: URL(string:url)!)
            
            // content-type
            let headers: Dictionary = ["Content-Type": "application/json"]
            request.allHTTPHeaderFields = headers
            
            do {
                if let p = param {
                    request.httpBody = try JSONSerialization.data(withJSONObject: p, options: .prettyPrinted)
                }
            } catch { }
        }
        
        request.timeoutInterval = 30
        request.httpMethod = method.rawValue
        
        //
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                
                // check for fundamental networking error
                guard let data = data, error == nil else {
                    completion(nil, error)
                    return
                }
                
                // check for http errors
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200, let res = response {
                }
                
                if let resJson = self.convertToJson(data) {
                    completion(resJson, nil)
                }
                else if let resString = String(data: data, encoding: .utf8) {
                    completion(resString, error)
                }
                else {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    private func convertToJson(_ byData: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: byData, options: [])
        } catch {
            //            self.debug("convert to json error: \(error)")
        }
        return nil
    }
    
    
    func getListImage( closure: @escaping (_ response: [ImageFaceModel]?, _ error: Error?) -> Void){
        requestSON("https://raw.githubusercontent.com/sonnh7289/python3-download/main/skhanhphuc.json?fbclid=IwAR256hbvZ66yhEYRrr_QASrGkcmr676l5igCvMmOGEOL2tamyFkpA3CDEo8" , param: nil, method: .GET, loading: true, value: "") { (data, error) in
            var listComicReturn:[ImageFaceModel] = [ImageFaceModel]()
            if let data = data as? [[String : Any]]{
                for item in data{
                    var sonpro:ImageFaceModel = ImageFaceModel()
                    sonpro = sonpro.initLoad(item)
                    listComicReturn.append(sonpro)
                }
                closure(listComicReturn, nil)
            }else{
                closure(nil,nil)
            }
        }
    }
    
    func GetDataImageCartoon(_ path:String, closure: @escaping (_ response: ImgModel?, _ error: Error?) -> Void) {
        requestImageCartoon("http://14.231.223.63:1989/cartoon",path, param: nil, method: .GET, loading: true) { (data, error) in
            if let data = data as? String{
                var  returnData:ImgModel = ImgModel()
                returnData = returnData.initLoad(data)
                closure(returnData,nil)
            }else{
                closure(nil,nil)
            }
        }
        closure(nil, nil)
        
    }
    
    func getHomeMangaSocial(closure: @escaping (_ response: HomeMangaSocialModel?, _ error: Error?) -> Void) {
        let baseURL = "https://apimanga.mangasocial.online/\(APIService.serverIndex)"
        let endpoint = (APIService.serverIndex == "11" || APIService.serverIndex == "4") ? "novel" : "manga"
        let url = "\(baseURL)/\(endpoint)/\(APIService.userId)"
        
        requestSON(url, param: nil, method: .GET, loading: true, value: "") { (data, error) in
            var homeMainReturn = HomeMangaSocialModel()
            if let data2 = data as? [[String: Any]] {
                homeMainReturn = homeMainReturn.initLoad(data2)
                closure(homeMainReturn, error)
            } else {
                closure(nil, error)
            }
        }
    }
    
    func getHomeByType(_ type: String, _ page: Int, closure: @escaping (_ response: MangaByTypeModel?, _ error: Error?) -> Void) {
        let baseURL = "https://apimanga.mangasocial.online/\(APIService.serverIndex)"
        let endpoint = (APIService.serverIndex == "11" || APIService.serverIndex == "4") ? "novel" : "manga"
        var url = "\(baseURL)/\(endpoint)/\(type)/\(page)"
        if type == "new_release_comics" {
            url = "\(baseURL)/\(endpoint)/\(type)/\(page)/\(APIService.userId)"
        }
       
        
        requestSON(url, param: nil, method: .GET, loading: true, value: "") { (data, error) in
            var returnData = MangaByTypeModel()
            if let data2 = data as? [String: Any] {
                returnData = returnData.initLoad(data2)
                closure(returnData, nil)
            } else {
                closure(nil, error)
            }
        }
    }
    
    func getDetailManga(link: String, closure: @escaping (_ response: DetailManga?, _ error: Error?) -> Void){
        print(link)
        requestSON(link , param: nil, method: .GET, loading: true, value: "") { (data, error) in
            var returnData:DetailManga = DetailManga()
            if let data2 = data as? [[String : Any]]{
                if let item = data2.first {
                    returnData = returnData.initLoad(item)
                }
                closure(returnData, nil)
            }else if let data2 = data as? [String:Any]{
                returnData = returnData.initLoad(data2)
                closure(returnData,nil)
            }else {
                closure(nil, nil)
            }
        }
    }
    
    func getChapter(link: String, closure: @escaping (_ response: ChapterModel?, _ error: Error?) -> Void){
        requestSON(link , param: nil, method: .GET, loading: true, value: "") { (data, error) in
            var returnData:ChapterModel = ChapterModel()
            if let data2 = data as? [String : Any]{
                returnData = returnData.initLoad(data2)
                closure(returnData, nil)
            }else{
                closure(nil,nil)
            }
        }
    }
    
    func getNovelChapter(link: String, closure: @escaping (_ response: NovelModel?, _ error: Error?) -> Void){
        requestSON(link , param: nil, method: .GET, loading: true, value: "") { (data, error) in
            var returnData:NovelModel = NovelModel()
            if let data2 = data as? [String : Any]{
                returnData = returnData.initLoad(data2)
                closure(returnData, nil)
            }else{
                closure(nil,nil)
            }
        }
    }

    
    func getAllManga( closure: @escaping (_ response: [DetailManga]?, _ error: Error?) -> Void){
        requestSON("http://apimanga.mangasocial.online/server/12" , param: nil, method: .GET, loading: true, value: "") { (data, error) in
            var returnData:[DetailManga] = [DetailManga]()
            if let data2 = data as? [[String : Any]]{
                for item in data2 {
                    var item2: DetailManga = DetailManga()
                    item2.initLoad(item)
                    returnData.append(item2)
                }
                closure(returnData, nil)
            }else{
                closure(nil,nil)
            }
        }
    }
    
    func SearchGenre(content: String, closure: @escaping (_ response: [DetailManga]?, _ error: Error?) -> Void){
        searchBase(url: "https://apimanga.mangasocial.online/search-manga-by-genre-in-sever", content: content) {
            (data, error) in
            var returnData:[DetailManga] = [DetailManga]()
            if let data2 = data{
                for item in data2 {
                    var item2: DetailManga = DetailManga()
                    item2.initLoad(item)
                    returnData.append(item2)
                }
                closure(returnData, nil)
            }else{
                closure(nil,nil)
            }
        }
    }
    
    func getAllGenre( closure: @escaping (_ response: [GenresModel]?, _ error: Error?) -> Void){
        requestSON("https://apimanga.mangasocial.online/manga-categories" , param: nil, method: .GET, loading: true, value: "") { (data, error) in
            if let data = data as? [[String : Any]]{
                var returnData:[GenresModel] = [GenresModel]()
                for item in data {
                    var item2: GenresModel = GenresModel()
                    item2.initLoad(item)
                    returnData.append(item2)
                }
                closure(returnData, nil)
            }else{
                closure(nil,nil)
            }
        }
    }
    
    
    private func searchBase(url: String, content: String, completion: @escaping ([[String: Any]]?, Error?) -> Void) {
        
        //declare parameter as a dictionary which contains string as key and value combination.
        let parameters = ["content": content]
        //create the url with NSURL
        let url = URL(string: "\(url)/\(APIService.serverIndex)")!
        //create the session object
        let session = URLSession.shared
        
        //now create the Request object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            completion(nil, error)
        }
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                return
            }
            
            do {
                //create json object from data
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] else {
                    completion(nil, NSError(domain: "n", code: -100009, userInfo: nil))
                    return
                }
                completion(json, nil)
            } catch let error {
                //print(error.localizedDescription)
                completion(nil, error)
            }
        })
        
        task.resume()
    }
    
    func SearchManga(content: String, closure: @escaping (_ response: [DetailManga]?, _ error: Error?) -> Void){
        searchBase(url: "https://apimanga.mangasocial.online/search-manga-by-name-in-sever", content: content) {
            (data, error) in
            var returnData:[DetailManga] = [DetailManga]()
            if let data2 = data{
                for item in data2 {
                    var item2: DetailManga = DetailManga()
                    item2.initLoad(item)
                    returnData.append(item2)
                }
                closure(returnData, nil)
            }else{
                closure(nil,nil)
            }
        }
    }
    
    
    func Login(email: String, password: String, closure: @escaping (_ response: UserModel?, _ error: Error?) -> Void){
        let parameter = ["email": email, "password": password]
        if APIService.isLogin {
            print("Da Login Roi")
            closure(nil,nil)
        } else {
            BasePost(parameter: parameter, url: "https://apimanga.mangasocial.online/login") {
                (data, error) in
                var returnData:UserModel = UserModel()
                if let data2 = data{
                    returnData = returnData.initLoad(data2)
                    closure(returnData, nil)
                }else{
                    closure(nil,nil)
                }
            }
        }
    }
    
    private func BasePost(parameter: [String: Any], url: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        //declare parameter as a dictionary which contains string as key and value combination.
        let parameters = parameter
        //create the url with NSURL
        let url = URL(string: url)!
        //create the session object
        let session = URLSession.shared
        
        //now create the Request object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            completion(nil, error)
        }
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                return
            }
            
            do {
                //create json object from data
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                    completion(nil, NSError(domain: "n", code: -100009, userInfo: nil))
                    return
                }
                completion(json, nil)
            } catch let error {
                //print(error.localizedDescription)
                completion(nil, error)
            }
        })
        
        task.resume()
    }
    
    func register(email: String, password: String, username: String, closure: @escaping (_ response: UserModel?, _ error: Error?) -> Void){
        let parameter = ["email": email, "password": password, "username": username]
        BasePost(parameter: parameter, url: "https://apimanga.mangasocial.online/register") {
            (data, error) in
            var returnData:UserModel = UserModel()
            if let data2 = data{
                returnData = returnData.initLoad(data2)
                closure(returnData, nil)
            }else{
                closure(nil,nil)
            }
        }
    }
    
    func getProfile( closure: @escaping (_ response: ProfileModel?, _ error: Error?) -> Void){
        requestSON("https://apimanga.mangasocial.online/user/\(APIService.userId)" , param: nil, method: .GET, loading: true, value: "") { (data, error) in
            var returnData:ProfileModel = ProfileModel()
            if let data2 = data as? [String : Any]{
                returnData = returnData.initLoad(data2)
                closure(returnData, nil)
            }else{
                closure(nil,nil)
            }
        }
    }
    
    func logout( closure: @escaping (_ response: UserModel?, _ error: Error?) -> Void){
        requestSON("https://apimanga.mangasocial.online/logout" , param: nil, method: .GET, loading: true, value: "") { (data, error) in
            var returnData:UserModel = UserModel()
            if let data2 = data as? [String : Any]{
                returnData = returnData.initLoad(data2)
                APIService.isLogin = false
                closure(returnData, nil)
                
            }else{
                closure(nil,nil)
            }
        }
    }
    
    func getComment(linkChapter: String, closure: @escaping (_ response: [CommentModel]?, _ error: Error?) -> Void){
        var link = linkChapter
        if linkChapter.hasSuffix("/") {
            link.removeLast()
        }
        if let manga = getSecondLastPathComponent(from: link), let chapter = URL(string: link)?.lastPathComponent {
            requestSON("https://apimanga.mangasocial.online/cmanga/\(manga)/\(chapter)/" , param: nil, method: .GET, loading: true, value: "") { (data, error) in
                var returnData:[CommentModel] = [CommentModel]()
                if let data = data as? [[String : Any]]{
                    for item in data {
                        var item2: CommentModel = CommentModel()
                        item2.initLoad(item)
                        returnData.append(item2)
                    }
                    closure(returnData, nil)
                }else{
                    closure(nil,nil)
                }
            }
        }
    }
    
    
    func postComment(content: String, linkChapter: String, closure: @escaping (_ response: CommentModel?, _ error: Error?) -> Void){
        let parameter = ["content": content]
        var error = ""
        var link = linkChapter
        if linkChapter.hasSuffix("/") {
            link.removeLast()
        }
        if let manga = getSecondLastPathComponent(from: link), let chapter = URL(string: link)?.lastPathComponent {
            print("https://apimanga.mangasocial.online/cmanga/\(manga)/\(chapter)/\(APIService.userId)/")
            BasePost(parameter: parameter, url: "https://apimanga.mangasocial.online/cmanga/\(manga)/\(chapter)/\(APIService.userId)/") {
                (data, error) in
                var returnData:CommentModel = CommentModel()
                if let data2 = data{
                    if let temp = data2["responses"] as? [String:Any] {
                        returnData = returnData.initLoad(temp)
                        closure(returnData, nil)
                    } else {
                        if let temp = data2["msg"] as? String {
                            returnData.msg = temp
                            closure(returnData, nil)
                        }
                    }
                }else{
                    closure(nil,nil)
                }
            }
        }
        
    }
    
    func replyComment(content: String, idComment: Int, closure: @escaping (_ response: CommentModel?, _ error: Error?) -> Void){
        let parameter = ["content": content]
        print("https://apimanga.mangasocial.online/reply-comment/\(APIService.userId)/\(idComment)/")
        BasePost(parameter: parameter, url: "https://apimanga.mangasocial.online/reply-comment/\(APIService.userId)/\(idComment)/") {
            (data, error) in
            var returnData:CommentModel = CommentModel()
            if let data2 = data{
                if let temp = data2["responses"] as? [String:Any] {
                    returnData = returnData.initLoad(temp)
                    closure(returnData, nil)
                }
            }else{
                closure(nil,nil)
            }
        }
        
        
    }
    
    
    
    func getSecondLastPathComponent(from link: String) -> String? {
        guard let url = URL(string: link) else { return nil }
        let components = url.pathComponents
        var temp = components.dropLast().last
        temp  = temp!.replacingOccurrences(of: " ", with: "%20")
        return temp
    }
    
    func deleteMethod(link: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        guard let url = URL(string: link) else {
            print("Error: cannot create URL")
            return
        }
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling DELETE")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                    completion(nil, NSError(domain: "n", code: -100009, userInfo: nil))
                    return
                }
                completion(json, nil)
                
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
    
    func deleteComment( idComment: Int, closure: @escaping (_ response: String?, _ error: Error?) -> Void){
        
        print("https://apimanga.mangasocial.online/delete-comment/\(idComment)/")
        deleteMethod(link: "https://apimanga.mangasocial.online/delete-comment/\(idComment)/") {data, error in
            if let data = data {
                if let item = data["message"] as? String {
                    closure(item, nil)
                }
            }
            else {
                closure(nil, nil)
            }
        }
        
        
    }
    
    func deleteAccount(closure: @escaping (_ response: String?, _ error: Error?) -> Void){
        
        print("https://apimanga.mangasocial.online/user/\(APIService.userId)/")
        deleteMethod(link: "https://apimanga.mangasocial.online/user/\(APIService.userId)/") {data, error in
            if let data = data {
                if let item = data["message"] as? String {
                    closure(item, nil)
                }
            }
            else {
                closure(nil, nil)
            }
        }
    }
    
    func patchMethod(link: String, parameters: [String:Any], completion: @escaping ([String: Any]?, Error?) -> Void) {
        guard let url = URL(string: link) else {
            print("Error: cannot create URL")
            return
        }
        
        // Create model
        struct UploadData: Codable {
            let content: String
        }
        
        // Add data to the model
        
        
        // Convert model to JSON data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        URLSession.shared.dataTask(with: request) { data, response, error in
            //            guard error == nil else {
            //                print("Error: error calling PATCH")
            //                print(error!)
            //                return
            //            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            //            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
            //                print("Error: HTTP request failed")
            //
            //                return
            //            }
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                
                completion(jsonObject, nil)
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
    
    func editComment(id: Int, content: String, closure: @escaping (_ response: String?, _ error: String?) -> Void){
        print("https://apimanga.mangasocial.online/edit-comment/\(id)/")
        let parameters = ["content": content]
        patchMethod(link: "https://apimanga.mangasocial.online/edit-comment/\(id)/", parameters:  parameters) {data, error in
            if let data = data {
                if let item = data["error"] as? String {
                    closure(nil, item)
                }
                else {
                    closure("Done", nil)
                }
            }
            else {
                closure(nil, "Something went wrong, try again")
            }
        }
    }
    
//    func forgotPassword(email: String, new_password: String, confirm_password: String, closure: @escaping (_ response: String?, _ error: String?) -> Void){
//        let parameters = ["email": email, "new_password": new_password, "confirm_password": confirm_password]
//        patchMethod(link: "https://apimanga.mangasocial.online/forgot-password", parameters: parameters) {data, error in
//            if let data = data {
//                if let item = data["message"] as? String {
//                    closure(item, nil)
//                }
//            }
//            else {
//                closure(nil, "Something went wrong, try again")
//            }
//        }
//    }
    
    func forgotPassword(email: String, new_password: String, confirm_password: String, closure: @escaping (_ response: String?, _ error: String?) -> Void) {
        let parameters = ["email": email, "new_password": new_password, "confirm_password": confirm_password]
        patchMethod(link: "https://apimanga.mangasocial.online/forgot-password", parameters: parameters) { data, error in
            if let error = error {
                closure(nil, "Network error: \(error)")
                return
            }
            
            guard let data = data else {
                closure(nil, "No data received")
                return
            }
            
            if let message = data["message"] as? String {
                closure(message, nil)
            } else if let errorMessage = data["error"] as? String {
                closure(nil, errorMessage)
            } else {
                closure(nil, "Unexpected response format")
            }
        }
    }
    
    func editProfile(userProfile: ProfileModel, closure: @escaping (_ response: String?, _ error: String?) -> Void){
        print(userProfile)
        let parameters = ["name_user": userProfile.name_user, "date_of_birth": userProfile.date_of_birth, "gender": userProfile.gender, "job": userProfile.job, "introduction": userProfile.introduction, "avatar_user": userProfile.avatar_user]
        patchMethod(link: "https://apimanga.mangasocial.online/user/setting/\(APIService.userId)", parameters: parameters) {data, error in
            if let data = data {
                if let item = data["message"] as? String {
                    closure(item, nil)
                }
                else {
                    closure(nil, "Something went wrong, try again")
                }
            }
            else {
                closure(nil, "Something went wrong, try again")
            }
        }
    }
    
    func postImage(image: String, closure: @escaping (_ response: String?, _ error: String?) -> Void) {
        postImg(value: image) {data, error in
            if let data = data {
                
                if let item = data["data"] as? [String:Any] {
                    
                    if let item2 = item["url"] as? String{
                        closure(item2, nil)
                    }
                    else {
                        closure(nil, "Ko co url")
                    }
                    
                }
                else {
                    closure(nil, "Ko co truong data" )
                }
                
            }
            else {
                closure(nil, "Request Error")
            }
        }
    }
    
    func postImg(value: String, closure: @escaping (_ response: [String:Any]?, _ error: String?) -> Void){
        let parameters = [
            [
                "key": "image",
                "value": value,
                "type": "text"
            ]] as [[String: Any]]
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = Data()
        var error: Error? = nil
        for param in parameters {
            if param["disabled"] != nil { continue }
            let paramName = param["key"]!
            body += Data("--\(boundary)\r\n".utf8)
            body += Data("Content-Disposition:form-data; name=\"\(paramName)\"".utf8)
            if param["contentType"] != nil {
                body += Data("\r\nContent-Type: \(param["contentType"] as! String)".utf8)
            }
            let paramType = param["type"] as! String
            if paramType == "text" {
                let paramValue = param["value"] as! String
                body += Data("\r\n\r\n\(paramValue)\r\n".utf8)
            } else {
                let paramSrc = param["src"] as! String
                let fileURL = URL(fileURLWithPath: paramSrc)
                if let fileContent = try? Data(contentsOf: fileURL) {
                    body += Data("; filename=\"\(paramSrc)\"\r\n".utf8)
                    body += Data("Content-Type: \"content-type header\"\r\n".utf8)
                    body += Data("\r\n".utf8)
                    body += fileContent
                    body += Data("\r\n".utf8)
                }
            }
        }
        body += Data("--\(boundary)--\r\n".utf8);
        let postData = body
        
        
        var request = URLRequest(url: URL(string: "https://api.imgbb.com/1/upload?key=d06f760752cb09e8b6454bdafedad4ae")!,timeoutInterval: Double.infinity)
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                closure(json, nil)
            } catch {
                closure(nil, "Bug roi")
            }
        }.resume()
        
    }
    
    func changeMode( closure: @escaping (_ response: HomeMangaSocialModel?, _ error: Error?) -> Void){
        requestSON("http://apimanga.mangasocial.online/mode/web-server/\(APIService.userId)" , param: nil, method: .GET, loading: true, value: "") { (data, error) in
            var homeMainReturn:HomeMangaSocialModel = HomeMangaSocialModel()
            if let data2 = data as? [[String : Any]]{
                homeMainReturn = homeMainReturn.initLoad(data2)
                closure(homeMainReturn, error)
            }else{
                closure(nil,error)
            }
        }
    }
    


    func check( closure: @escaping (_ response: String, _ error: Error?) -> Void){
        print("http://apimanga.mangasocial.online/mode/get-web-server/\(APIService.userId)")
        requestSON("http://apimanga.mangasocial.online/mode/get-web-server/\(APIService.userId)" , param: nil, method: .GET, loading: true, value: "") { (data, error) in
      
            if let data2 = data as? [String : Any]{
                if let temp = data2["msg"]{
                    if temp as! String == "on"{
                        APIService.webMode = true
                    }
                    else
                    {
                        APIService.webMode = false
                    }
                    closure(temp as! String, nil)
                }
            }else{
                closure("",error)
            }
        }
    }
    
    
    
}




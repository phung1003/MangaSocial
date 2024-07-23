//
//  HomeMangaSocialModel.swift
//  MangaSocialApp
//
//  Created by khongtinduoc on 1/4/24.
//


import Foundation
class itemMangaModel : NSObject{
    var chapter_new : String = ""
    var image_poster_link_goc : String = ""
    var rate : String = ""
    var time_release : String = ""
    var title_manga : String = ""
    var url_chapter : String = ""
    var url_manga : String = ""
    var author: String = ""
    var categories: String = ""
    var description_manga: String = ""
    
    
    func initLoad(_ json:  [String: Any]) -> itemMangaModel{
        
        if let temp = json["chapter_new"] as? String { chapter_new = temp}
        else if let temp = json["chapter_title"] as? String {chapter_new = temp}
        else if let temp = json["title_chapter"] as? String {chapter_new = temp}
        
        if let temp = json["image_poster_link_goc"] as? String { image_poster_link_goc = temp}
        else if let temp = json["manga_poster"] as? String {image_poster_link_goc = temp}
        else if let temp = json["poster_novel"] as? String {image_poster_link_goc = temp}

        
        if let temp = json["rate"] as? String { rate = temp}
        
        if let temp = json["rate"] as? String { rate = temp}

        
        if let temp = json["time_release"] as? String { time_release = temp }
        else if let temp = json["time_update"] as? String {time_release = temp}

        
        if let temp = json["title_manga"] as? String { title_manga = temp }
        else if let temp = json["manga_title"] as? String {title_manga = temp}
        else if let temp = json["title_novel"] as? String {title_manga = temp}

        if let temp = json["description_manga"] as? String { description_manga = temp }


        if let temp = json["url_chapter"] as? String { url_chapter = temp}
        else if let temp = json["chapter_link_server"] as? String {url_chapter = temp}
        else if let temp = json["link_server_chapter"] as? String {url_chapter = temp}


        if let temp = json["url_manga"] as? String { url_manga = temp}
        else if let temp = json["manga_link_server"] as? String {url_manga = temp}
        else if let temp = json["link_server_novel"] as? String {url_manga = temp}
        
        if let temp = json["categories"] as? String { categories = temp}

        if let temp = json["author"] as? String { author = temp}
        return self
    }
}

class itemNewsModel : NSObject{
    var id_news : String = ""
    var images_poster : String = ""
    var time_news : String = ""
    var title_news : String = ""
    var url_news : String = ""
    
    func initLoad(_ json:  [String: Any]) -> itemNewsModel{
        if let temp = json["id_news"] as? String { id_news = temp}
        if let temp = json["images_poster"] as? String { images_poster = temp}
        if let temp = json["time_news"] as? String { time_news = temp}
        if let temp = json["title_news"] as? String { title_news = temp }
        if let temp = json["url_news"] as? String { url_news = temp }
        return self
    }
}

class itemMangaRankModel : NSObject{
    var categories : String = ""
    var image_poster : String = ""
    var title_manga : String = ""
    var url_manga : String = ""
    var views_week : Int = 0
    
    func initLoad(_ json:  [String: Any]) -> itemMangaRankModel{
        if let temp = json["categories"] as? String { categories = temp}
        if let temp = json["image_poster"] as? String { image_poster = temp}
        if let temp = json["title_manga"] as? String { title_manga = temp}
        if let temp = json["url_manga"] as? String { url_manga = temp }
        if let temp = json["views_week"] as? Int { views_week = temp }
        return self
    }
}

class itemNewUserModel : NSObject{
    var avatar_user : String = ""
    var id_user : Int = 0
    var name_user : String = ""
    var participation_time : String = ""
    
    func initLoad(_ json:  [String: Any]) -> itemNewUserModel{
        if let temp = json["avatar_user"] as? String { avatar_user = temp}
        if let temp = json["id_user"] as? Int { id_user = temp}
        if let temp = json["name_user"] as? String { name_user = temp}
        if let temp = json["participation_time"] as? String { participation_time = temp }
        return self
    }
}

class HomeMangaSocialModel : NSObject{
    var listNewRelease:[itemMangaModel] = [itemMangaModel]()
    var listRecent:[itemMangaModel] = [itemMangaModel]()
    var listRecommended:[itemMangaModel] = [itemMangaModel]()
    var listCooming:[itemMangaModel] = [itemMangaModel]()
    var listTop15:[itemMangaModel] = [itemMangaModel]()
    var listComedy:[itemMangaModel] = [itemMangaModel]()
    var listFree:[itemMangaModel] = [itemMangaModel]()
    var listNewAnimeManga:[itemNewsModel] = [itemNewsModel]()
    var listRankWeek:[itemMangaModel] = [itemMangaModel]()
    var listRankMonth:[itemMangaModel] = [itemMangaModel]()
    var listRankYear:[itemMangaModel] = [itemMangaModel]()
    var listUserNew:[itemNewUserModel] = [itemNewUserModel]()
    
    func initLoad(_ json:  [[String: Any]]) -> HomeMangaSocialModel{
        for item in json{
            if let name = item["name"] as? String {
                if name == "New Release Comics"{
                    if let dataList = item["data"] as? [[String: Any]]{
                        for itemData in dataList{
                            var itemAddData:itemMangaModel = itemMangaModel()
                            itemAddData = itemAddData.initLoad(itemData)
                            listNewRelease.append(itemAddData)
                        }
                    }
                }
                if name == "Recent Comics"{
                    if let dataList = item["data"] as? [[String: Any]]{
                        for itemData in dataList{
                            var itemAddData:itemMangaModel = itemMangaModel()
                            itemAddData = itemAddData.initLoad(itemData)
                            listRecent.append(itemAddData)
                        }
                    }
                }
                if name == "Recommended Comics"{
                    if let dataList = item["data"] as? [[String: Any]]{
                        for itemData in dataList{
                            var itemAddData:itemMangaModel = itemMangaModel()
                            itemAddData = itemAddData.initLoad(itemData)
                            listRecommended.append(itemAddData)
                        }
                    }
                }
                if name == "Cooming Soon Comics"{
                    if let dataList = item["data"] as? [[String: Any]]{
                        for itemData in dataList{
                            var itemAddData:itemMangaModel = itemMangaModel()
                            itemAddData = itemAddData.initLoad(itemData)
                            listCooming.append(itemAddData)
                        }
                    }
                }
                if name == "Top 15 Best Comics Of The Week"{
                    if let dataList = item["data"] as? [[String: Any]]{
                        for itemData in dataList{
                            var itemAddData:itemMangaModel = itemMangaModel()
                            itemAddData = itemAddData.initLoad(itemData)
                            listTop15.append(itemAddData)
                        }
                    }
                }
                if name == "Comedy Comics"{
                    if let dataList = item["data"] as? [[String: Any]]{
                        for itemData in dataList{
                            var itemAddData:itemMangaModel = itemMangaModel()
                            itemAddData = itemAddData.initLoad(itemData)
                            listComedy
                                .append(itemAddData)
                        }
                    }
                }
                if name == "Free Comics"{
                    if let dataList = item["data"] as? [[String: Any]]{
                        for itemData in dataList{
                            var itemAddData:itemMangaModel = itemMangaModel()
                            itemAddData = itemAddData.initLoad(itemData)
                            listFree.append(itemAddData)
                        }
                    }
                }
                if name == "Anime Manga News"{
                    if let dataList = item["data"] as? [[String: Any]]{
                        for itemData in dataList{
                            var itemAddData:itemNewsModel = itemNewsModel()
                            itemAddData = itemAddData.initLoad(itemData)
                            listNewAnimeManga.append(itemAddData)
                        }
                    }
                }
                if name == "Rank Week"{
                    if let dataList = item["data"] as? [[String: Any]]{
                        for itemData in dataList{
                            var itemAddData:itemMangaModel = itemMangaModel()
                            itemAddData = itemAddData.initLoad(itemData)
                            listRankWeek.append(itemAddData)
                        }
                    }
                }
                if name == "Rank Month"{
                    if let dataList = item["data"] as? [[String: Any]]{
                        for itemData in dataList{
                            var itemAddData:itemMangaModel = itemMangaModel()
                            itemAddData = itemAddData.initLoad(itemData)
                            listRankMonth.append(itemAddData)
                        }
                    }
                }
                if name == "Rank Year"{
                    if let dataList = item["data"] as? [[String: Any]]{
                        for itemData in dataList{
                            var itemAddData:itemMangaModel = itemMangaModel()
                            itemAddData = itemAddData.initLoad(itemData)
                            listRankYear.append(itemAddData)
                        }
                    }
                }
                if name == "User New"{
                    if let dataList = item["data"] as? [[String: Any]]{
                        for itemData in dataList{
                            var itemAddData:itemNewUserModel = itemNewUserModel()
                            itemAddData = itemAddData.initLoad(itemData)
                            listUserNew.append(itemAddData)
                        }
                    }
                }
            }
        }
        return self
    }
}


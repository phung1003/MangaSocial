//
//  ImageModel.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 15/03/2023.
//

import UIKit
import RealmSwift

public class ImageModel: Object {
    
    @objc public dynamic  var thumbnail_url = ""
    var width: CGFloat = UIScreen.main.bounds.size.width
    var height: CGFloat = UIScreen.main.bounds.size.height
    
    public static func imageWith(url: String) -> ImageModel{
        let chapterImage = ImageModel()
        chapterImage.thumbnail_url = url
        return chapterImage
    }
}

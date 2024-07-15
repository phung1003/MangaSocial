//
//  File.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 15/03/2023.
//

import Foundation

import UIKit

class PhotoItem: NSObject {
    
    open var index: Int = 0
    open var underlyingImage: UIImage?
    open var photoURL: String?
    open var viewWidth: CGFloat = UIScreen.main.bounds.size.width
    open var viewHeight: CGFloat = UIScreen.main.bounds.size.width * 2

    override init() {
        super.init()
    }
    
    convenience init(image: UIImage) {
        self.init()
        underlyingImage = image
        viewWidth = image.size.width
        viewHeight = image.size.height
    }
    
    convenience init(url: String) {
        self.init()
        photoURL = url
    }
    
    convenience init(url: String, holder: UIImage?) {
        self.init()
        photoURL = url
        underlyingImage = holder
    }
    
    public static func photoWithImage(_ image: UIImage) -> PhotoItem {
        return PhotoItem(image: image)
    }
    
    public static func photoWithImageURL(_ url: String) -> PhotoItem {
        return PhotoItem(url: url)
    }
    
    public static func photoWithImageURL(_ url: String, holder: UIImage?) -> PhotoItem {
        return PhotoItem(url: url, holder: holder)
    }
}

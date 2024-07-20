//
//  TypeCell.swift
//  MangaSocial
//
//  Created by ATULA on 19/07/2024.
//

import UIKit

class TypeCell: UICollectionViewCell {
    var data: [itemMangaModel] = [itemMangaModel]()
    
    var cellWidth: Double = 0
    var cellHeight: Double = 0
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var homeCLV:UICollectionView!
    
}

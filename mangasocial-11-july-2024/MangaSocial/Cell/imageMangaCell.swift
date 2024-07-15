//
//  imageMangaCell.swift
//  MangaSocialApp
//
//  Created by Đỗ Việt on 08/03/2023.
//

import UIKit

protocol imageMangaCellDelegate: AnyObject {
    func didClickOnImage(cell: imageMangaCell)
    func didZoomImage(cell: imageMangaCell, zoomed: Bool)
}

class imageMangaCell: UICollectionViewCell {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageManga:UIImageView!
    @IBOutlet weak var page: UILabel!
    weak var delegate: imageMangaCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        page.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        page.layer.borderWidth = 1
        page.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        
        let zoomGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(zoomWhenDoubleTapped))
        zoomGestureRecognizer.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(zoomGestureRecognizer)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOnView))
        tapGestureRecognizer.numberOfTapsRequired = 1
        contentView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.require(toFail: zoomGestureRecognizer)

        scrollView.minimumZoomScale = 1
        scrollView.zoomScale = 1
        scrollView.maximumZoomScale = 3
    }
        
    @objc private func tappedOnView(_ gesture: UITapGestureRecognizer) {
        delegate?.didClickOnImage(cell: self)
    }

    @objc private func zoomWhenDoubleTapped(_ gesture: UITapGestureRecognizer) {
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
}

extension imageMangaCell: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageManga
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        let isOriginalSize = scrollView.zoomScale == scrollView.minimumZoomScale
        delegate?.didZoomImage(cell: self, zoomed: isOriginalSize)
    }
}

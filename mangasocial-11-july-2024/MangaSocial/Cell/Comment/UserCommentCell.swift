//
//  UserCommentCell.swift
//  MangaSocial
//
//  Created by ATULA on 23/01/2024.
//

import UIKit

class UserCommentCell: UICollectionViewCell, UITextViewDelegate {

    @IBOutlet weak var Avatar: UIImageView!
    @IBOutlet weak var Comment: UITextView!
    @IBOutlet weak var postComment: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var rect: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var whiteLine:UIImageView!
    var postHandler : (()->())?
    var linkChapter: String = ""
    var scroll: (()->())?
    var editHandler: (() -> ())?

    func viewConfig() {
        
        closeBtn.isHidden = true
        postComment.setTitle("Post", for: .normal)
        Comment.text = "Post your comment"
        Comment.textColor = UIColor.lightGray
        rect.isHidden = false
        title.isHidden = false
        whiteLine.isHidden = true
        postComment.isEnabled = false

    }
    
    func viewEdit(originalComment: String) {
        closeBtn.isHidden = false
        postComment.setTitle("Finish", for: .normal)
        Comment.text = originalComment
        Comment.textColor = UIColor.white
        rect.isHidden = true
        title.isHidden = true
        whiteLine.isHidden = false
        postComment.isEnabled = true

    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        viewConfig()
        Avatar.makeRounded()

        Comment.layer.cornerRadius = 15.0
        Comment.layer.masksToBounds = true
        
        postComment.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        postComment.layer.cornerRadius = 8

        Comment.delegate = self

        
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        scroll?()
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
            postComment.isEnabled = true
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Post your comment"
            textView.textColor = UIColor.lightGray
            postComment.isEnabled = false
        }
    }
    
    
    
    func done() {
        if let parent = self.parentViewController as? readMangaVC {
            if let text = Comment.text {
                parent.hud.show(in: parent.view)
                APIService.shared.postComment(content: text, linkChapter: linkChapter){ data, error in
                    if let data = data {
                        DispatchQueue.main.async { [self] in
                            Comment.text = ""
                            postComment.isEnabled = false
                            postHandler?()
                            parent.hud.dismiss()
                        }
                    }
                }
                parent.hud.dismiss()
            }
        }
        else if let parent = self.parentViewController as? ReadNovelVC {
            if let text = Comment.text {
                parent.hud.show(in: parent.view)
                APIService.shared.postComment(content: text, linkChapter: linkChapter){ data, error in
                    if let data = data {
                        DispatchQueue.main.async { [self] in
                            Comment.text = ""
                            postComment.isEnabled = false
                            postHandler?()
                            parent.hud.dismiss()
                        }
                    }
                }
                parent.hud.dismiss()
            }
        }
    }
    
    @IBAction func close() {
        if let parent = self.parentViewController as? readMangaVC {
            parent.editIndex = -1
            parent.imageMangaCLV.reloadData()
        }
        else if let parent = self.parentViewController as? ReadNovelVC {
            parent.editIndex = -1
            parent.readNovelCLV.reloadData()
        }
        viewConfig()
    }
    @IBAction func sendTextfield() {
        if closeBtn.isHidden == false {
            editHandler?()
        }
        else {
            if APIService.userId <= 0 {
                if let parent = self.parentViewController as? readMangaVC{
                    parent.showAlert2(message: "Please Log In To Continue")
                }
                else if let parent = self.parentViewController as? ReadNovelVC {
                    parent.showAlert2(message: "Please Log In To Continue")
                }
            } else {
                done()
                
            }
        }
    }
    
    
    

}
